class RU::BoxberryService < DeliveryService
  def fetch_delivery_info
    @response = RU::BoxberryAdapter.new(locality: locality).delivery_info

    parsed_response
  end

  def fetch_localities_list
    @response = RU::BoxberryAdapter.new.localities_list

    parsed_response
  end

  private

  def parsed_response
    response.parsed_response
  end
end
