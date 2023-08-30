require 'net/http'
class OverpassController < ApplicationController
  # For Testing Purposes only (Allows 3rd Party Clients like Insomnia to make requests)
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, only: [:stations]
  def stations
    req_body = request.body.read

    if req_body.blank?
      render json: { error: "Missing bounding box coordinates" }, status: :bad_request
      return
    end

    json_data = JSON.parse(req_body)
    body_string = "data=node[railway=station](#{json_data["end_lat"]}, #{json_data["end_lon"]}, #{json_data["start_lat"]}, #{json_data["start_lon"]});out body;"
    puts body_string
    #Start of Overpass Request
    uri = URI('https://overpass-api.de:80/api/interpreter')

    # Create an instance of Net::HTTP with the host and port from the URI
    http = Net::HTTP.new(uri.host, uri.port)

    # Create a POST request with the desired path and headers
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'text/plain'})

    # Set the request body with your string data
    request.body = body_string

    # Make the POST request
    response = http.request(request)

    # Output the response body if the request was successful
    if response.is_a?(Net::HTTPSuccess)
      puts response.body
    else
      puts "Request failed with code #{response.code}"
      puts response.body
    end
    render json: {}
  end
end