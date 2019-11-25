require 'test_helper'

class SubdivisionTest < ActiveSupport::TestCase
  setup do
    @subdivision = subdivisions(:moscow)
  end

  test 'valid' do
    assert @subdivision.valid?
  end
end
