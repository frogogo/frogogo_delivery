class RU::ShoplogisticsAdapter < DeliveryAdapter
  BASE_URI = 'https://client-shop-logistics.ru/index.php?route=deliveries/api'
  HEADERS_PARAMS = { 'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8' }
  LOCALITIES_LIST_REQUEST_BODY = {
    function: 'get_dictionary',
    dictionary_type: 'city'
  }
  DELIVERY_INFO_REQUEST_BODY = {
    function: 'get_deliveries_tarifs',
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

  def delivery_info
    @request_body = DELIVERY_INFO_REQUEST_BODY.merge(to_city: locality.name)
    @response = request_data

    parsed_response
  end

  def localities_list
    @request_body = LOCALITIES_LIST_REQUEST_BODY
    @response = request_data

    parsed_response
  end

  private

  attr_reader :response

  def api_token
    Rails.application.credentials.dig(:ru, :shoplogistics, :api_token)
  end

  def encoded_request_body
    URI.escape(Base64.strict_encode64(xml_body))
  end

  def parsed_response
    Hash.from_xml(response.parsed_response)
  end

  def request_data
    HTTParty.post(
      BASE_URI,
      headers: HEADERS_PARAMS,
      body: { xml: encoded_request_body }
    )
  end

  def xml_body
    request_body.merge(api_id: api_token).to_xml(root: :request, dasherize: false, skip_instruct: true)
  end
end
