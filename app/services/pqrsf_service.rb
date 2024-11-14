class PqrsfService
  def self.index
    Pqrsf.order(created_at: :desc)
  end

  def self.create(params)
    pqrsf = Pqrsf.new(params)
    if pqrsf.save
      MessageService.create(
        {
          user_id: pqrsf.user_id,
          content: "Your #{pqrsf.pqrsf_type} has been successfully received and will be addressed as soon as possible.",
          message_type: "information"
        },
        [ pqrsf.user_id ]
      )

      user = User.find(pqrsf.user_id)
      admin_ids = User.where(role: "admin").pluck(:id)
      MessageService.create(
        {
          user_id: pqrsf.user_id,
          content: "A new PQRSF (#{pqrsf.pqrsf_type}) made by the user with email #{user.email} has been created and needs to be addressed.",
          message_type: "warning"
        },
        admin_ids
      )

      { pqrsf: pqrsf, status: :created }
    else
      { errors: pqrsf.errors, status: :unprocessable_entity }
    end
  end

  def self.update(pqrsf, params)
    if pqrsf.update(params)
      { pqrsf: pqrsf, status: :ok }
    else
      { errors: pqrsf.errors, status: :unprocessable_entity }
    end
  end

  def self.destroy(pqrsf)
    pqrsf.destroy
    { message: "Pqrsf deleted", status: :ok }
  end

  def self.get_pqrsf_by_user(user_id)
    Pqrsf.where(user_id: user_id).order(created_at: :desc)
  end

  def self.get_pending_pqrsf
    Pqrsf.where(pending: true).order(created_at: :desc)
  end

  def self.get_pqrsf_per_type(pqrsf_type)
    Pqrsf.where(pqrsf_type: pqrsf_type).order(created_at: :desc)
  end
end
