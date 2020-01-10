require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  setup do
    @provider = providers(:shoplogistics)
  end

  test 'valid' do
    assert @provider.valid?
  end

  test 'should update inactive field in delivery methods' do
    @provider.inactive = !@provider.inactive
    @provider.save

    assert @provider.delivery_methods.pluck(:inactive).all?(@provider.inactive)
  end
end
