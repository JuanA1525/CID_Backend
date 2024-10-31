class Api::V1::LoansController < ApplicationController
  before_action :set_loan, only: %i[ show update destroy ]

  def index
    loans = Loan.includes(:user, :equipment).all
    render json: loans.as_json(include: [:user, :equipment])
  end

    def create
    @equipment = Equipment.find(loan_params[:equipment_id])

    if loan_params[:status] == "active" || loan_params[:status].nil?
      if @equipment.available
        @equipment.update(available: false)
        @loan = Loan.new(loan_params)
        if @loan.save
          render json: @loan.as_json(include: [:user, :equipment]), status: :created
        else
          @equipment.update(available: true)
          render json: @loan.errors, status: :unprocessable_entity
        end
      else
        render json: { error: "Equipment is not available" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Loan status must be 'active'" }, status: :unprocessable_entity
    end
  end

    def update
    if loan_params[:status] == "returned"
      @loan.return_date = Time.current
      @equipment = Equipment.find(@loan.equipment_id)
      if @equipment.update(available: true)
        if @loan.update(loan_params)
          render json: @loan.as_json(include: [:user, :equipment])
        else
          render json: @loan.errors, status: :unprocessable_entity
        end
      else
        render json: { error: "Failed to update equipment availability" }, status: :unprocessable_entity
      end
    else
      if @loan.update(loan_params)
        render json: @loan.as_json(include: [:user, :equipment])
      else
        render json: @loan.errors, status: :unprocessable_entity
      end
    end
  end

  def show
    @loan = Loan.includes(:user, :equipment).find(params[:id])
    render json: @loan.as_json(include: [:user, :equipment])
  end

  def destroy
    @loan.destroy
    head :no_content
  end

  def return_all
    loans = Loan.includes(:equipment).where(status: "active")
    loans.each do |loan|
      loan.update(status: "returned", return_date: Time.current)
      loan.equipment.update(available: true)
    end
    render json: { message: "All loans returned" }, status: :ok
  end

  private

  def loan_params
    params.require(:loan).permit(:user_id, :equipment_id, :loan_date, :return_due_date, :status, :remark)
  end

  def set_loan
    @loan = Loan.includes(:user, :equipment).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Loan not found" }, status: :not_found
  end
end