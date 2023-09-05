class MapController < ApplicationController
  layout 'map_layout'
  def index
    @page_libs = [:leaflet]
  end
end