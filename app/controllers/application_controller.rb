class ApplicationController < ActionController::API
  include JsonWebToken
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    unless header
      render json: { error: 'Missing Authorization header' }, status: :unauthorized
      return
    end

    header = header.split(' ').last
    begin
      decoded = JsonWebToken.jwt_decode(header)
    rescue JWT::DecodeError
      render json: { error: 'Invalid Authorization header' }, status: :unauthorized
      return
    end

    @current_user = User.find_by(id: decoded[:user_id])
    unless @current_user
      render json: { error: 'Invalid user' }, status: :unauthorized
    end
  end
end