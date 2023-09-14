class Invitation < ApplicationRecord
  belongs_to :user

  # Check if records of sent or confirmed request between users id_1
  # and id_2 already exits.
  # If so, create no new invitation!
  def self.reacted?(id_1, id_2)
    case1 = !Invitation.where(user_id: id_1, friend_id: id_2).empty?
    case2 = !Invitation.where(user_id: id_2, friend_id: id_1).empty?
    case1 || case2
  end

  # Check specifically if record of confirmed friendship between two users exists
  def self.confirmed_record(id_1, id_2)
    case1 = !Invitation.where(user_id: id_1, friend_id: id_2, confirmed: true).empty?
    case2 = !Invitation.where(user_id: id_2, friend_id: id_1, confirmed: true).empty?
    case1 || case2
  end

  def self.find_invitation(id_1, id_2)
    if Invitation.where(user_id: id_1, friend_id: id_2, confirmed: true).empty?
      Invitation.where(user_id: id_2, friend_id: id_1, confirmed: true)[0].id
    else
      Invitation.where(user_id: id_1, friend_id: id_2, confirmed: true)[0].id
    end
  end
end
