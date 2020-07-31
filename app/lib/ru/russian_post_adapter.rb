class RU::RussianPostAdapter < DeliveryAdapter
  POST_OFFICE_URI = 'https://otpravka-api.pochta.ru/postoffice/1.0/nearby'
  DADATA_URI = 'https://cleaner.dadata.ru/api/v1/clean/address'
  HEADERS = { 'Content-Type' => 'application/json; charset=UTF-8' }
  QUERY = {
    'top' => '1000',
    'filter' => 'ALL',
    'filter-by-office-type' => 'true'
  }

  def post_offices_list
    request_post_offices.parsed_response
  end

  private

  def post_api_token
    Rails.application.credentials.dig(:ru, :russian_post, :api_token)
  end

  def post_api_key
    Rails.application.credentials.dig(:ru, :russian_post, :api_key)
  end

  def dadata_api_token
    Rails.application.credentials.dig(:ru, :dadata, :api_token)
  end

  def dadata_secret_key
    Rails.application.credentials.dig(:ru, :dadata, :secret_key)
  end

  def request_post_offices
    HTTParty.get(
      POST_OFFICE_URI,
      headers: HEADERS.merge(
        'Authorization': "AccessToken #{post_api_token}",
        'X-User-Authorization': "Basic #{post_api_key}"
      ),
      query: QUERY.merge('latitude' => locality_latitude, 'longitude' => locality_longitude)
    )
  end

  def request_locality_coordinates
    coordinates = HTTParty.post(
      DADATA_URI,
      headers: HEADERS.merge(
        'Authorization': "Token #{dadata_api_token}",
        'X-Secret': dadata_secret_key
      ),
      body: [locality.subdivision.name, locality.name].to_json
    )

    coordinates.parsed_response
  end

  def locality_longitude
    request_locality_coordinates[1]['geo_lon']
  end

  def locality_latitude
    request_locality_coordinates[1]['geo_lat']
  end
end
