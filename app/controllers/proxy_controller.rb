class ProxyController < ApplicationController

  #Prallelisieren und Caching implementieren

  def maptiles_thunderforest
    api_key = ENV['API_KEY_THUNDERFOREST']

    x = params[:x]
    y = params[:y]
    z = params[:z]

    request_url = "8https://tile.thunderforest.com/atlas/#{z}/#{x}/#{y}.png?apikey=#{api_key}"

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