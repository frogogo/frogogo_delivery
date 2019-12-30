class RU::ShoplogisticsService < DeliveryService
  def initialize(locality)
    super

    @delivery_service = RU::ShoplogisticsAdapter.new(locality)
  end

  def fetch_delivery_info
    @response = delivery_service.delivery_info

    parsed_response
  end

  private

  def parsed_response
    Hash.from_xml(response.parsed_response)
  end
end
