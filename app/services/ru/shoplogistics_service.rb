class RU::ShoplogisticsService < DeliveryService
  def fetch_delivery_info
    @response = RU::ShoplogisticsAdapter.new(locality: locality).delivery_info

    parsed_response
  end

  def fetch_localities_list
    @response = RU::ShoplogisticsAdapter.new.localities_list

    parsed_response
  end

  private

  def parsed_response
    Hash.from_xml(response.parsed_response)
  end
end
