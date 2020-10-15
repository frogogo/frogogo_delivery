class RU::RussianPostAdapter < DeliveryAdapter
  POST_OFFICE_URI = 'https://otpravka-api.pochta.ru/postoffice/1.0/nearby'
  INTERVALS_URI = 'https://tariff.pochta.ru/delivery/v1/calculate?json'
  HEADERS = { 'Content-Type' => 'application/json; charset=UTF-8' }
  QUERY = { 'filter-by-office-type' => 'true', 'filter' => 'ALL', 'top' => '500' }
  PARCEL_TYPE = '23030'
  SENDER_CODE = '140961'

  def post_offices_list
    request_post_offices.parsed_response
  end

  def request_intervals(post_office)
    HTTParty.get(
      INTERVALS_URI,
      query: { 'object' => PARCEL_TYPE, 'from' => SENDER_CODE, 'to' => post_office }
    ).parsed_response
  end

  private

  def request_post_offices
    HTTParty.get(
      POST_OFFICE_URI,
      headers: HEADERS.merge(
        'Authorization': "AccessToken #{post_api_token}",
        'X-User-Authorization': "Basic #{post_api_key}"
      ),
      query: QUERY.merge('latitude' => locality.latitude, 'longitude' => locality.longitude)
    )
  end

  def post_api_token
    Rails.application.credentials.dig(:ru, :russian_post, :api_token)
  end

  def post_api_key
    Rails.application.credentials.dig(:ru, :russian_post, :api_key)
  end
end
