class Role < ApplicationRecord
  # Associations
  has_many :user_roles
  has_many :users, through: :user_roles

  # Enums
  enum name: {
    administrator: 0,
    borrower: 1
  }
  # Validations
  validates :name, presence: true, uniqueness: true
end
