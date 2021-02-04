class RU::BoxberryAdapter < DeliveryAdapter
  BASE_URI = 'https://api.boxberry.ru/json.php'
  DADATA_CITY_CODE_URI = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/findById/delivery'
  COURIER_LIST_CITIES = 'CourierListCities'
  LIST_POINTS = 'ListPoints'

  def courier_localities_list(locality_name)
    @request_body = { method: COURIER_LIST_CITIES }

    request_data.parsed_response.select { |locality| locality['City'] == locality_name }
  end

  def pickup_delivery_info
    city_code = DaDataService.instance.boxberry_city_code(locality.locality_uid)

    @request_body = {
      method: LIST_POINTS,
      CityCode: city_code
    }
    request_data.parsed_response
  end

  private

  def request_data
    HTTParty.get(
      BASE_URI,
      query: request_body.merge(token: api_token)
    )
  end

  def api_token
    Rails.application.credentials.dig(:ru, :boxberry, :api_token)
  end
end
