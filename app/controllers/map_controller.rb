class MapController < ApplicationController
  layout 'map_layout'
  def index
    @page_libs = [:leaflet]
    json_file = Rails.root.join('public', 'data/grouped_countries.json')
    info_file = Rails.root.join('public', 'data/compiled_country_info.json')
    @country_data = JSON.parse(File.read(json_file))
    @country_info = JSON.parse(File.read(info_file))
  end
end