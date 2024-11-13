class Loan < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :equipment
  has_one :rating

  # Enums
  enum :status, {
    active: "active",
    returned: "returned",
    expired: "expired"
  }, default: "active"

  # Validations
  validates :user, presence: true
  validates :equipment, presence: true
  validates :loan_date, presence: true
  validates :return_due_date, presence: true
  validates :status, presence: true
  validates :remark, length: { maximum: 1000 }, allow_blank: true

  # Callbacks
  before_validation :set_default_loan_date, on: :create
  before_validation :set_default_return_due_date, on: :create

  private

  def set_default_loan_date
    self.loan_date ||= Time.now
  end

  def set_default_return_due_date
    self.return_due_date ||= Time.now.change(hour: 18, min: 0, sec: 0)
  end
end
