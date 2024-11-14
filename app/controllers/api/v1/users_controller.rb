class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate_request, only: %i[update]
  skip_before_action :authenticate_request, only: [ :create ]

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

      # Enviar mensaje de bienvenida
      MessageService.create(
        {
          user_id: @user.id,
          content: "Welcome to our service! We're glad to have you with us.",
          message_type: "information"
        },
        [ @user.id ]
      )

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

    if params.key?(:notification_pending)
      update_params = { notification_pending: params[:notification_pending] }
    else
      update_params = user_update_params
    end

    if update_params.key?(:password) && !@current_user.authenticate(params[:current_password])
      return render json: { error: "Current password is incorrect" }, status: :unprocessable_entity
    end

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
    render json: loans.as_json(include: [ :equipment ])
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

  def user_update_params
    permitted_params = [ :name, :email, :occupation, :status, :institution_id, :notification_pending ]
    permitted_params += [ :password, :password_confirmation ] if params[:user][:password].present?
    params.require(:user).permit(permitted_params)
  end
end
