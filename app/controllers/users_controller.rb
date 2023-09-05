class UsersController < ApplicationController
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
    unless session[:user_id]
      redirect_to login_path, notice: "Please sign in to access this site"
    end

  end

  def settings

  end

  private def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end