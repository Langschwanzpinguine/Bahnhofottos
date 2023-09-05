class Authentication::UsersController < ApplicationController
  before_action :require_user_logged_in!, only: [:destroy, :profile]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Successfully created Otto"
    else
      render :new
    end
  end

  def destroy
    Current.user.destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out and destroyed user!"
  end

  def profile
  end

  def settings
  end

  private def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end