class Account::UsersController < ApplicationController
  before_action :user_logged_in!, only: [:destroy, :profile, :settings]
  before_action :user_logged_out!, only: [:new, :create]
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
    @photo = Current.user.image
  end

  def change_username
    if Current.user.update(username_params)
      redirect_to profile_path, notice: "Username changed"
    else
      render :settings
    end
  end

  def upload_profile_picture
    pic = profile_picture_params
    Current.user.image = pic
    redirect_to settings_path, notice: "Profile picture uploaded"
  end

  private def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  private def username_params
    params.require(:user).permit(:username)
  end

  private def profile_picture_params
    params.require(:image )
  end
end