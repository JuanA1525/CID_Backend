class Api::V1::LoansController < ApplicationController
  before_action :set_loan, only: %i[ show update destroy ]

  def index
    loans = Loan.includes(:user).all
    render json: loans.as_json(include: :user)
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
    @loan = Loan.includes(:user).find(params[:id])
    render json: @loan.as_json(include: :user)
  end

  def destroy
    @loan.destroy
  end

  def return_all
    loans = Loan.where(status: "active")
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
    @loan = Loan.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Loan not found" }, status: :not_found
  end
end
