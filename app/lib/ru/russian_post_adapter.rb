class RU::RussianPostAdapter < DeliveryAdapter
  BASE_URI = 'https://otpravka-api.pochta.ru/postoffice/1.0/settlement.offices.codes'
  HEADERS = {
    'Content-Type' => 'application/json; charset=UTF-8',
    'Authorization' => '',
    'X-User-Authorization' => ''
  }
  QUERY = {
    'settlement' => '',
    'region' => ''
  }

  def postal_codes_list
    request_data.parsed_response
  end

  private

  def api_token
    Rails.application.credentials.dig(:ru, :russian_post, :api_token)
  end

  def api_key
    Rails.application.credentials.dig(:ru, :russian_post, :api_key)
  end

  def request_data
    HTTParty.get(
      BASE_URI,
      headers: HEADERS.merge(
        'Authorization': "AccessToken #{api_token}",
        'X-User-Authorization': "Basic #{api_key}"
      ),
      query: QUERY.merge(settlement: locality.name, region: locality.subdivision.name)
    )
  end
end
