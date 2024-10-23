class Institution < ApplicationRecord
  # Associations
  has_many :users

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :city, presence: true
  validates :departament, presence: true
end
