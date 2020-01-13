require 'test_helper'

class DeliveryMethodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @moscow = localities(:moscow)
    @istanbul = localities(:istanbul)
  end

  test 'should return delivery methods for moscow' do
    get delivery_methods_path,
        headers: {
          'Accept' => 'application/json',
          'Accept-Language' => 'ru'
        },
        params: {
          locality: @moscow.name,
          subdivision: @moscow.subdivision.name
        }

    assert_response :success
  end

  test 'should raise argument error' do
    assert_raises(ArgumentError) do
      get delivery_methods_path,
          headers: {
            Accept: 'application/json'
          }
    end
  end

  test 'should return not found' do
    get delivery_methods_path,
        headers: {
          'Accept' => 'application/json',
          'Accept-Language' => 'ru'
        }

    assert_response :not_found
  end

  test 'should return turkey post for turkey locale' do
    get delivery_methods_path,
        headers: {
          'Accept' => 'application/json',
          'Accept-Language' => 'tr'
        },
        params: {
          locality: @istanbul.name,
          subdivision: @istanbul.subdivision.name
        }

    assert_response :success
  end
end
