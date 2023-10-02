class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true, format: {with: /[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}/}
  has_secure_password
  
  # Frienships, rainbows 'n such
  has_many :invitations
  has_many :pending_invitations, -> { where confirmed: false }, class_name: 'Invitation', foreign_key: "friend_id"

  has_one_attached :avatar
  has_many :train_stations

  before_create :randomize_id

  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000_000)
    end while User.where(id: self.id).exists?

    usernames = %w[StationExplorer RailJourneyer PlatformPioneer TrainTrackTrekker StationSnapster RailwayAdventurer TravelByRails TrackTales TrainSpotterPro StationStoryteller]
    random_username = usernames.sample
    self.username  ||= random_username
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
