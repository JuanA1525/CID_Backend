class Equipment < ApplicationRecord
  # Associations
  belongs_to :institution
  belongs_to :sport

  # Enums
  enum :equipment_type, {
    helmets: "helmets",
    knee_pads: "knee_pads",
    elbow_pads: "elbow_pads",
    vests: "vests",
    protectors: "protectors",
    weights: "weights",
    dumbbells: "dumbbells",
    elastic_bands: "elastic_bands",
    mat: "mat",
    rope: "rope",
    medicine_balls: "medicine_balls",
    nets: "nets",
    baskets: "baskets",
    goals: "goals",
    hoops: "hoops",
    balls: "balls",
    rackets: "rackets",
    sticks: "sticks",
    boards: "boards",
    masks: "masks",
    gloves: "gloves"
  }

  enum :condition, {
    perfect: "perfect",
    good: "good",
    acceptable: "acceptable",
    fair: "fair",
    bad: "bad",
    unusable: "unusable"
  }, default: "perfect"

  # Validations
  validates :equipment_type, presence: true
  validates :condition, presence: true
  validates :available, inclusion: { in: [ true, false ] }
  validates :sport, presence: true
end
