require 'rails_helper'

BASE_URL = 'http://localhost:3000'

RSpec.describe 'API Test', type: :request do
  it 'should return API sample response' do
    get BASE_URL + '/nearest_gas?lat=37.77801&lng=-122.4119076'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)

    expect(json['result']).to eq('suc')
    # address checking
    expect(json['data']['address']['streetAddress']).to eq('1161 Mission St, San Francisco, CA 94103, USA')
    expect(json['data']['address']['city']).to eq('San Francisco')
    expect(json['data']['address']['state']).to eq('CA')
    expect(json['data']['address']['postalCode']).to eq('94103')
    # nearest gas checking
    expect(json['data']['nearest_gas_station']['streetAddress']).to eq('1298 Howard St, San Francisco, CA 94103, USA')
    expect(json['data']['nearest_gas_station']['city']).to eq('San Francisco')
    expect(json['data']['nearest_gas_station']['state']).to eq('CA')
    expect(json['data']['nearest_gas_station']['postalCode']).to eq('94103')
  end
  it 'should return API sample response' do
    get BASE_URL + '/nearest_gas?lat=37.77801&lng=-122.4119076'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)

    expect(json['result']).to eq('suc')
    # address checking
    expect(json['data']['address']['streetAddress']).to eq('1161 Mission St, San Francisco, CA 94103, USA')
    expect(json['data']['address']['city']).to eq('San Francisco')
    expect(json['data']['address']['state']).to eq('CA')
    expect(json['data']['address']['postalCode']).to eq('94103')
    # nearest gas checking
    expect(json['data']['nearest_gas_station']['streetAddress']).to eq('1298 Howard St, San Francisco, CA 94103, USA')
    expect(json['data']['nearest_gas_station']['city']).to eq('San Francisco')
    expect(json['data']['nearest_gas_station']['state']).to eq('CA')
    expect(json['data']['nearest_gas_station']['postalCode']).to eq('94103')
  end
end
