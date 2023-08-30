class MapController < ApplicationController
  def index
    @page_libs = [:leaflet]
  end
end