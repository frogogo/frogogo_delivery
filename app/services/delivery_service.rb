class DeliveryService
  attr_reader :delivery_service, :locality, :response

  def initialize(locality)
    raise ArgumentError if locality.class != Locality

    @locality = locality
  end

  def fetch_delivery_info
    raise NotImplementedError
  end
end
