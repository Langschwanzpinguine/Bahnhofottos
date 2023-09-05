class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true, format: {with: /[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}/}
  has_secure_password
end
