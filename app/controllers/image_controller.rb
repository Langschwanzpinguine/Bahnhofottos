class ImageController < ApplicationController
  before_action :user_logged_in!#, only: [:upload_station_image]

  def upload_station_image
    existing_station = Current.user.train_stations.find_by(osm_id: train_station_params[:osm_id])
    if existing_station
      existing_station.image = train_station_params[:image]
      if existing_station.save
        redirect_to map_path(country: view_params[:country], station: view_params[:osm_id])
      else
        redirect_to root_path, alert: "Error uploading"
      end
      return
    end

    @train_station = Current.user.train_stations.new(train_station_params)
    if @train_station.save
      redirect_to map_path(country: view_params[:country], station: view_params[:osm_id])
    else
      redirect_to root_path, alert: "Error uploading"
    end
  end

  def delete_station_image
    station_to_delete = Current.user.train_stations.find_by(osm_id: delete_params[:osm_id])
    if station_to_delete
      Current.user.train_stations.destroy(station_to_delete)
      station_to_delete.destroy
      redirect_to request.referer || root_path
    end
  end

  def fetch_image
    # Planning on dynamically sending the images to the frontend when popup is clicked
    id = params[:station_id]
    station = Current.user.train_stations.find_by(osm_id: id)

    if station
      send_data station.image.download, type: station.image.content_type, disposition: 'inline'
    end
  end
end

def train_station_params
  params.require(:user).permit(:osm_id, :image, :country, :name, :operator, :station_type)
end

def delete_params
  params.permit(:osm_id)
end

def view_params
  params.require(:user).permit(:osm_id, :country)
end