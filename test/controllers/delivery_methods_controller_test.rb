require 'test_helper'

class DeliveryMethodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @moscow = localities(:moscow)
    @istanbul = localities(:istanbul)
  end

  test 'should return delivery methods for moscow' do
    get delivery_methods_path(
      headers: {
        Accept: 'application/json'
      },
      params: {
        locale: :ru,
        locality: @moscow.name,
        subdivision: @moscow.subdivision.name
      }
    )

    assert_response :success
  end

  test 'should return not found' do
    get delivery_methods_path(
      headers: {
        Accept: 'application/json'
      }
    )

    assert_response :not_found
  end

  test 'should return turkey post for turkey locale' do
    get delivery_methods_path(
      headers: {
        Accept: 'application/json'
      },
      params: {
        locale: :tr,
        locality: @istanbul.name,
        subdivision: @istanbul.subdivision.name
      }
    )

    assert_response :success
  end
end
