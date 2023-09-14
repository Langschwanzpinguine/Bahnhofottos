class Account::FriendsController < ApplicationController
  before_action :user_logged_in!

  def index
    @friends = Current.user.friends
    @pending_invitations = Current.user.pending_invitations
  end

  def send_invitation
    friend_id = friend_params
    friend = User.find_by(id: friend_id)
    Current.user.send_invitation(friend)
    redirect_to friends_path, notice: "Request sent to user: "+friend.username
  end

  private
  def friend_params
    params.require(:friend_id)
  end
end