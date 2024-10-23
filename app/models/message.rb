class Message < ApplicationRecord
  # Associations
  belongs_to :user

  # Enums
  enum message_type: {
    return_alert: 0,
    rating_reminder: 1,
    general_notification: 2,
    suspension_notice: 3
  }

  # Validations
  validates :user, presence: true
  validates :message_type, presence: true
  validates :content, presence: true
end
