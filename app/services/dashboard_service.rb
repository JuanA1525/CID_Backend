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

  def self.get_top_five_users_with_more_loans
    users = User.joins(:loans).group(:id).order("count(loans.id) DESC").limit(5)
    data = users.map do |user|
      { name: user.name, value: user.loans.count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_top_five_users_with_more_ratings
    users = User.joins(loans: :rating).group("users.id").order("COUNT(ratings.id) DESC").limit(5)
    data = users.map do |user|
      { name: user.name, value: user.loans.joins(:rating).count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_users_per_status
    users = User.group(:status).count
    data = users.map do |status, count|
      { name: status, value: count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_users_per_role
    users = User.group(:role).count
    data = users.map do |role, count|
      { name: role, value: count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_users_per_occupation
    users = User.group(:occupation).count
    data = users.map do |occupation, count|
      { name: occupation, value: count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_equipment_per_type
    equipments = Equipment.group(:equipment_type).count
    data = equipments.map do |type, count|
      { name: type, value: count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_equipment_per_condition
    equipments = Equipment.group(:condition).count
    data = equipments.map do |condition, count|
      { name: condition, value: count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_loans_per_status
    loans = Loan.group(:status).count
    data = loans.map do |status, count|
      { name: status, value: count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_loans_per_rating
    ratings = Rating.group(:score).count
    data = ratings.map do |score, count|
      { name: score, value: count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_pqrsf_per_type
    pqrsfs = Pqrsf.group(:pqrsf_type).count
    data = pqrsfs.map do |type, count|
      { name: type, value: count }
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_pqrsf_per_pending
    pending_count = Pqrsf.where(pending: true).count
    not_pending_count = Pqrsf.where(pending: false).count

    [
      { name: "Pending", value: pending_count },
      { name: "Adressed", value: not_pending_count }
    ]
  end

  def self.get_pqrsf_per_week
    pqrsfs = Pqrsf.group_by_week(:created_at).count
    formatted_pqrsfs = pqrsfs.map do |date, count|
      { name: date.strftime("%Y-%U"), value: count }
    end
    {
      data: formatted_pqrsfs,
      status: :ok
    }
  end

  def self.get_pqrsf_per_day
    pqrsfs = Pqrsf.group_by_day(:created_at).count
    formatted_pqrsfs = pqrsfs.map do |date, count|
      { name: date.strftime("%Y-%m-%d"), value: count }
    end
    {
      data: formatted_pqrsfs,
      status: :ok
    }
  end

  def self.get_pqrsf_per_month
    pqrsfs = Pqrsf.group_by_month(:created_at).count
    formatted_pqrsfs = pqrsfs.map do |date, count|
      { name: date.strftime("%Y-%m"), value: count }
    end
    {
      data: formatted_pqrsfs,
      status: :ok
    }
  end
end
