class MessageRecipient < ApplicationRecord
  # Associations
  belongs_to :message
  belongs_to :user

  # Validations
  validates :message, presence: true
  validates :user, presence: true
end
