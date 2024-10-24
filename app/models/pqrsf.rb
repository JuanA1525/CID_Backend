class Pqrsf < ApplicationRecord
  # Associations
  belongs_to :user

  # Enums
  enum :type, {
    request: 'request',
    complaint: 'complaint',
    claim: 'claim',
    suggestion: 'suggestion',
    compliment: 'compliment'
  }

  # Validations
  validates :user, presence: true
  validates :type, presence: true
  validates :description, presence: true
  validates :date, presence: true
end
