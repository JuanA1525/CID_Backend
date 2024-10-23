class Sport < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
