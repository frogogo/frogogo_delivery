class RU::RussianPostAdapter < DeliveryAdapter
  POSTAL_CODES_URI = 'https://otpravka-api.pochta.ru/postoffice/1.0/settlement.offices.codes'
  POST_OFFICE_URI = 'https://otpravka-api.pochta.ru/postoffice/1.0/'
  HEADERS = {
    'Content-Type' => 'application/json; charset=UTF-8',
    'Authorization' => '',
    'X-User-Authorization' => ''
  }
  QUERY = {
    'settlement' => '',
    'region' => ''
  }

  def postal_codes
    request_postal_codes ||= HTTParty.get(
      POSTAL_CODES_URI,
      headers: HEADERS.merge(
        'Authorization': "AccessToken #{api_token}",
        'X-User-Authorization': "Basic #{api_key}"
      ),
      query: QUERY.merge(settlement: locality.name, region: locality.subdivision.name)
    )

    request_postal_codes.parsed_response
  end

  def post_offices_list
    post_offices_list = {}

    postal_codes.each do |postal_code|
      request_post_offices = HTTParty.get(
        POST_OFFICE_URI + postal_code.to_s,
        headers: HEADERS.merge(
          'Authorization': "AccessToken #{api_token}",
          'X-User-Authorization': "Basic #{api_key}"
        )
      )

      post_offices_list = post_offices_list.merge(request_post_offices.parsed_response)
    end

    post_offices_list
  end

  private

  def api_token
    Rails.application.credentials.dig(:ru, :russian_post, :api_token)
  end

  def api_key
    Rails.application.credentials.dig(:ru, :russian_post, :api_key)
  end
end
