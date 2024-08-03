class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def self.unfriend(user_id, friend_id)
    all_friendships = FriendshipsQuery.both_ways(user_id: user_id)
    friendship = all_friendships.where(friend_id: friend_id).or(all_friendships.where(friend_id: user_id)).first
    friendship.destroy if friendship
  end
end
