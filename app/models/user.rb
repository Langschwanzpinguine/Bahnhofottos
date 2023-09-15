class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true, format: {with: /[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}/}
  has_secure_password

  has_many :friends
  has_many :invitations
  has_many :pending_invitations, -> { where confirmed: false }, class_name: 'Invitation', foreign_key: "friend_id"

  before_create :init

  def init
    random_number = rand(10_000_000..99_999_999)
    self.username  ||= "new_user_#{random_number}"
  end

  def friends
    friends_sent_invitation = Invitation.where(user_id: id, confirmed: true).pluck(:friend_id)
    friends_received_invitation = Invitation.where(friend_id: id, confirmed: true).pluck(:user_id)
    friends = friends_sent_invitation + friends_received_invitation
    User.where(id: friends)
  end

  def friend_with?(user)
    Invitation.confirmed_record?(id, user.id)
  end

  def send_invitation(user)
    invitations.create(friend_id: user.id)
  end
end
