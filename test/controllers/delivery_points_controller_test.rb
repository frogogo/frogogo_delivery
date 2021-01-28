require 'test_helper'

class DeliveryPointsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get delivery_points_index_url
    assert_response :success
  end
end
