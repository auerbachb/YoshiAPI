class ApplicationController < ActionController::API

  def get_info(place_id)
    response = HTTParty.get('https://maps.googleapis.com/maps/api/place/details/json',
                            query: { key: 'AIzaSyArSkeyF4aZEv0gaTV0KcYgIyCn2BwdHnM', placeid: place_id })
    response_json = JSON.parse(response.body)
    current_street_name = response_json['result']['formatted_address']
    current_city = ''
    current_state = ''
    current_postcode = ''
    address_infos = response_json['result']['address_components']
    address_infos.each do |address_info|
      current_city = address_info['long_name'] if address_info['types'].include? 'locality'
      current_state = address_info['short_name'] if address_info['types'].include? 'administrative_area_level_1'
      current_postcode = address_info['long_name'] if address_info['types'].include? 'postal_code'
    end

    { streetAddress: current_street_name, city: current_city,
      state: current_state, postalCode: current_postcode }
  end
  
  def nearest_gas
    lat = params[:lat]
    lng = params[:lng]

    current_place_res = HTTParty.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json',
                            query: {key: 'AIzaSyArSkeyF4aZEv0gaTV0KcYgIyCn2BwdHnM', location: "#{lat},#{lng}", rankby: 'distance' })
    current_place_json = JSON.parse(current_place_res.body)

    current_place_id = current_place_json['results'][0]['place_id']

    current_place_info = get_info(current_place_id)

    nearest_gas_res = HTTParty.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json',
                                   query: {key: 'AIzaSyArSkeyF4aZEv0gaTV0KcYgIyCn2BwdHnM', location: "#{lat},#{lng}", rankby: 'distance', types: 'gas_station'})
    nearest_gas_json = JSON.parse(nearest_gas_res.body)

    nearest_gas_id = nearest_gas_json['results'][0]['place_id']

    nearest_gas_info = get_info(nearest_gas_id)

    render json: { lat: lat, lng: lng,
                   address: current_place_info, nearest_gas_station: nearest_gas_info}
  end
end
``
