class UserService
  # Obtener todos los usuarios
  def self.get_all_users
    User.all
  end

  # Encontrar un usuario específico
  def self.find_user(user_id)
    User.find(user_id)
  end

  # Crear un nuevo usuario con token de bienvenida
  def self.create_user(user_params)
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.jwt_encode(user_id: user.id)

      # Enviar mensaje de bienvenida
      MessageService.create(
        {
          user_id: user.id,
          content: "Welcome to our service! We're glad to have you with us.",
          message_type: "information"
        },
        [ user.id ]
      )

      { success: true, token: token }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end

  # Actualizar el perfil del usuario
  def self.update_user(current_user, user, params)
    # Permitir actualizar `notification_pending` sin autenticación
    if params.key?(:notification_pending) && params.keys.length == 1
      if user.update(notification_pending: params[:notification_pending])
        return { success: true, user: user }
      else
        return { success: false, errors: user.errors.full_messages }
      end
    end

    # Permitir actualizar `rating_pending` sin autenticación
    if params.key?(:rating_pending) && params.keys.length == 1
      if user.update(rating_pending: params[:rating_pending])
        return { success: true, user: user }
      else
        return { success: false, errors: user.errors.full_messages }
      end
    end

    # Validación de permisos para borrower
    if current_user.borrower? && current_user.id != user.id
      return { success: false, error: "You can only update your own profile" }
    end

    # Verificación de contraseña solo si desea cambiarla
    if params[:user][:password].present? && !current_user.authenticate(params[:current_password])
      return { success: false, error: "Current password is incorrect" }
    end

    # Configuración de parámetros de actualización
    update_params = build_update_params(params)
    if user.update(update_params)
      { success: true, user: user }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end

  # Eliminar un usuario
  def self.destroy_user(user)
    user.destroy!
    { success: true, message: "User deleted" }
  end

  # Obtener préstamos de un usuario
  def self.get_loans(user_id)
    user = find_user(user_id)
    user.loans.includes(:equipment).order(created_at: :desc)
  end

  def self.get_last_loan(user_id)
    user = find_user(user_id)
    user.loans.includes(:equipment).order(created_at: :desc).first
  end

  # Construir parámetros de actualización para el usuario
  def self.build_update_params(params)
    permitted_params = [ :name, :email, :occupation, :status, :institution_id, :notification_pending, :rating_pending, :role ]
    permitted_params += [ :password, :password_confirmation ] if params[:user][:password].present?
    params.require(:user).permit(permitted_params)
  end
end
