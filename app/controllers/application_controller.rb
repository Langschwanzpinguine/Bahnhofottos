class ApplicationController < ActionController::Base
  before_action :set_current_user
  def set_current_user
    if session[:user_id]
      Current.user = User.find_by(id: session[:user_id])
    end
  end

  def user_logged_in!
    redirect_to login_path, alert: "Please sign in to access" if Current.user.nil?
  end

  def user_logged_out!
    redirect_to profile_path, notice: "Already signed in" unless Current.user.nil?
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
