require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  setup do
    @provider = providers(:shoplogistics)
  end

  test 'valid' do
    assert @provider.valid?
  end
end
