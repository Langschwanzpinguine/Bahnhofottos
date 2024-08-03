module FriendshipsQuery
  extend self

  def both_ways(user_id:, friend_id: nil)
    query = relation.unscope(where: :user_id)
            .where(user_id: user_id)
            .or(relation.where(friend_id: user_id))

    query = query.where(friend_id: friend_id).or(query.where(user_id: friend_id)) if friend_id
    query
  end

  private

  def relation
    @relation ||= Friendship.all
  end
end