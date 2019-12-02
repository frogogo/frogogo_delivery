require 'test_helper'

class LocalityTest < ActiveSupport::TestCase
  setup do
    @locality = localities(:moscow)
  end

  test 'valid' do
    assert @locality.valid?
  end
end
