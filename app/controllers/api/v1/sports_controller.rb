class Api::V1::SportsController < ApplicationController
  # before_action :set_sport, only: %i[ show update destroy ]

  # GET /sports
  def index
    @sports = Sport.all

    render json: @sports
  end

  # GET /sports/1
  def show
    render json: @sport
  end

  # POST /sports
  def create
    @sport = Sport.new(sport_params)

    if @sport.save
      render json: @sport, status: :created
    else
      render json: @sport.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sports/1
  def update
    if @sport.update(sport_params)
      render json: @sport
    else
      render json: @sport.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sports/1
  def destroy
    @sport.destroy
  end

  private
    def set_sport
      @sport = Sport.find(params[:id])
    end

    def sport_params
      params.require(:sport).permit(:name, :description)
    end
end
