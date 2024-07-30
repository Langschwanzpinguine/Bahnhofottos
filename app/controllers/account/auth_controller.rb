class Account::AuthController < ApplicationController
  before_action :user_logged_in!
  def edit_password

  end

  def update_password
    if password_params[:password].blank? || password_params[:password_confirmation].blank?
      redirect_to settings_path, notice: "Password and password confirmation cannot be blank"
      return
    end

    if Current.user.update(password_params)
      redirect_to settings_path, notice: "Password changed"
    else
      redirect_to settings_path, alert: "Invalid password!"
    end
  end

  private def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end