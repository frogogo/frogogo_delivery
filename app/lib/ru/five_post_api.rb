class RU::FivePostAPI
  POINTS_URI = 'https://api-omni.x5.ru/api/v1/pickuppoints/query'
  JWT_TOKEN_URI = 'https://api-omni.x5.ru/jwt-generate-claims/rs256/1'

  def pickup_points
    @pickup_points ||= Array.new(page_number) { |index| points_per_page(index)['content'] }
      .flatten!
  end

  def points_per_page(page)
    HTTParty.post(
      POINTS_URI,
      headers: {
        'Content-Type' => 'application/json; charset=utf-8',
        'Authorization' => "Bearer #{jwt_token}"
      },
      body: { 'pageSize' => 1000, 'pageNumber' => page }.to_json
    ).parsed_response
  end

  private

  def page_number
    points_per_page(0)['totalPages']
  end

  def jwt_token
    response = HTTParty.post(
      JWT_TOKEN_URI,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      query: { 'apikey' => api_key },
      # 'subject=OpenAPI&audience=A122019!' –
      # остается одинаковыми для всех сред и заполняются из примера
      body: { 'subject' => 'OpenAPI', 'audience' => 'A122019!' }
    )

    JSON.parse(response)['jwt']
  end

  def api_key
    Rails.application.credentials.dig(:ru, :five_post, :api_key)
  end
end
