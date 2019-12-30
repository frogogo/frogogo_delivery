class RU::BoxberryAdapter < DeliveryAdapter
  BASE_URI = 'https://api.boxberry.ru/json.php'
  COURIER_LIST_CITIES = 'CourierListCities'
  LIST_CITIES = 'ListCitiesFull'
  LIST_POINTS = 'ListPoints'

  attr_accessor :city_code

  def localities_list
    @request_body = { method: LIST_CITIES }

    request_data
  end

  def pickup_delivery_info
    @request_body = { method: LIST_POINTS, CityCode: city_code }

    request_data
  end

  private

  def api_token
    Rails.application.credentials.dig(:ru, :boxberry, :api_token)
  end

  def request_data
    HTTParty.get(
      BASE_URI,
      query: request_body.merge(token: api_token)
    )
  end
end
