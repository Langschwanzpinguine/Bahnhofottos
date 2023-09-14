class Account::FriendsController < ApplicationController
  before_action :user_logged_in!

  def index
    @friends = Current.user.friends
    @pending_invitations = Current.user.pending_invitations.where(friend_id: Current.user.id)
  end

  def send_invitation
    friend_id = friend_params
    friend = User.find_by(id: friend_id)

    if friend == Current.user
      redirect_to friends_path, alert: "You can't be friends with yourself. Or can you?"
    elsif Invitation.exists?(Current.user.id, friend_id)
      redirect_to friends_path, alert: "There already is an open request with this user"
    elsif Invitation.confirmed_record?(Current.user.id, friend_id)
      redirect_to friends_path, alert: "You're already friends with this user"
    else
      Current.user.send_invitation(friend)
      redirect_to friends_path, notice: "Request sent to user: "+friend.username
    end
  end

  def accept_invitation
    invitation_id = invitation_params
    invitation = Invitation.find_by(id: invitation_id)
    invitation.confirmed = true
    invitation.save
    redirect_to friends_path, notice: "Request accepted!"
  end

  def delete_invitation
    invitation_id = invitation_params
    invitation = Invitation.find_by(id: invitation_id)
    invitation.destroy
    redirect_to friends_path, notice: "Request destroyed!"
  end

  def unfriend
    friend_id = friend_params
    invitations = Invitation.find_invitations(Current.user.id, friend_id)
    invitations.each do |invitation|
      invitation.destroy
    end
    redirect_to friends_path, notice: "Friendship destroyed!"
  end

  private
  def friend_params
    params.require(:friend_id)
  end
  def invitation_params
    params.require(:id)
  end
end