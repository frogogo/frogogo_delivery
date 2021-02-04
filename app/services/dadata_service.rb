class DaDataService
  include Singleton

  CITY_CODE_URL = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/findById/delivery'
  SUGGESTIONS_URL = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address'

  def boxberry_city_code(locality_uid)
    HTTParty.get(
      CITY_CODE_URL,
      headers: default_headers,
      query: { query: locality_uid }
    ).parsed_response.dig('suggestions', 0, 'data', 'boxberry_id')
  end

  def locality_uid_from_locality_and_subdivision(locality, subdivision)
    HTTParty.get(
      SUGGESTIONS_URL,
      headers: default_headers,
      query: {
        query: locality,
        locations: [{ region: subdivision }]
      }
    ).parsed_response.dig('suggestions', 0, 'data', 'kladr_id')
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
