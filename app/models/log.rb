class Log < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :user, presence: true
  validates :action, presence: true
end
