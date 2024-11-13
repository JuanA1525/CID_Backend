class MessageService
  def self.index
    Message.includes(:message_recipients).all
  end

  def self.show(id)
    Message.includes(:message_recipients).find(id)
  end

  def self.create(message_params, recipient_ids)
    message = Message.new(message_params)
    if message.save
      case recipient_ids
      when "all"
        User.find_each do |user|
          MessageRecipient.create(message_id: message.id, user_id: user.id, recipient_category: :all_users)
          user.update(notification_pending: true)
        end
      when "active_loans"
        User.joins(:loans).where(loans: { status: "active" }).distinct.find_each do |user|
          MessageRecipient.create(message_id: message.id, user_id: user.id, recipient_category: :active_loans)
          user.update(notification_pending: true)
        end
      else
        if recipient_ids.is_a?(Array) && recipient_ids.all? { |id| id.is_a?(Integer) }
          recipient_ids.each do |user_id|
            MessageRecipient.create(message_id: message.id, user_id: user_id, recipient_category: :individual)
            user = User.find(user_id)
            user.update(notification_pending: true)
          end
        else
          message.destroy
          return { errors: { recipient_ids: "Invalid recipient_ids value" }, status: :unprocessable_entity }
        end
      end
      { message: message, status: :created }
    else
      { errors: message.errors, status: :unprocessable_entity }
    end
  end

  def self.update(id, message_params)
    message = Message.find(id)
    if message.update(message_params)
      { message: message, status: :ok }
    else
      { errors: message.errors, status: :unprocessable_entity }
    end
  end

  def self.destroy(id)
    message = Message.find(id)
    message.message_recipients.each do |recipient|
      recipient.user.update(notification_pending: false)
    end
    message.message_recipients.destroy_all
    message.destroy
    { message: "Message deleted", status: :ok }
  end

  def self.get_messages_by_user(user_id)
    messages = Message.joins(:message_recipients)
                      .where(message_recipients: { user_id: user_id })
                      .or(Message.joins(:message_recipients).where(message_recipients: { user_id: nil }).where("message_recipients.recipient_category = 'all_users' OR message_recipients.recipient_category = 'active_loans'"))
                      .distinct
    messages
  end
end