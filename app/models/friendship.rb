class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  before_validation :set_order

  validates :user_id, uniqueness: { scope: :friend_id, message: "Friendship already exists" }
  validate :not_self

  def self.unfriend(user_id, friend_id)
    friendship = FriendshipsQuery.both_ways(user_id: user_id, friend_id: friend_id).first
    friendship.destroy if friendship
  end

  private
  def set_order
    if user && friend
      self.user, self.friend = [user, friend].sort_by(&:id)
    end
  end
  def not_self
    errors.add(:friend_id, "can't be the same as user") if user_id == friend_id
  end
end
