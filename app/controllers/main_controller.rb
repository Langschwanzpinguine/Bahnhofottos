class MainController < ApplicationController
  def index
    if Current.user
      relevant_users =  Current.user.friends.or(User.where(id: Current.user.id))
      @stations = TrainStation.where(user: relevant_users).order(created_at: :desc).limit(10).includes(:user)
    else
      render 'main/welcome'
    end
  end
end