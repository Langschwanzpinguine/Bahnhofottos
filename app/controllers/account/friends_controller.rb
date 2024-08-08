class Account::FriendsController < ApplicationController
  before_action :user_logged_in!

  def index
    @friends = Current.user.friends
    @pending_invitations = Current.user.pending_invitations.where(friend_id: Current.user.id)
  end

  def send_invitation
    friend_id = friend_params[:friend_id]
    if friend_id.blank?
      redirect_to friends_path, alert: "Empty Friend ID not permitted"
      return
    end

    friend = User.find_by(id: friend_id)
    if friend.nil?
      redirect_to friends_path, alert: "User not found"
    elsif friend == Current.user
      redirect_to friends_path, alert: "You can't be friends with yourself. Or can you?"
    elsif Invitation.exists?(Current.user.id, friend_id)
      redirect_to friends_path, alert: "There already is an open request with this user"
    elsif Current.user.friend_with?(friend_id)
      redirect_to friends_path, alert: "You're already friends with this user"
    else
      Current.user.send_invitation(friend)
      redirect_to friends_path, notice: "Request sent to user: #{friend.username}"
    end
  end

  def accept_invitation
    invitation_id = invitation_params
    invitation = Invitation.find_by(id: invitation_id)
    friendship = Friendship.new(user: Current.user, friend: invitation.user)
    friendship.save
    invitation.destroy
    redirect_to friends_path, notice: "Request accepted!"
  end

  def delete_invitation
    invitation_id = invitation_params
    invitation = Invitation.find_by(id: invitation_id)
    invitation.destroy
    redirect_to friends_path, notice: "Request destroyed!"
  end

  def unfriend
    friend_id = friend_params[:friend_id]
    Friendship.unfriend(Current.user.id, friend_id)
    redirect_to friends_path, notice: "Friendship destroyed!"
  end

  private
  def friend_params
    params.permit(:friend_id)
  end
  def invitation_params
    params.require(:id)
  end
end