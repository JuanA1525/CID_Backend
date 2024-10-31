class Api::V1::LoansController < ApplicationController
  before_action :set_loan, only: %i[ show update destroy ]

  def index
    loans = Loan.includes(:user, :equipment).all
    render json: loans.as_json(include: [:user, :equipment])
  end

  def create
    result = LoanService.create_loan(loan_params)
    if result[:loan]
      render json: result[:loan].as_json(include: [:user, :equipment]), status: result[:status]
    else
      render json: result[:errors] || { error: result[:error] }, status: result[:status]
    end
  end

  def update
    result = LoanService.update_loan(@loan, loan_params)
    if result[:loan]
      render json: result[:loan].as_json(include: [:user, :equipment]), status: result[:status]
    else
      render json: result[:errors] || { error: result[:error] }, status: result[:status]
    end
  end

  def show
    render json: @loan.as_json(include: [:user, :equipment])
  end

  def destroy
    @loan.destroy
    head :no_content
  end

  def return_all
    result = LoanService.return_all_loans
    render json: { message: result[:message] }, status: result[:status]
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