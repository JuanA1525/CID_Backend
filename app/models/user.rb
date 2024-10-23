class User < ApplicationRecord
  require "securerandom"
  has_secure_password

  # Associations
  belongs_to :institution

  # Enums
  enum ocupation: { student: 0, visitor: 1, graduated: 2, employee: 3 }
  enum status: { active: 0, inactive: 1, suspended: 2 }

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :ocupation, presence: true
  validates :status, presence: true
  validates :institution, presence: true

  validates :notification_pending, inclusion: { in: [true, false] }
end
