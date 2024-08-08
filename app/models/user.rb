class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true, format: {with: /[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}/}
  validates :username, :length => { :minimum => 3 }, if: :username_required?
  validates :password, :length => { :minimum => 3, :maximum => 128 }, if: :password_required?
  has_secure_password
  
  # Frienships, rainbows 'n such
  has_many :invitations
  has_many :pending_invitations, -> { where confirmed: false }, class_name: 'Invitation', foreign_key: "friend_id"

  has_many :friendships,
           ->(user) { FriendshipsQuery.both_ways(user_id: user.id) },
           inverse_of: :user,
           dependent: :destroy

  has_many :friends,
           ->(user) { UsersQuery.friends(user_id: user.id, scope: true) },
           through: :friendships,
           class_name: 'User'

  has_one_attached :avatar
  has_many :train_stations

  before_create :randomize_id

  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while User.where(id: self.id).exists?

    usernames1 = %w[Halt Highspeed Locomotive Platform Rail Railway Subway Station Track Train Traintrack]
    usernames2 = %w[Adventurer Explorer Journeyer Pioneer Snapster Spotter Storyteller Tailes Trekker]
    random_username = usernames1.sample + usernames2.sample
    self.username  ||= random_username
  end

  def password_required?
    new_record? || !password.blank?
  end

  def username_required?
    !new_record?
  end

  def friend_with?(friend_id)
    friends.exists?(friend_id)
  end

  def send_invitation(user)
    invitations.create(friend_id: user.id)
  end
end
