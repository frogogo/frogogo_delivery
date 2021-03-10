class DaDataService
  include Singleton

  CITY_CODE_URL = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/findById/delivery'
  SUGGESTIONS_URL = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address'
  FIND_BY_KLADR_URL = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/findById/address'

  def boxberry_city_code(locality_uid)
    HTTParty.get(
      CITY_CODE_URL,
      headers: default_headers,
      query: { query: locality_uid }
    ).parsed_response.dig('suggestions', 0, 'data', 'boxberry_id')
  end

  def suggestion_from_locality_and_subdivision(locality, subdivision)
    HTTParty.post(
      SUGGESTIONS_URL,
      headers: default_headers,
      body: {
        query: locality,
        from_bound: { value: 'city' },
        to_bound: { value: 'settlement' },
        locations: [{ region: subdivision }],
        restrict_value: false
      }.to_json
    ).parsed_response.dig('suggestions', 0, 'data')
  end

  def suggestion_from_locality_uid(locality_uid)
    HTTParty.post(
      FIND_BY_KLADR_URL,
      headers: default_headers,
      body: {
        query: locality_uid
      }.to_json
    ).parsed_response.dig('suggestions', 0, 'data')
  end

  private

  def default_headers
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'Authorization' => "Token #{dadata_token}"
    }
  end

  def dadata_token
    Rails.application.credentials.dig(:ru, :dadata, :api_token)
  end
end
