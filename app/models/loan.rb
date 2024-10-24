class Loan < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :equipment

  # Enums
  enum :status, {
    active: 'active',
    returned: 'returned',
    expired: 'expired'
  }, default: 'active'

  # Validations
  validates :user, presence: true
  validates :equipment, presence: true
  validates :loan_date, presence: true
  validates :return_due_date, presence: true
  validates :status, presence: true
  validates :remark, length: { maximum: 1000 }, allow_blank: true
end
