class RU::BoxberryService < DeliveryService
  def delivery_info
    @fetched_response = RU::BoxberryAdapter.new(locality: locality).fetch_delivery_info

    parsed_response
  end

  def localities_list
    @fetched_response = RU::BoxberryAdapter.new.fetch_localities_list

    parsed_response
  end

  private

  def parsed_response
    fetched_response.parsed_response
  end
end
