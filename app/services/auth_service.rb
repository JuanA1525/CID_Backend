# app/services/auth_service.rb

class AuthService
  def self.login(email, password)
    user = User.find_by(email: email)
    if user&.authenticate(password)
      token = JsonWebToken.jwt_encode(user_id: user.id)
      { user: user, token: token, status: :ok }
    else
      { error: "Invalid email or password", status: :unauthorized }
    end
  end

  def self.logout(session)
    session[:user_id] = nil
    { message: "Logged Out", status: :created }
  end

  def self.current_user_info(current_user)
    if current_user
      { user: current_user, status: :ok }
    else
      { error: "No current user", status: :not_found }
    end
  end
end
