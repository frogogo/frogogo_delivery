class RU::BoxberryAdapter < DeliveryAdapter
  BASE_URI = 'https://api.boxberry.ru/json.php'
  DELIVERY_INFO_REQUEST_BODY = {
    token: Rails.application.credentials.dig(:ru, :boxberry, :api_token),
    method: 'ListPoints'
  }
  LOCALITIES_REQUEST_BODY = {
    token: Rails.application.credentials.dig(:ru, :boxberry, :api_token),
    method: 'ListCitiesFull'
  }

  def delivery_info
    super

    @request_body = DELIVERY_INFO_REQUEST_BODY.merge(citycode: locality.name)

    request_data
  end

  def localities_list
    @request_body = LOCALITIES_REQUEST_BODY

    request_data
  end

  private

  def request_data
    HTTParty.get(
      BASE_URI,
      query: request_body
    )
  end
end
