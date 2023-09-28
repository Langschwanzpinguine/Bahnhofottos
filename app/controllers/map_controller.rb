class MapController < ApplicationController
  before_action :user_logged_in!, only: [:upload_station_image]
  layout 'map_layout'
  def index
    @page_libs = [:leaflet]
    json_file = Rails.root.join('public', 'data/grouped_countries.json')
    info_file = Rails.root.join('public', 'data/compiled_country_info.json')
    @country_data = JSON.parse(File.read(json_file))
    @country_info = JSON.parse(File.read(info_file))

    train_stations_json = []
    user_state = false
    if Current.user
      user_state = true
      @train_stations = Current.user.train_stations
      @train_stations.each do |train_station|
        image_url = url_for(train_station.image)

        train_station_json = {
          osm_id: train_station.osm_id,
          image_url: image_url
        }

        train_stations_json << train_station_json
      end
    end
    @photographed_stations = train_stations_json.to_json.html_safe

    show_station_id = params[:station]
    selected_country = params[:country]

    @session_info = {
      logged_in: user_state,
      show_station: show_station_id,
      show_country: selected_country
    }.to_json.html_safe
  end

  def upload_station_image
    @train_station = Current.user.train_stations.new(train_station_params)
    if @train_station.save
      redirect_to action: :index, country: view_params[:country], station: view_params[:osm_id]
    else
      redirect_to root_path, alert: "Error uploading"
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

  private
  def train_station_params
    params.require(:user).permit(:osm_id, :image, :country, :name, :operator, :station_type)
  end

  def view_params
    params.require(:user).permit(:osm_id, :country)
  end
end