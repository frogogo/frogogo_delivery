class RU::BoxberryAdapter < DeliveryAdapter
  BASE_URI = 'https://api.boxberry.ru/json.php'
  DADATA_CITY_CODE_URI = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/findById/delivery'
  COURIER_LIST_CITIES = 'CourierListCities'
  LIST_POINTS = 'ListPoints'
  HEADERS = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

  def courier_localities_list
    @request_body = { method: COURIER_LIST_CITIES }

    request_data.parsed_response
  end

  def pickup_delivery_info
    @request_body = { method: LIST_POINTS, CityCode: city_code }
    request_data.parsed_response
  end

  def city_code
    HTTParty.get(
      DADATA_CITY_CODE_URI,
      headers: HEADERS.merge('Authorization': "Token #{dadata_token}"),
      query: { query: locality.kladr_id }
    ).parsed_response.dig('suggestions', 0, 'data', 'boxberry_id')
  end

  private

  def request_data
    HTTParty.get(
      BASE_URI,
      query: request_body.merge(token: api_token)
    )
  end

  def api_token
    Rails.application.credentials.dig(:ru, :boxberry, :api_token)
  end

  def dadata_token
    Rails.application.credentials.dig(:ru, :dadata, :api_token)
  end
end
