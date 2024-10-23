class Pqrsf < ApplicationRecord
  # Associations
  belongs_to :user

  # Enums
  enum pqrsf_type: {
    request: 0,
    complaint: 1,
    claim: 2,
    suggestion: 3,
    compliment: 4
  }

  # Validations
  validates :user, presence: true
  validates :pqrsf_type, presence: true
  validates :description, presence: true
  validates :date, presence: true
end
