class User < ApplicationRecord
  has_secure_password

  belongs_to :institution

  enum ocupation: { student: 0, visitor: 1, graduated: 2, employee: 3 }
  enum status: { active: 0, inactive: 1, suspended: 2 }
end
