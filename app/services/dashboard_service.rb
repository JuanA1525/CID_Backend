class DashboardService
  def self.get_summary
    {
      data: [
        { name: "Users", value: User.count },
        { name: "Loans", value: Loan.count },
        { name: "Equipments", value: Equipment.count },
        { name: "Sports", value: Sport.count }
      ],
      status: :ok
    }
  end

  def self.get_loans_info
    {
      data: [
        { name: "Active", value: Loan.where(status: "active").count },
        { name: "Returned", value: Loan.where(status: "returned").count },
        { name: "Expired", value: Loan.where(status: "expired").count }
      ],
      status: :ok
    }
  end

  def self.get_equipment_info
    {
      data: [
        { name: "Available", value: Equipment.where(available: true).count },
        { name: "Unavailable", value: Equipment.where(available: false).count },
        { name: "Perfect", value: Equipment.where(condition: "perfect").count },
        { name: "Good", value: Equipment.where(condition: "good").count },
        { name: "Fair", value: Equipment.where(condition: "fair").count },
        { name: "Acceptable", value: Equipment.where(condition: "acceptable").count },
        { name: "Bad", value: Equipment.where(condition: "bad").count },
        { name: "Unusable", value: Equipment.where(condition: "unusable").count }
      ],
      status: :ok
    }
  end

  def self.get_equipment_per_sport
    sports = Sport.all
    data = sports.map do |sport|
      { name: sport.name, value: Equipment.where(sport_id: sport.id).count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_loans_per_month
    loans = Loan.group_by_month(:created_at).count
    formatted_loans = loans.map do |date, count|
      { name: date.strftime("%Y-%m"), value: count }
    end
    {
      data: formatted_loans,
      status: :ok
    }
  end

  def self.get_loans_per_day
    loans = Loan.group_by_day(:created_at).count
    formatted_loans = loans.map do |date, count|
      { name: date.strftime("%Y-%m-%d"), value: count }
    end
    {
      data: formatted_loans,
      status: :ok
    }
  end

  def self.get_loans_per_week
    loans = Loan.group_by_week(:created_at).count
    formatted_loans = loans.map do |date, count|
      { name: date.strftime("%Y-%U"), value: count }
    end
    {
      data: formatted_loans,
      status: :ok
    }
  end

  def self.get_loans_per_sport
    sports = Sport.all
    data = sports.map do |sport|
      { name: sport.name, value: Loan.joins(:equipment).where(equipment: { sport_id: sport.id }).count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_average_rating_per_sport
    sports = Sport.all
    data = sports.map do |sport|
      ratings = Rating.joins(loan: :equipment).where(equipment: { sport_id: sport.id })
      average = ratings.average(:score)
      { name: sport.name, value: average }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_average_rating_per_equipment
    equipments = Equipment.all
    data = equipments.map do |equipment|
      ratings = Rating.where(loan: Loan.where(equipment: equipment))
      average = ratings.average(:score)
      name = "#{equipment.equipment_type}_#{equipment.sport.name}_#{equipment.id}"
      { name: name, value: average }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_average_rating_for_loans
    ratings = Rating.all
    average = ratings.average(:score)
    {
      data: average,
      status: :ok
    }
  end
end