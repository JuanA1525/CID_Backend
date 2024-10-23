class Rating < ApplicationRecord
  # Associations
  belongs_to :loan

  # Validations
  validates :loan, presence: true
  validates :score, presence: true, inclusion: { in: 1..5 }
  validates :comment, length: { maximum: 1000 }, allow_blank: true
end
