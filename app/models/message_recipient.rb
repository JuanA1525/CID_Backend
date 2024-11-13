class MessageRecipient < ApplicationRecord
  # Associations
  belongs_to :message
  belongs_to :user, optional: true

  enum :recipient_category, {
    individual: 'individual',
    all_users:'all_users',
    active_loans: 'active_loans'
  }

  # Validations
  validates :message_id, presence: true
  validates :recipient_category, presence: true
end