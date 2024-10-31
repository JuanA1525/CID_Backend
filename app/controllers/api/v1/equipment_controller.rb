class Api::V1::EquipmentController < ApplicationController
  before_action :set_equipment, only: %i[ show update destroy ]

  # GET /equipment
  def index
    @equipment = Equipment.all

    equipment_with_names = @equipment.map do |equipment|
      name = "#{equipment.equipment_type}_#{equipment.sport.name}_#{equipment.id}"
      sport = "#{equipment.sport.name}"
      equipment.as_json.merge(name: name, sport: sport)
    end

    render json: equipment_with_names
  end

  def available
    @equipment = Equipment.includes(:sport).where(available: true)

    equipment_with_names = @equipment.map do |equipment|
      name = "#{equipment.equipment_type}_#{equipment.sport.name}_#{equipment.id}"
      sport = equipment.sport.name
      equipment.as_json.merge(name: name, sport: sport)
    end

    render json: equipment_with_names
  end

  # GET /equipment/1
  def show
    name = "#{@equipment.equipment_type}_#{@equipment.sport.name}_#{@equipment.id}"
    sport = "#{@equipment.sport.name}"
    render json: @equipment.as_json.merge(name: name, sport: sport)
  end

  # POST /equipment
  def create
    @equipment = Equipment.new(equipment_params)

    if @equipment.save
      name = "#{@equipment.equipment_type}_#{@equipment.sport.name}_#{@equipment.id}"
      sport = "#{@equipment.sport.name}"
      render json: @equipment.as_json.merge(name: name, sport: sport), status: :created
    else
      render json: @equipment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /equipment/1
  def update
    if @equipment.update(equipment_params)
      name = "#{@equipment.equipment_type}_#{@equipment.sport.name}_#{@equipment.id}"
      sport = "#{@equipment.sport.name}"
      render json: @equipment.as_json.merge(name: name, sport: sport)
    else
      render json: @equipment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /equipment/1
  def destroy
    @equipment.destroy
  end

  private

    def set_equipment
      @equipment = Equipment.find(params[:id])
    end

    def equipment_params
      params.require(:equipment).permit(:equipment_type, :condition, :sport_id, :available, :institution_id)
    end
end
