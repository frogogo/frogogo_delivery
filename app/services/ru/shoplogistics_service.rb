class RU::ShoplogisticsService
  BASE_URI = 'https://client-shop-logistics.ru/index.php?route=deliveries/api'
  HEADERS_PARAMS = { 'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8' }
  FETCH_DELIVERY_INFO_REQUEST_BODY = {
    api_id: Rails.application.credentials.dig(:ru, :shoplogistics, :api_token),
    function: 'get_deliveries_tarifs',
    from_city: 'Москва',
    num: '1',
    weight: '1',
    order_height: '',
    order_length: '',
    order_width: '',
    order_price: '1000.00',
    ocen_price: '1000.00'
  }

  attr_reader :locality, :request_body

  def initialize(locality: nil)
    @locality = locality
  end

  def fetch_delivery_info
    return if locality.blank?

    @request_body = FETCH_DELIVERY_INFO_REQUEST_BODY.merge(to_city: locality)

    request_data
  end

  private

  def request_data
    HTTParty.post(
      BASE_URI,
      headers: HEADERS_PARAMS,
      body: { xml: encoded_request_body },
      debug_output: $stdout
    )
  end

  def encoded_request_body
    CGI.escape(Base64.strict_encode64(request_body.to_xml(root: :request, skip_instruct: true)))
  end
end
