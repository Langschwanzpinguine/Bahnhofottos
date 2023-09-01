class ProxyController < ApplicationController
  def maptiles_thunderforest
    api_key = ENV['API_KEY_THUNDERFOREST']

    x = params[:x]
    y = params[:y]
    z = params[:z]

    request_url = "https://tile.thunderforest.com/atlas/#{z}/#{x}/#{y}.png?apikey=#{api_key}"

    response = HTTParty.get(request_url)

    if response.success?
      headers['Content-Type'] = 'image/png'
      send_data response.body, disposition: 'inline'
    else
      render plain: 'Error fetching tile', status: response.code
    end
  end

  def maptiles_jawg
    api_key = ENV['API_KEY_JAWG']

    x = params[:x]
    y = params[:y]
    z = params[:z]
    r = params[:r]

    request_url = "https://tile.jawg.io/jawg-sunny/#{z}/#{x}/#{y}#{r}.png?access-token=#{api_key}"

    response = HTTParty.get(request_url)

    if response.success?
      headers['Content-Type'] = 'image/png'
      send_data response.body, disposition: 'inline'
    else
      render plain: 'Error fetching tile', status: response.code
    end

  end
end