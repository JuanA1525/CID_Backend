# app/controllers/api/v1/equipment_controller.rb

class Api::V1::EquipmentController < ApplicationController
  before_action :set_equipment, only: %i[ show update destroy ]

  def index
    render json: EquipmentService.index
  end

  def available
    render json: EquipmentService.available
  end

  def show
    render json: EquipmentService.show(@equipment)
  end

  def create
    result = EquipmentService.create(equipment_params)
    if result[:equipment]
      render json: result[:equipment], status: result[:status]
    else
      render json: result[:errors], status: result[:status]
    end
  end

  def update
    result = EquipmentService.update(@equipment, equipment_params)
    if result[:equipment]
      render json: result[:equipment], status: result[:status]
    else
      render json: result[:errors], status: result[:status]
    end
  end

  def destroy
    EquipmentService.destroy(@equipment)
    head :no_content
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Equipment not found" }, status: :not_found
  end

  def equipment_params
    params.require(:equipment).permit(:equipment_type, :condition, :sport_id, :available, :institution_id)
  end
end
