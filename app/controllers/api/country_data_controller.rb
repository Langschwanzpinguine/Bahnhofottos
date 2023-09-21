require 'net/http'
class Api::CountryDataController < ApplicationController
  def fetch
    country_code = params[:country_code]
    file_path = Rails.root.join('public', "data/osm_data/country_data_#{country_code}.json")

    if File.exist?(file_path)
      json_content = File.read(file_path)
      expires_in 1.hour, public: true
      render json: json_content
    else
      res = fetch_from_data_service(country_code)

      if response.code == '200'
        expires_in 1.hour, public: true
        render json: res.body
      else
        render json: { error: 'Failed to fetch JSON from the server' }, status: :unprocessable_entity
      end
    end
  end

  private
  def fetch_from_data_service(country_code)
    uri = URI("http://localhost:8080/load/#{country_code}")
    Net::HTTP.get_response(uri)
  end
end