class RU::ShoplogisticsService < DeliveryService
  BASE_URI = 'https://client-shop-logistics.ru/index.php?route=deliveries/api'
  HEADERS_PARAMS = { 'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8' }
  FETCH_DICTIONARY_REQUEST_BODY = {
    function: 'get_dictionary',
    api_id: Rails.application.credentials.dig(:ru, :shoplogistics, :api_token),
    dictionary_type: 'city'
  }
  FETCH_DELIVERY_INFO_REQUEST_BODY = {
    function: 'get_deliveries_tarifs',
    api_id: Rails.application.credentials.dig(:ru, :shoplogistics, :api_token),
    from_city: 'Москва',
    to_city: '',
    weight: '1',
    order_length: '',
    order_width: '',
    order_height: '',
    order_price: '1000.00',
    ocen_price: '1000.00',
    num: '1'
  }

  def fetch_dictionary
    @request_body = FETCH_DICTIONARY_REQUEST_BODY

    request_data
  end

  def fetch_delivery_info
    super

    @request_body = FETCH_DELIVERY_INFO_REQUEST_BODY.merge(to_city: locality)

    request_data
  end

  private

  def request_data
    HTTParty.post(
      BASE_URI,
      headers: HEADERS_PARAMS,
      body: { xml: encoded_request_body }
    )
  end

  def encoded_request_body
    URI.escape(Base64.strict_encode64(xml_body))
  end

  def xml_body
    request_body.to_xml(root: :request, dasherize: false, skip_instruct: true)
  end
end
