require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  setup do
    @delivery_method = delivery_methods(:turkey_post)
  end

  test 'valid' do
    assert @delivery_method.valid?
  end
end
