class Equipment < ApplicationRecord
  # Associations
  belongs_to :institution
  belongs_to :sport

  # Enums
  enum equipment_type: {
    helmets: 0,
    knee_pads: 1,
    elbow_pads: 2,
    vests: 3,
    protectors: 4,
    weights: 5,
    dumbbells: 6,
    elastic_bands: 7,
    mat: 8,
    rope: 9,
    medicine_balls: 10,
    nets: 11,
    baskets: 12,
    goals: 13,
    hoops: 14,
    balls: 15,
    rackets: 16,
    sticks: 17,
    boards: 18,
    masks: 19,
    gloves: 20
  }

  enum equipment_condition: {
    perfect: 0,
    good: 1,
    acceptable: 2,
    fair: 3,
    bad: 4,
    unusable: 5
  }

  # Validations
  validates :equipment_type, presence: true
  validates :condition, presence: true
  validates :available, inclusion: { in: [true, false] }
  validates :institution, presence: true
  validates :sport, presence: true
end
