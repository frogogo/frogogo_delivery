class RU::ShoplogisticsService < DeliveryService
  def delivery_info
    @fetched_response = RU::ShoplogisticsAdapter.new(locality: locality).fetch_delivery_info

    parsed_response
  end

  def localities_list
    @fetched_response = RU::ShoplogisticsAdapter.new.fetch_localities_list

    parsed_response
  end

  private

  def parsed_response
    Hash.from_xml(fetched_response.parsed_response)
  end
end
