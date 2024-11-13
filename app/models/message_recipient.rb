class MessageRecipient < ApplicationRecord
  # Associations
  belongs_to :message
  belongs_to :user

  # Validations
  validates :message_id, presence: true
  validates :user_id, presence: true
end
