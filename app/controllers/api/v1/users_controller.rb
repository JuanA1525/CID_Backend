class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate_request, only: %i[update]
  skip_before_action :authenticate_request, only: [ :create ]

  # GET /users
  def index
    users = UserService.get_all_users
    render json: users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    result = UserService.create_user(user_params)
    if result[:success]
      render json: { token: result[:token] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    result = UserService.update_user(@current_user, @user, params)
    if result[:success]
      render json: result[:user]
    else
      render json: { error: result[:error] || result[:user].errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    UserService.destroy_user(@user)
    render json: { message: "User deleted" }, status: :ok
  end

  def get_loans
    loans = UserService.get_loans(params[:id])
    render json: loans.as_json(include: [ :equipment ])
  end

  private

  def set_user
    @user = UserService.find_user(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :occupation, :status, :institution_id, :notification_pending, :role)
  end
end
