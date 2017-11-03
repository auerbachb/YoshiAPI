class ApplicationController < ActionController::API
  # @param [String] place_id
  # @return [JSON] json result for given place id
  def get_json_response(place_id)
    response = HTTParty.get('https://maps.googleapis.com/maps/api/place/details/json',
                            query: { key: 'AIzaSyArSkeyF4aZEv0gaTV0KcYgIyCn2BwdHnM',
                                     placeid: place_id })
    JSON.parse(response.body)
  end

  # @param [JSON] response_json
  # @return [Array] city, state, postcode
  def get_other_info(response_json)
    city = ''
    state = ''
    postcode = ''
    response_json['result']['address_components'].each do |address_info|
      city = address_info['long_name'] if address_info['types'].include? 'locality'
      state = address_info['short_name'] if address_info['types'].include? 'administrative_area_level_1'
      postcode = address_info['long_name'] if address_info['types'].include? 'postal_code'
    end
    [city, state, postcode]
  end

  # @param [String] place_id
  # @return [JSON] json result of place info for given place_id
  def get_info(place_id)
    response_json = get_json_response(place_id)
    street_name = response_json['result']['formatted_address']
    other_info = get_other_info(response_json)
    { streetAddress: street_name, city: other_info[0],
      state: other_info[1], postalCode: other_info[2] }
  end

  # @param [String] lat latitude
  # @param [String] lng longitude
  # @return [String] place id of location for given coordinate
  def get_current_place_id(lat, lng)
    current_place_res = HTTParty.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json',
                                     query: { key: 'AIzaSyArSkeyF4aZEv0gaTV0KcYgIyCn2BwdHnM',
                                              location: "#{lat},#{lng}",
                                              rankby: 'distance' })
    current_place_json = JSON.parse(current_place_res.body)
    current_place_json['results'][0]['place_id']
  end

  # @param [String] lat latitude
  # @param [String] lng longitude
  # @return [String] place id of nearest gas station for given coordinate
  def get_nearest_gs_place_id(lat, lng)
    nearest_gas_res = HTTParty.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json',
                                   query: { key: 'AIzaSyArSkeyF4aZEv0gaTV0KcYgIyCn2BwdHnM',
                                            location: "#{lat},#{lng}",
                                            rankby: 'distance',
                                            types: 'gas_station' })
    nearest_gas_json = JSON.parse(nearest_gas_res.body)
    nearest_gas_json['results'][0]['place_id']
  end

  # @return [JSON] information of current location and nearest gas station
  def nearest_gas
    lat = params[:lat]
    lng = params[:lng]
    current_place_info = get_info(get_current_place_id(lat, lng))
    nearest_gas_info = get_info(get_nearest_gs_place_id(lat, lng))
    render json: { lat: lat, lng: lng,
                   address: current_place_info, nearest_gas_station: nearest_gas_info }
  end
end
