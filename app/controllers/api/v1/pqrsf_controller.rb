class Api::V1::PqrsfController < ApplicationController
  before_action :set_pqrsf, only: %i[show update destroy]

  def index
    pqrsf = PqrsfService.index
    render json: pqrsf
  end

  def create
    result = PqrsfService.create(pqrsf_params)
    if result[:pqrsf]
      render json: result[:pqrsf], status: result[:status]
    else
      render json: result[:errors], status: result[:status]
    end
  end

  def update
    result = PqrsfService.update(@pqrsf, pqrsf_params)
    if result[:pqrsf]
      render json: result[:pqrsf], status: result[:status]
    else
      render json: result[:errors], status: result[:status]
    end
  end

  def show
    render json: @pqrsf
  end

  def destroy
    result = PqrsfService.destroy(@pqrsf)
    render json: { message: result[:message] }, status: result[:status]
  end

  private

  def set_pqrsf
    @pqrsf = Pqrsf.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Pqrsf not found" }, status: :not_found
  end

  def pqrsf_params
    params.require(:pqrsf).permit(:user_id, :pqrsf_type, :description, :pending)
  end
end