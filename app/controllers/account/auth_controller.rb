class Account::AuthController < ApplicationController
  before_action :user_logged_in!
  def edit_password

  end

  def update_password
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