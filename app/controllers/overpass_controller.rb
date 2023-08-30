# DISCLAIMER! This should probably be client side for performance reasons. Discussion needed
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
    # Craft String defining the size of the bounding box
    bbox_string = "(#{json_data["end_lat"]}, #{json_data["end_lon"]}, #{json_data["start_lat"]}, #{json_data["start_lon"]})"
    # Insert the bounds into the Overpass query
    body_string = "[out:json];(
        node[railway=station]#{bbox_string};
        node[railway=halt]#{bbox_string};
      );
      out;"

    #Start of Overpass Request
    uri = URI('https://overpass-api.de:80/api/interpreter')

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'text/plain'})

    request.body = body_string

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      render json: response.body
    else
      puts "Request failed with code #{response.code}"
      render json: {"Error": true}
    end
  end
end