require 'test_helper'

class DeliveryPointTest < ActiveSupport::TestCase
  setup do
    @delivery_point = delivery_points(:delivery_point1)
  end

  test 'valid' do
    @delivery_point.valid?
  end

  test 'should not duplicate delivery_point' do
    assert @delivery_point.dup.invalid?
  end
end
