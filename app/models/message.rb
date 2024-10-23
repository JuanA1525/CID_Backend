class Message < ApplicationRecord
  belongs_to :user

  enum message_type: {
    return_alert: 0,
    rating_reminder: 1,
    general_notification: 2,
    suspension_notice: 3
  }
end
