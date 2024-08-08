class RemoveForeignKeyFromFriendships < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :friendships, :friends
  end
end
