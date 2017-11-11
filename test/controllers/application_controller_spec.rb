require 'rails_helper'

RSpec.describe 'call get_json method without place_id' do
  it 'should return {}' do
    application_controller = ApplicationController.new
    expect(application_controller.get_json_response(nil)).to eq({})
  end
end

RSpec.describe 'call get_json method with valid place_id' do
  it 'should return valid response' do
    application_controller = ApplicationController.new
    json_result = application_controller.get_json_response('ChIJNYfwSIOAhYARGmfw6nQJ_Fc')
    expect(json_result['result']['address_components']).to eq([{ 'long_name' => '1161', 'short_name' => '1161', 'types' => ['street_number'] }, { 'long_name' => 'Mission Street', 'short_name' => 'Mission St', 'types' => ['route'] }, { 'long_name' => 'South of Market', 'short_name' => 'South of Market', 'types' => %w[neighborhood political] }, { 'long_name' => 'San Francisco', 'short_name' => 'SF', 'types' => %w[locality political] }, { 'long_name' => 'San Francisco County', 'short_name' => 'San Francisco County', 'types' => %w[administrative_area_level_2 political] }, { 'long_name' => 'California', 'short_name' => 'CA', 'types' => %w[administrative_area_level_1 political] }, { 'long_name' => 'United States', 'short_name' => 'US', 'types' => %w[country political] }, { 'long_name' => '94103', 'short_name' => '94103', 'types' => ['postal_code'] }])
  end
end

RSpec.describe 'call get_json method with invalid place_id' do
  it 'should return invalid request error' do
    application_controller = ApplicationController.new
    json_result = application_controller.get_json_response('123')
    expect(json_result['status']).to eq('INVALID_REQUEST')
  end
end

RSpec.describe 'call get_info method with nil place_id' do
  it 'should return {}' do
    application_controller = ApplicationController.new
    json_result = application_controller.get_info(nil)
    expect(json_result).to eq(streetAddress: '', city: '', state: '', postalCode: '')
  end
end

RSpec.describe 'call get_info method with nil place_id' do
  it 'should return {}' do
    application_controller = ApplicationController.new
    json_result = application_controller.get_info(nil)
    expect(json_result).to eq(streetAddress: '', city: '', state: '', postalCode: '')
  end
end

RSpec.describe 'call get_info method with valid place_id' do
  it 'should return valid response' do
    application_controller = ApplicationController.new
    json_result = application_controller.get_info('ChIJNYfwSIOAhYARGmfw6nQJ_Fc')
    expect(json_result).to eq(streetAddress: '1161 Mission St, San Francisco, CA 94103, USA', city: 'San Francisco', state: 'CA', postalCode: '94103')
  end
end

RSpec.describe 'call get_info method with invalid place_id' do
  it 'should return empty response' do
    application_controller = ApplicationController.new
    json_result = application_controller.get_info('123')
    expect(json_result).to eq(streetAddress: '', city: '', state: '', postalCode: '')
  end
end


RSpec.describe 'call get_current_place_id method with valid latitude and longitude' do
  it 'should return valid place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_current_place_id('37.77801', '-122.4119076')
    expect(result).to eq('ChIJNYfwSIOAhYARGmfw6nQJ_Fc')
  end
end

RSpec.describe 'call get_current_place_id method with invalid latitude and longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_current_place_id(nil, nil)
    expect(result).to eq('')
  end
end

RSpec.describe 'call get_current_place_id method with invalid latitude and valid longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_current_place_id('91', '0')
    expect(result).to eq('')
  end
end

RSpec.describe 'call get_current_place_id method with invalid latitude and valid longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_current_place_id('-91', '0')
    expect(result).to eq('')
  end
end

RSpec.describe 'call get_current_place_id method with valid latitude and invalid longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_current_place_id('0', '181')
    expect(result).to eq('')
  end
end

RSpec.describe 'call get_current_place_id method with valid latitude and invalid longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_current_place_id('0', '-181')
    expect(result).to eq('')
  end
end


RSpec.describe 'call get_nearest_gs_place_id method with valid latitude and longitude' do
  it 'should return valid place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_nearest_gs_place_id('37.77801', '-122.4119076')
    expect(result).to eq('ChIJB86pNJ2AhYARUo3Ik44JMcc')
  end
end

RSpec.describe 'call get_nearest_gs_place_id method with invalid latitude and longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_nearest_gs_place_id(nil, nil)
    expect(result).to eq('')
  end
end

RSpec.describe 'call get_nearest_gs_place_id method with invalid latitude and valid longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_nearest_gs_place_id('91', '0')
    expect(result).to eq('')
  end
end

RSpec.describe 'call get_nearest_gs_place_id method with invalid latitude and valid longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_nearest_gs_place_id('-91', '0')
    expect(result).to eq('')
  end
end

RSpec.describe 'call get_nearest_gs_place_id method with valid latitude and invalid longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_nearest_gs_place_id('0', '181')
    expect(result).to eq('')
  end
end

RSpec.describe 'call get_nearest_gs_place_id method with valid latitude and invalid longitude' do
  it 'should return empty place id' do
    application_controller = ApplicationController.new
    result = application_controller.get_nearest_gs_place_id('0', '-181')
    expect(result).to eq('')
  end
end