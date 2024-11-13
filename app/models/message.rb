class Message < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :message_recipients

  # Enums
  enum :message_type, {
    information: 'information',
    warning: 'warning',
    error: 'error'
  }

  # Validations
  validates :user, presence: true
  validates :message_type, presence: true
  validates :content, presence: true
end