class DaDataService
  include Singleton

  CITY_CODE_URL = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/findById/delivery'

  def initialize
  end

  def boxberry_city_code(locality_uid)
    HTTParty.get(
      CITY_CODE_URL,
      headers: HEADERS.merge(Authorization: "Token #{dadata_token}"),
      query: { query: locality_uid }
    ).parsed_response.dig('suggestions', 0, 'data', 'boxberry_id')
  end

  private

  def dadata_token
    Rails.application.credentials.dig(:ru, :dadata, :api_token)
  end
end
