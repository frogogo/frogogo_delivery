require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  setup do
    @delivery_method = delivery_methods(:russian_post)
  end

  test 'valid' do
    assert @delivery_method.valid?
  end

  test '#needs_update?' do
    assert @delivery_method.needs_update?

    assert @delivery_method.touch
    assert_not @delivery_method.needs_update?

    travel 1.month
    assert @delivery_method.needs_update?
  end
end
