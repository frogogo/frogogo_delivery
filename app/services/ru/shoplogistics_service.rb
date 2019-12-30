class RU::ShoplogisticsService < DeliveryService
  SHOPLOGISTICS_NAME = 'ShopLogistics'

  def initialize(locality)
    super

    @delivery_service = RU::ShoplogisticsAdapter.new(locality)
    @provider = Provider.find_by(name: SHOPLOGISTICS_NAME)
  end

  def fetch_delivery_info
    @response = delivery_service.delivery_info

    parsed_response
  end

  private

  attr_reader :provider

  def parsed_response
    Hash.from_xml(response.parsed_response)
  end
end
