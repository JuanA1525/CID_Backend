class Pqrsf < ApplicationRecord
  belongs_to :user

  enum pqrsf_type: {
    request: 0,
    complaint: 1,
    claim: 2,
    suggestion: 3,
    compliment: 4
  }
end
