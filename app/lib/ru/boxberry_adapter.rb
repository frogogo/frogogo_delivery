class RU::BoxberryAdapter < DeliveryAdapter
  BASE_URI = 'https://api.boxberry.ru/json.php'
  FETCH_LOCALITIES_REQUEST_BODY = {
    token: Rails.application.credentials.dig(:ru, :boxberry, :api_token),
    method: 'ListCitiesFull'
  }

  def fetch_delivery_info
    super

    @request_body = FETCH_DICTIONARY_REQUEST_BODY

    request_data
  end

  def fetch_localities_list
    @request_body = FETCH_LOCALITIES_REQUEST_BODY

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
