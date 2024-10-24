class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :logout, :current_user_info]

  def logout
    session[:user_id] = nil
    render json: { message: "Logged Out" }, status: :created
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user.present? && @user.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { errors: "Invalid email or password" }, status: :unauthorized
    end
  end

  def current_user_info
    if @current_user
      render json: @current_user, status: :ok
    else
      render json: { error: 'No current user' }, status: :not_found
    end
  end
end