class EquipmentStateHistory < ApplicationRecord
  # Associations
  belongs_to :equipment

  # Validations
  validates :equipment, presence: true
  validates :previous_condition, presence: true
  validates :new_condition, presence: true
end
