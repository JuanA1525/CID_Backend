class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate_request, only: %i[update]
  skip_before_action :authenticate_request, only: [ :create ]

  # GET /users
  def index
    users = UserService.index
    render json: users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    result = UserService.create(user_params)
    if result[:user]
      render json: { token: result[:token] }, status: result[:status]
    else
      render json: result[:errors], status: result[:status]
    end
  end

  # PATCH/PUT /users/1
  def update
    result = UserService.update(@current_user, @user, user_params)
    if result[:user]
      render json: result[:user], status: result[:status]
    else
      render json: result[:errors], status: result[:status]
    end
  end

  # DELETE /users/1
  def destroy
    result = UserService.destroy(@user)
    render json: { message: result[:message] }, status: result[:status]
  end

  def get_loans
    loans = UserService.get_loans(params[:id])
    render json: loans
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :occupation, :status, :institution_id, :notification_pending, :role)
  end
end
