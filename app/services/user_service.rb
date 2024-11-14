class UserService
  def self.index
    User.all
  end

  def self.show(user_id)
    User.find(user_id)
  end

  def self.create(params)
    user = User.new(params)
    if user.save
      token = JsonWebToken.jwt_encode(user_id: user.id)

      MessageService.create(
        {
          user_id: user.id,
          content: "Welcome to our service! We're glad to have you with us.",
          message_type: "information"
        },
        [ user.id ]
      )

      { user: user, token: token, status: :created }
    else
      { errors: user.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def self.update(current_user, user, params)
    if current_user.borrower? && current_user.id != user.id
      return { error: "You can only update your own profile", status: :forbidden }
    end

    if params.key?(:notification_pending)
      update_params = { notification_pending: params[:notification_pending] }
    else
      update_params = user_update_params(params)
    end

    if update_params.key?(:password) && !current_user.authenticate(params[:current_password])
      return { error: "Current password is incorrect", status: :unprocessable_entity }
    end

    if user.update(update_params)
      { user: user, status: :ok }
    else
      { errors: user.errors, status: :unprocessable_entity }
    end
  end

  def self.destroy(user)
    user.destroy!
    { message: "User deleted", status: :ok }
  end

  def self.get_loans(user_id)
    loans = UserService.get_loans(user_id)
    loans.as_json(include: [ :equipment ])
  end

  private

  def self.user_update_params(params)
    permitted_params = [ :name, :email, :occupation, :status, :institution_id, :notification_pending ]
    permitted_params += [ :password, :password_confirmation ] if params[:password].present?
    params.permit(permitted_params)
  end

  def self.get_loans(user_id)
    user = User.find(user_id)
    loans = user.loans.order(created_at: :desc)
    loans
  end
end
