class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :equipment

  enum loan_status: { active: 0, returned: 1, expired: 2 }
end
