class String
  def is_number?
    true if Float(self)
  rescue
    false
  end
end

class ApplicationController < ActionController::API
  def insert_new_record(lat, lng, current_place_info, nearest_gas_info)
    db = ActiveRecord::Base.connection
    db.execute 'CREATE TABLE IF NOT EXISTS Records(lat_and_lng TEXT PRIMARY KEY, street_address TEXT, city TEXT, state TEXT, postal_code TEXT, ns_street_address TEXT, ns_city TEXT, ns_state TEXT, ns_postal_code TEXT)'
    sql = format("INSERT INTO Records VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s');", "#{lat} #{lng}", current_place_info[:streetAddress], current_place_info[:city], current_place_info[:state], current_place_info[:postalCode], nearest_gas_info[:streetAddress], nearest_gas_info[:city],
                 nearest_gas_info[:state], nearest_gas_info[:postalCode])
    db.execute(sql)
  rescue Exception => e
    puts 'Exception occurred'
    puts e
  ensure
    db.close if db
  end

  def retrieve_a_record(lat, lng)
    db = ActiveRecord::Base.connection
    db.execute 'CREATE TABLE IF NOT EXISTS Records(lat_and_lng TEXT PRIMARY KEY, street_address TEXT, city TEXT, state TEXT, postal_code TEXT, ns_street_address TEXT, ns_city TEXT, ns_state TEXT, ns_postal_code TEXT)'
    sql = format("SELECT * FROM Records WHERE lat_and_lng='%s';", "#{lat} #{lng}")
    row = db.select_one(sql)
    unless row.nil?
      return true, {
        address: {
          streetAddress: row['street_address'],
          city: row['city'],
          state: row['state'],
          postalCode: row['postal_code']
        }, nearest_gas_station: {
          streetAddress: row['ns_street_address'],
          city: row['ns_city'],
          state: row['ns_state'],
          postalCode: row['ns_postal_code']
        }
      }
    end
    return false, nil
  rescue Exception => e
    puts 'Exception occurred'
    puts e
    return false, nil
  ensure
    db.close if db
  end

  # @param [String] place_id
  # @return [JSON] json result for given place id
  def get_json_response(place_id)
    return {} if place_id.nil?
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
    return { streetAddress: '', city: '', state: '', postalCode: '' } if place_id.nil?
    response_json = get_json_response(place_id)
    city = '', state = '', postcode = ''
    response_json['result']['address_components'].each do |address_info|
      city = address_info['long_name'] if address_info['types'].include? 'locality'
      state = address_info['short_name'] if address_info['types'].include? 'administrative_area_level_1'
      postcode = address_info['long_name'] if address_info['types'].include? 'postal_code'
    end
    { streetAddress: response_json['result']['formatted_address'], city: city,
      state: state, postalCode: postcode }
  rescue
    { streetAddress: '', city: '',
      state: '', postalCode: '' }
  end

  # @param [String] lat latitude
  # @param [String] lng longitude
  # @return [String] place id of location for given coordinate
  def get_current_place_id(lat, lng)
    return '' unless lat.is_number? && lng.is_number?
    return '' unless lat.to_f >= -90 && lat.to_f <= 90 && lng.to_f >= -180 && lng.to_f <= 180
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
    return '' unless lat.is_number? && lng.is_number?
    return '' unless lat.to_f >= -90 && lat.to_f <= 90 && lng.to_f >= -180 && lng.to_f <= 180
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
    unless lat.is_number? && lng.is_number?
      render json: { result: 'fail', error: 'Invalid Request' }
      return
    end
    unless lat.to_f >= -90 && lat.to_f <= 90 && lng.to_f >= -180 && lng.to_f <= 180
      render json: { result: 'fail', error: 'Invalid Request' }
      return
    end
    result, data = retrieve_a_record(lat, lng)
    if result
      render json: { result: 'suc', data: data }
      return
    end
    current_place_info = get_info(get_current_place_id(lat, lng))
    nearest_gas_info = get_info(get_nearest_gs_place_id(lat, lng))
    insert_new_record(lat, lng, current_place_info, nearest_gas_info)
    render json: { result: 'suc', data: { address: current_place_info, nearest_gas_station: nearest_gas_info } }
  rescue Exception => e
    puts e
    render json: { result: 'fail', error: 'Internal Error' }
  end
end
