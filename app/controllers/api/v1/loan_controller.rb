class Api::V1::LoanController < ApplicationController
  before_action :set_loan, only: %i[ show update destroy ]

  def index
    loans = Loan.all
    render json: loans
  end

  def create
    @loan = Loan.new(loan_params)
    if @loan.save
      @equipment = Equipment.find(@loan.equipment_id)
      @equipment.update(available: false)

      render json: @loan, status: :created
    else
      render json: @loan.errors, status: :unprocessable_entity
    end
  end

  def update
    if @loan.status == "returned"
      @loan.return_date = Time.current
      @equipment = Equipment.find(@loan.equipment_id)
      @equipment.update(available: true)
    end
    if @loan.update(loan_params)
      render json: @loan
    else
      render json: @loan.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @loan
  end

  def destroy
    @loan.destroy
  end

  private

  def loan_params
    params.require(:loan).permit(:user_id, :equipment_id, :loan_date, :return_due_date, :status, :remark)
  end

  def set_loan
    @loan = Loan.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Loan not found" }, status: :not_found
  end
end
