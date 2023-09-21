module TrainStationsHelper
  def create_train_station(user, osm_id, image)
    station = user.train_stations.new(osm_id: osm_id)
    station.image.attach(image)

    if station.valid?
      station.save
      return station
      # return keyword is redundant, kept for code legibility
    else
      nil
    end
  end
end