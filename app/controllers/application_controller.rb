class ApplicationController < ActionController::API
  # @param [String] place_id
  # @return [JSON] json result for given place id
  def get_json_response(place_id)
    response = HTTParty.get('https://maps.googleapis.com/maps/api/place/details/json',
                            query: { key: YoshiAPI::Application.config.google_api_key,
                                     placeid: place_id })
    JSON.parse(response.body)
  rescue
    {}
  end

  # @param [String] place_id
  # @return [JSON] json result of place info for given place_id
  def get_info(place_id)
    response_json = get_json_response(place_id)
    street_name = response_json['result']['formatted_address']
    city = '', state = '', postcode = ''
    response_json['result']['address_components'].each do |address_info|
      city = address_info['long_name'] if address_info['types'].include? 'locality'
      state = address_info['short_name'] if address_info['types'].include? 'administrative_area_level_1'
      postcode = address_info['long_name'] if address_info['types'].include? 'postal_code'
    end
    { streetAddress: street_name, city: city,
      state: state, postalCode: postcode }
  rescue
    { streetAddress: '', city: '',
      state: '', postalCode: '' }
  end

  # @param [String] lat latitude
  # @param [String] lng longitude
  # @return [String] place id of location for given coordinate
  def get_current_place_id(lat, lng)
    current_place_res = HTTParty.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json',
                                     query: { key: YoshiAPI::Application.config.google_api_key,
                                              location: "#{lat},#{lng}",
                                              rankby: 'distance' })
    current_place_json = JSON.parse(current_place_res.body)
    current_place_json['results'][0]['place_id']
  rescue
    ''
  end

  # @param [String] lat latitude
  # @param [String] lng longitude
  # @return [String] place id of nearest gas station for given coordinate
  def get_nearest_gs_place_id(lat, lng)
    nearest_gas_res = HTTParty.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json',
                                   query: { key: YoshiAPI::Application.config.google_api_key,
                                            location: "#{lat},#{lng}",
                                            rankby: 'distance',
                                            types: 'gas_station' })
    nearest_gas_json = JSON.parse(nearest_gas_res.body)
    nearest_gas_json['results'][0]['place_id']
  rescue
    ''
  end

  # @return [JSON] information of current location and nearest gas station
  def nearest_gas
    if params[:lat].to_s.blank? || params[:lng].to_s.blank?
      render json: { result: 'fail', error: 'Invalid Request' }
      return
    end
    lat = params[:lat]
    lng = params[:lng]
    if lat.to_f < -90 || lat.to_f > 90 || lng.to_f < -180 || lng.to_f > 180
      render json: { result: 'fail', error: 'Invalid coordinate' }
      return
    end
    current_place_info = get_info(get_current_place_id(lat, lng))
    nearest_gas_info = get_info(get_nearest_gs_place_id(lat, lng))
    render json: { result: 'suc', data: { address: current_place_info, nearest_gas_station: nearest_gas_info } }
  rescue
    render json: { result: 'fail', error: 'Internal Error' }
  end
end
