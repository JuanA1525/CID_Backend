class Pqrsf < ApplicationRecord
  # Associations
  belongs_to :user

  # Enums
  enum :pqrsf_type, {
    petition: "petition",
    complaint: "complaint",
    claim: "claim",
    suggestion: "suggestion",
    compliment: "compliment"
  }

  # Validations
  validates :user, presence: true
  validates :pqrsf_type, presence: true
  validates :description, presence: true
  validates :pending, inclusion: { in: [ true, false ] }
  validates :subject, presence: true
end
