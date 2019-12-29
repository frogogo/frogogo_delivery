class RU::BoxberryAdapter < DeliveryAdapter
  BASE_URI = 'https://api.boxberry.ru/json.php'
  LIST_POINTS = 'ListPoints'
  LIST_CITIES = 'ListCitiesFull'

  attr_reader :city_code

  def localities_list
    @request_body = { method: LIST_CITIES }

    request_data
  end

  def pickup_delivery_info
    @request_body = { method: LIST_POINTS, citycode: city_code }

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
