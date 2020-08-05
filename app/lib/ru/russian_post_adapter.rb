class RU::RussianPostAdapter < DeliveryAdapter
  POSTAL_CODES_URI = 'https://otpravka-api.pochta.ru/postoffice/1.0/settlement.offices.codes'
  POST_OFFICE_URI = 'https://otpravka-api.pochta.ru/postoffice/1.0/'
  HEADERS = { 'Content-Type' => 'application/json; charset=UTF-8' }
  QUERY = { 'filter-by-office-type' => 'true' }

  def post_offices_list
    request_postal_codes.parsed_response
  end

  def request_post_offices(post_office)
    HTTParty.get(
      POST_OFFICE_URI + post_office,
      headers: HEADERS.merge(
        'Authorization': "AccessToken #{post_api_token}",
        'X-User-Authorization': "Basic #{post_api_key}"
      ),
      query: QUERY
    ).parsed_response
  end

  private

  def post_api_token
    Rails.application.credentials.dig(:ru, :russian_post, :api_token)
  end

  def post_api_key
    Rails.application.credentials.dig(:ru, :russian_post, :api_key)
  end

  def request_postal_codes
    HTTParty.get(
      POSTAL_CODES_URI,
      headers: HEADERS.merge(
        'Authorization': "AccessToken #{post_api_token}",
        'X-User-Authorization': "Basic #{post_api_key}"
      ),
      query: { 'settlement' => locality.name, 'region' => locality.subdivision.name }
    )
  end

  def locality_longitude
    request_locality_coordinates[1]['geo_lon']
  end

  def locality_latitude
    request_locality_coordinates[1]['geo_lat']
  end
end
