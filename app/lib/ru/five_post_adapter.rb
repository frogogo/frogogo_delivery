class RU::FivePostAdapter
  POINTS_URI = 'https://api-omni.x5.ru/api/v1/pickuppoints/query'
  JWT_TOKEN_URI = 'https://api-omni.x5.ru/jwt-generate-claims/rs256/1'

  def pickup_point_list
    page_number = make_post_request(0)['totalPages']
    @pickup_point_list ||= Array.new(page_number) { |index| make_post_request(index)['content'] }
      .flatten!
  end

  def clear_points
    return if @pickup_point_list.blank?

    @pickup_point_list = nil
  end

  def make_post_request(page)
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

  def jwt_token
    response = HTTParty.post(
      JWT_TOKEN_URI,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      query: { 'apikey' => api_key },
      body: { 'subject' => 'OpenAPI', 'audience' => 'A122019!' }
    )

    JSON.parse(response)['jwt']
  end

  def api_key
    Rails.application.credentials.dig(:ru, :five_post, :api_key)
  end
end
