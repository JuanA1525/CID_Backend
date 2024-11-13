class Api::V1::DashboardController < ApplicationController
  def get_summary
    summary = DashboardService.get_summary
    render json: summary[:data], status: summary[:status]
  end

  def get_loans_info
    loans_info = DashboardService.get_loans_info
    render json: loans_info[:data], status: loans_info[:status]
  end

  def get_equipment_info
    equipment_info = DashboardService.get_equipment_info
    render json: equipment_info[:data], status: equipment_info[:status]
  end

  def get_equipment_per_sport
    equipment_per_sport = DashboardService.get_equipment_per_sport
    render json: equipment_per_sport[:data], status: equipment_per_sport[:status]
  end

  def get_loans_per_month
    loans_per_month = DashboardService.get_loans_per_month
    render json: loans_per_month[:data], status: loans_per_month[:status]
  end

  def get_loans_per_day
    loans_per_day = DashboardService.get_loans_per_day
    render json: loans_per_day[:data], status: loans_per_day[:status]
  end

  def get_loans_per_week
    loans_per_week = DashboardService.get_loans_per_week
    render json: loans_per_week[:data], status: loans_per_week[:status]
  end

  def get_loans_per_sport
    loans_per_sport = DashboardService.get_loans_per_sport
    render json: loans_per_sport[:data], status: loans_per_sport[:status]
  end

  def get_average_rating_per_sport
    average_rating_per_sport = DashboardService.get_average_rating_per_sport
    render json: average_rating_per_sport[:data], status: average_rating_per_sport[:status]
  end

  def get_average_rating_per_equipment
    average_rating_per_equipment = DashboardService.get_average_rating_per_equipment
    render json: average_rating_per_equipment[:data], status: average_rating_per_equipment[:status]
  end

  def get_average_rating_for_loans
    average_rating_for_loans = DashboardService.get_average_rating_for_loans
    render json: average_rating_for_loans[:data], status: average_rating_for_loans[:status]
  end

  def get_top_five_users_with_more_loans
    top_five_users_with_more_loans = DashboardService.get_top_five_users_with_more_loans
    render json: top_five_users_with_more_loans[:data], status: top_five_users_with_more_loans[:status]
  end

  def get_top_five_users_with_more_ratings
    top_five_users_with_more_ratings = DashboardService.get_top_five_users_with_more_ratings
    render json: top_five_users_with_more_ratings[:data], status: top_five_users_with_more_ratings[:status]
  end

  def get_users_per_status
    users_per_status = DashboardService.get_users_per_status
    render json: users_per_status[:data], status: users_per_status[:status]
  end

  def get_users_per_role
    users_per_role = DashboardService.get_users_per_role
    render json: users_per_role[:data], status: users_per_role[:status]
  end

  def get_users_per_occupation
    users_per_occupation = DashboardService.get_users_per_occupation
    render json: users_per_occupation[:data], status: users_per_occupation[:status]
  end

  def get_equipment_per_type
    equipment_per_type = DashboardService.get_equipment_per_type
    render json: equipment_per_type[:data], status: equipment_per_type[:status]
  end

  def get_equipment_per_condition
    equipment_per_condition = DashboardService.get_equipment_per_condition
    render json: equipment_per_condition[:data], status: equipment_per_condition[:status]
  end

  def get_loans_per_status
    loans_per_status = DashboardService.get_loans_per_status
    render json: loans_per_status[:data], status: loans_per_status[:status]
  end

  def get_loans_per_rating
    loans_per_rating = DashboardService.get_loans_per_rating
    render json: loans_per_rating[:data], status: loans_per_rating[:status]
  end
end