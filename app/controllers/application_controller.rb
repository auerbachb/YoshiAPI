class ApplicationController < ActionController::API
  def nearest_gas
    lat = params[:lat]
    lng = params[:lng]

    response = HTTParty.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json',
                            query: {key: 'AIzaSyArSkeyF4aZEv0gaTV0KcYgIyCn2BwdHnM', location: "#{lat},#{lng}", rankby: 'distance' })
    json_response = JSON.parse(response.body)

    place_id = json_response['results'][0]['place_id']

    detail_response = HTTParty.get('https://maps.googleapis.com/maps/api/place/details/json',
                                   query: {key: 'AIzaSyArSkeyF4aZEv0gaTV0KcYgIyCn2BwdHnM', placeid: place_id })
    json_detail = JSON.parse(detail_response.body)

    # Get Info for current location
    current_street_name = json_detail['result']['formatted_address']
    current_city = ''
    current_state = ''
    current_postcode = ''
    address_infos = json_detail['result']['address_components']
    address_infos.each do |address_info|
      current_city = address_info['long_name'] if address_info['types'].include? 'locality'
      current_state = address_info['short_name'] if address_info['types'].include? 'administrative_area_level_1'
      current_postcode = address_info['long_name'] if address_info['types'].include? 'postal_code'
    end

    render json: { lat: lat, lng: lng,
                   address: { streetAddress: current_street_name, city: current_city,
                              state: current_state, postalCode: current_postcode}}
  end
end
``
