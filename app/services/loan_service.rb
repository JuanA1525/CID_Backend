class LoanService
  def self.create_loan(params)
    if UserService.get_loans(params[:user_id]).any? { |loan| loan.status == "active" }
      return { error: "User already has an active loan", status: :unprocessable_entity }
    end

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
          MessageService.create(
            {
              user_id: loan.user_id,
              content: "Thank you for using our service. Please don't forget to rate your experience.",
              message_type: "information"
            },
            [ loan.user_id ]
          )
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
    loans = Loan.includes(:equipment).where(status: "active").order(created_at: :desc)
    loans.each do |loan|
      loan.update(status: "returned", return_date: Time.current)
      loan.equipment.update(available: true) if loan.equipment
    end
    { message: "All loans returned", status: :ok }
  end

  def self.get_active_loans
    loans = Loan.includes(:user, :equipment).where(status: "active").order(created_at: :desc)
    loans
  end

  def self.add_rating_to_loan(loan, rating_params)
    new_rating = Rating.new(rating_params)
    new_rating.loan = loan
    if new_rating.save
      { rating: new_rating, status: :created }
    else
      { errors: new_rating.errors, status: :unprocessable_entity }
    end
  end

  def self.check_and_update_expired_loans
    loans = Loan.includes(:equipment).where(status: "active")
    loans.each do |loan|
      if loan.return_due_date < Time.current
        loan.update(status: "expired")

        MessageService.create(
          {
            user_id: loan.user_id,
            content: "The time to return the loan has expired. Penalties may apply. Please make the return.",
            message_type: "warning"
          },
          [ loan.user_id ]
        )

        admin_ids = User.where(role: "admin").pluck(:id)
        MessageService.create(
          {
            user_id: loan.user_id,
            content: "The loan for equipment #{loan.equipment.name} has expired. Please take necessary actions.",
            message_type: "warning"
          },
          admin_ids
        )
      end
    end
  end

  def self.test_schedule
    Rails.logger.info "Schedule is working at #{Time.current}"
  end
end
