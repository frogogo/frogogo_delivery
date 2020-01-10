require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  setup do
    @delivery_method = delivery_methods(:turkey_post)
  end

  test 'valid' do
    assert @delivery_method.valid?
  end

  test 'should update inactive field in delivery points' do
    @delivery_method.inactive = !@delivery_method.inactive
    @delivery_method.save

    assert @delivery_method.delivery_points.pluck(:inactive).all?(@delivery_method.inactive)
  end
end
