require 'test_helper'

class DeliveryZoneTest < ActiveSupport::TestCase
  setup do
    @delivery_zone = delivery_zones(:delivery_zone1)
  end

  test 'valid' do
    assert @delivery_zone.valid?
  end
end
