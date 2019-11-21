require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  setup do
    @country = countries(:russia)
  end

  test 'valid' do
    assert @country.valid?
  end
end
