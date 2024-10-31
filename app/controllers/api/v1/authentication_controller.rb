class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login logout current_user_info]

  def login
    result = AuthService.login(params[:email], params[:password])
    if result[:user]
      render json: result[:user].as_json.merge(token: result[:token]), status: result[:status]
    else
      render json: { errors: result[:error] }, status: result[:status]
    end
  end

  def logout
    result = AuthService.logout(session)
    render json: { message: result[:message] }, status: result[:status]
  end

  def current_user_info
    result = AuthService.current_user_info(@current_user)
    render json: result[:user] || { error: result[:error] }, status: result[:status]
  end
end
