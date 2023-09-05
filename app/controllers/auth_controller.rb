class AuthController < ApplicationController
  before_action :require_user_logged_in!
  def edit_password

  end

  def update_password
    if Current.user.update(password_params)
      redirect_to root_path, notice: "Password changed"
    else
      render :edit_password
    end
  end

  private def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end