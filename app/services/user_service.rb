class UserService
  def self.get_loans(user_id)
    user = User.find(user_id)
    loans = user.loans.order(created_at: :desc)
    loans
  end
end
