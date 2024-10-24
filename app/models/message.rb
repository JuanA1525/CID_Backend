class Message < ApplicationRecord
  # Associations
  belongs_to :user

  # Enums
  enum :type, {
    return_alert: 'return_alert',
    rating_reminder: 'rating_reminder',
    general_notification: 'general_notification',
    suspension_notice: 'suspension_notice'
  }

  # Validations
  validates :user, presence: true
  validates :type, presence: true
  validates :content, presence: true
end
