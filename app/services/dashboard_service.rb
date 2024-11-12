class DashboardService
  def self.get_summary
    {
      data: {
        users: User.count,
        loans: Loan.count,
        equipments: Equipment.count,
        sports: Sport.count
      },
      status: :ok
    }
  end

  def self.get_loans_info
    {
      data: {
        active: Loan.where(status: "active").count,
        returned: Loan.where(status: "returned").count,
        expired: Loan.where(status: "expired").count
      },
      status: :ok
    }
  end

  def self.get_equipment_info
    {
      data: {
        available: Equipment.where(available: true).count,
        unavailable: Equipment.where(available: false).count,
        condition: {
          perfect: Equipment.where(condition: "perfect").count,
          good: Equipment.where(condition: "good").count,
          fair: Equipment.where(condition: "fair").count,
          acceptable: Equipment.where(condition: "acceptable").count,
          bad: Equipment.where(condition: "bad").count,
          unusable: Equipment.where(condition: "unusable").count
        }
      },
      status: :ok
    }
  end

  def self.get_equipment_per_sport
    sports = Sport.all
    data = {}
    sports.each do |sport|
      data[sport.name] = Equipment.where(sport_id: sport.id).count
    end
    {
      data: data,
      status: :ok
    }
  end

  def self.get_loans_per_month
    loans = Loan.group_by_month(:created_at).count
    formatted_loans = loans.map do |date, count|
      { year: date.year, month: date.strftime("%B"), count: count }
    end
    {
      data: formatted_loans,
      status: :ok
    }
  end

  def self.get_loans_per_day
    loans = Loan.group_by_day(:created_at).count
    {
      data: loans,
      status: :ok
    }
  end

  def self.get_loans_per_week
    loans = Loan.group_by_week(:created_at).count
    formatted_loans = loans.map do |date, count|
      { year: date.year, week: date.strftime("%U"), count: count }
    end
    {
      data: formatted_loans,
      status: :ok
    }
  end

  def self.get_loans_per_sport
    sports = Sport.all
    data = {}
    sports.each do |sport|
      data[sport.name] = Loan.joins(:equipment).where(equipment: { sport_id: sport.id }).count
    end
    {
      data: data,
      status: :ok
    }
  end
end
