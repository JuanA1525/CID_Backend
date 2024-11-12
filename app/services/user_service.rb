class UserService
  def self.get_loans(user_id)
    user = User.find(user_id)
    loans = user.loans
    loans
  end
end
