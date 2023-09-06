class ProxyController < ApplicationController

  #Prallelisieren und Caching implementieren

  def maptiles_thunderforest
    api_key = ENV['API_KEY_THUNDERFOREST']
    #api_key = Rails.application.credentials.dig(:thunderforest, :api_key)

    x = params[:x]
    y = params[:y]
    z = params[:z]

    cache_key = "thunderforest_tile_#{z}_#{x}_#{y}"

    cached_tile = Rails.cache.read(cache_key)

    if cached_tile
      # If the tile is cached, serve it directly from the cache
      send_data cached_tile, type: 'image/png', disposition: 'inline'
    else
      request_url = "https://tile.thunderforest.com/atlas/#{z}/#{x}/#{y}.png?apikey=#{api_key}"

      response = HTTParty.get(request_url)

      if response.success?
        Rails.cache.write(cache_key, response.body, expires_in: 1.hour)

        headers['Content-Type'] = 'image/png'
        send_data response.body, disposition: 'inline'
      else
        render plain: 'Error fetching tile', status: response.code
      end
    end
  end

  def maptiles_jawg
    api_key = ENV['API_KEY_JAWG']
    #api_key = Rails.application.credentials.dig(:jawg, :api_key)

    x = params[:x]
    y = params[:y]
    z = params[:z]
    r = params[:r]

    # request_url = "https://tile.jawg.io/jawg-sunny/#{z}/#{x}/#{y}#{r}.png?access-token=#{api_key}"
    #
    # response = HTTParty.get(request_url)
    #
    # if response.success?
    #   headers['Content-Type'] = 'image/png'
    #   send_data response.body, disposition: 'inline'
    # else
    #   render plain: 'Error fetching tile', status: response.code
    # end

    request_url = "https://tile.jawg.io/jawg-sunny/#{z}/#{x}/#{y}#{r}.png?access-token=#{api_key}"
    uri = URI.parse(request_url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true # Use SSL for HTTPS requests

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      headers['Content-Type'] = 'image/png'
      send_data response.body, disposition: 'inline'
    else
      render plain: 'Error fetching tile', status: response.code.to_i
    end


  end
end