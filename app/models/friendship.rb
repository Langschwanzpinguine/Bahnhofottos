class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def self.unfriend(user_id, friend_id)
    friendship = FriendshipsQuery.both_ways(user_id: user_id, friend_id: friend_id).first
    friendship.destroy if friendship
  end
end
