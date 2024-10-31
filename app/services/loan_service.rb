# app/services/loan_service.rb

class LoanService
  def self.create_loan(params)
    equipment = Equipment.find_by(id: params[:equipment_id])

    return { error: "Equipment not found", status: :not_found } unless equipment

    if params[:status] == "active" || params[:status].nil?
      if equipment.available
        equipment.update(available: false)
        loan = Loan.new(params)
        if loan.save
          { loan: loan, status: :created }
        else
          equipment.update(available: true)
          { errors: loan.errors, status: :unprocessable_entity }
        end
      else
        { error: "Equipment is not available", status: :unprocessable_entity }
      end
    else
      { error: "Loan status must be 'active'", status: :unprocessable_entity }
    end
  end

  def self.update_loan(loan, params)
    if params[:status] == "returned"
      loan.return_date = Time.current
      equipment = Equipment.find_by(id: loan.equipment_id)

      if equipment && equipment.update(available: true)
        if loan.update(params)
          { loan: loan, status: :ok }
        else
          { errors: loan.errors, status: :unprocessable_entity }
        end
      else
        { error: "Failed to update equipment availability", status: :unprocessable_entity }
      end
    else
      if loan.update(params)
        { loan: loan, status: :ok }
      else
        { errors: loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def self.return_all_loans
    loans = Loan.includes(:equipment).where(status: "active")
    loans.each do |loan|
      loan.update(status: "returned", return_date: Time.current)
      loan.equipment.update(available: true) if loan.equipment
    end
    { message: "All loans returned", status: :ok }
  end
end
