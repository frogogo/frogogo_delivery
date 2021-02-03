require 'test_helper'

class DeliveryMethodTest < ActiveSupport::TestCase
  setup do
    @delivery_method = delivery_methods(:russian_post)
  end

  test 'valid' do
    assert @delivery_method.valid?
  end

  test 'should update delivery_methods_updated_at' do
    locality = @delivery_method.deliverable

    assert_nil locality.delivery_methods_updated_at

    @delivery_method.update!(date_interval: '2-3')

    assert locality.delivery_methods_updated_at.present?
  end
end
