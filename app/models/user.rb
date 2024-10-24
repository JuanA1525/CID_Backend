class User < ApplicationRecord
  require "securerandom"
  has_secure_password

  # Associations
  belongs_to :institution

  # Enums
  enum :occupation, {
    student: 'student',
    visitor: 'visitor',
    graduated: 'graduated',
    employee: 'employee'
  }, default: 'student'

  enum :status, {
    active: 'active',
    inactive: 'inactive',
    suspended: 'suspended'
  }, default: 'active'

  enum :role, {
    admin: 'admin',
    borrower: 'borrower'
  }, default: 'borrower'

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "It must be a valid email." }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 8 }
  validates :occupation, presence: true
  validates :status, presence: true
  validates :role, presence: true
  validates :institution, presence: true
  validates :notification_pending, inclusion: { in: [true, false] }

  # Callbacks
  before_validation :normalize_email

  private

    def normalize_email
      self.email = email.strip.downcase if email.present?
    end
end
