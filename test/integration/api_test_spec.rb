require 'rails_helper'

BASE_URL = 'http://localhost:3000'

RSpec.describe('API Test', type: :request) {
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
}

RSpec.describe('API call without longitude', type: :request) {
  it 'should return invalid request in API response' do
    get BASE_URL + '/nearest_gas?lat=37.77801'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('fail')
    expect(json['error']).to eq('Invalid Request')
  end
}

RSpec.describe('API call without latitude', type: :request) {
  it 'should return invalid request in API response' do
    get BASE_URL + '/nearest_gas?lng=-122.4119076'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('fail')
    expect(json['error']).to eq('Invalid Request')
  end
}

RSpec.describe('API call without latitude and longitude', type: :request) {
  it 'should return invalid request in API response' do
    get BASE_URL + '/nearest_gas'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('fail')
    expect(json['error']).to eq('Invalid Request')
  end
}

RSpec.describe('API call with invalid latitude', type: :request) {
  it 'should return invalid request in API response' do
    get BASE_URL + '/nearest_gas?lat=abc&lng=-122.4119076'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('fail')
    expect(json['error']).to eq('Invalid Request')
  end
}

RSpec.describe('API call with invalid longitude', type: :request) {
  it 'should return invalid request in API response' do
    get BASE_URL + '/nearest_gas?lat=37.77801&lng=-122.41bc9076'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('fail')
    expect(json['error']).to eq('Invalid Request')
  end
}

RSpec.describe('API call with invalid latitude', type: :request) {
  it 'should return invalid request in API response' do
    get BASE_URL + '/nearest_gas?lat=91&lng=-122.419076'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('fail')
    expect(json['error']).to eq('Invalid Request')
  end
}

RSpec.describe('API call with invalid latitude', type: :request) {
  it 'should return invalid request in API response' do
    get BASE_URL + '/nearest_gas?lat=-91&lng=-122.419076'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('fail')
    expect(json['error']).to eq('Invalid Request')
  end
}

RSpec.describe('API call with invalid longitude', type: :request) {
  it 'should return invalid request in API response' do
    get BASE_URL + '/nearest_gas?lat=37.77801&lng=181'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('fail')
    expect(json['error']).to eq('Invalid Request')
  end
}

RSpec.describe('API call with invalid longitude', type: :request) {
  it 'should return invalid request in API response' do
    get BASE_URL + '/nearest_gas?lat=37.77801&lng=-181'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('fail')
    expect(json['error']).to eq('Invalid Request')
  end
}

RSpec.describe('API call with an coordinate without valid empty address and empty nearest gas station address', type: :request) {
  it 'should return empty address and empty nearest gas station' do
    get BASE_URL + '/nearest_gas?lat=0&lng=0'
    json = JSON.parse(response.body)
    expect(response.status).to eq(200)
    expect(json['result']).to eq('suc')
    # address checking
    expect(json['data']['address']['streetAddress']).to eq('')
    expect(json['data']['address']['city']).to eq('')
    expect(json['data']['address']['state']).to eq('')
    expect(json['data']['address']['postalCode']).to eq('')
    # nearest gas checking
    expect(json['data']['nearest_gas_station']['streetAddress']).to eq('')
    expect(json['data']['nearest_gas_station']['city']).to eq('')
    expect(json['data']['nearest_gas_station']['state']).to eq('')
    expect(json['data']['nearest_gas_station']['postalCode']).to eq('')
  end
}







