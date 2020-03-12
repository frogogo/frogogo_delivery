require 'test_helper'

class DeliveryZonesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @moscow = localities(:moscow)
  end

  test 'should return not found' do
    get delivery_zone_path,
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'ru'
        }.merge(bearer_token)

    assert_response :not_found
  end

  test 'should return delivery zone for moscow' do
    get delivery_zone_path,
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'ru'
        }.merge(bearer_token),
        params: {
          locality: @moscow.name,
          subdivision: @moscow.subdivision.name
        }

    assert_response :success
  end
end
