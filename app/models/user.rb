class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true, format: {with: /[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}/}
  has_secure_password

  before_create :init

  def init
    random_number = rand(10_000_000..99_999_999)
    self.username  ||= "new_user_#{random_number}"
  end
end
