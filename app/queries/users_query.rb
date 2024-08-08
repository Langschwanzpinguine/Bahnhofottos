module UsersQuery
  extend self

  def friends(user_id:, scope: false)
    query = relation.joins(sql(scope: scope)).where.not(id: user_id)

    query.where(friendships: { user_id: user_id })
         .or(query.where(friendships: { friend_id: user_id }))
  end

  private

  def relation
    @relation ||= User.all
  end

  def sql(scope: false)
    if scope
      <<~SQL
        OR users.id = friendships.user_id
      SQL
    else
      <<~SQL
        INNER JOIN friendships
          ON users.id = friendships.friend_id
          OR users.id = friendships.user_id
      SQL
    end
  end
end