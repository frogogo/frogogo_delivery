require 'test_helper'

class DeliveryPointsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get delivery_method_delivery_points_path(delivery_methods(:russian_post))
    assert_response :success
  end
end
