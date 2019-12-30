class DeliveryService
  attr_reader :delivery_service, :locality, :response

  def initialize(locality)
    raise ArgumentError if locality.class != Locality

    @locality = locality
  end

  def fetch_delivery_info
    raise NotImplementedError
  end

  private

  def localities_list
    return provider.localities_list if provider.localities_list.present?

    provider.localities_list = delivery_service.localities_list
    provider.save

    provider.localities_list
  end
end
