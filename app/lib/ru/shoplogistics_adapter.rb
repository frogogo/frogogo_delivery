class RU::ShoplogisticsAdapter < DeliveryAdapter
  BASE_URI = 'https://client-shop-logistics.ru/index.php?route=deliveries/api'
  HEADERS_PARAMS = { 'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8' }
  LOCALITIES_LIST_REQUEST_BODY = {
    function: 'get_dictionary',
    api_id: Rails.application.credentials.dig(:ru, :shoplogistics, :api_token),
    dictionary_type: 'city'
  }
  DELIVERY_INFO_REQUEST_BODY = {
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

  def localities_list
    @request_body = LOCALITIES_LIST_REQUEST_BODY

    request_data
  end

  def delivery_info
    super

    @request_body = DELIVERY_INFO_REQUEST_BODY.merge(to_city: locality.name)

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
