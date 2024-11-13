class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate_request, only: %i[update]
  skip_before_action :authenticate_request, only: [:create]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      token = JsonWebToken.jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @current_user.borrower? && @current_user.id != params[:id].to_i
      return render json: { error: "You can only update your own profile" }, status: :forbidden
    end

    if @current_user.admin?
      update_params = admin_update_params
    else
      unless @current_user.authenticate(params[:current_password])
        return render json: { error: "Current password is incorrect" }, status: :unprocessable_entity
      end
      update_params = borrower_update_params
    end

    update_params[:notification_pending] = params[:notification_pending] if params.key?(:notification_pending)

    if @user.update(update_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
    render json: { message: "User deleted" }, status: :ok
  end

  def get_loans
    loans = UserService.get_loans(params[:id])
    render json: loans.as_json(include: [:equipment])
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

  def admin_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :occupation, :status, :role, :institution_id, :notification_pending)
  end

  def borrower_update_params
    if params[:user][:password].present? && params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :occupation, :status, :institution_id, :notification_pending)
  end
end
