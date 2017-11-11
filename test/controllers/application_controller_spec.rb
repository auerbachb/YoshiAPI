require 'rails_helper'

RSpec.describe 'call get_json method without place_id' do
  it 'should return {}' do
    application_controller = ApplicationController.new
    expect(application_controller.get_json_response(nil)).to eq({})
  end
end

RSpec.describe 'call get_json method with valid place_id' do
  it 'should do something' do
    application_controller = ApplicationController.new
    json_result = application_controller.get_json_response('ChIJNYfwSIOAhYARGmfw6nQJ_Fc')
    expect(json_result['result']['address_components']).to eq([{ 'long_name' => '1161', 'short_name' => '1161', 'types' => ['street_number'] }, { 'long_name' => 'Mission Street', 'short_name' => 'Mission St', 'types' => ['route'] }, { 'long_name' => 'South of Market', 'short_name' => 'South of Market', 'types' => %w[neighborhood political] }, { 'long_name' => 'San Francisco', 'short_name' => 'SF', 'types' => %w[locality political] }, { 'long_name' => 'San Francisco County', 'short_name' => 'San Francisco County', 'types' => %w[administrative_area_level_2 political] }, { 'long_name' => 'California', 'short_name' => 'CA', 'types' => %w[administrative_area_level_1 political] }, { 'long_name' => 'United States', 'short_name' => 'US', 'types' => %w[country political] }, { 'long_name' => '94103', 'short_name' => '94103', 'types' => ['postal_code'] }])
  end
end

RSpec.describe 'call get_json method with invalid place_id' do
  it 'should do something' do
    application_controller = ApplicationController.new
    json_result = application_controller.get_json_response('123')
    expect(json_result['status']).to eq('INVALID_REQUEST')
  end
end

