class Pqrsf < ApplicationRecord
  # Associations
  belongs_to :user

  # Enums
  enum pqrsf_type: {
    request: 'request',
    complaint: 'complaint',
    claim: 'claim',
    suggestion: 'suggestion',
    compliment: 'compliment'
  }

  # Validations
  validates :user, presence: true
  validates :pqrsf_type, presence: true
  validates :description, presence: true
  validates :pending, presence: true, inclusion: { in: [ true, false ] }
end
