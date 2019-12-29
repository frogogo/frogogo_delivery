require 'test_helper'

class DeliveryPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @delivery_method_pickup = delivery_methods(:shoplogistics_pickup)
    @delivery_method_post = delivery_methods(:turkey_post)
  end

  test 'should return delivery points' do
    get delivery_method_delivery_points_path(
      @delivery_method_pickup,
      headers: {
        Accept: 'application/json'
      }
    )

    assert_response :success
  end

  test 'should return not found' do
    get delivery_methods_path(
      @delivery_method_post,
      headers: {
        Accept: 'application/json'
      }
    )

    assert_response :not_found
  end
end
