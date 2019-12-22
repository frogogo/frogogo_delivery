class DeliveryService
  attr_reader :locality, :request_body

  def initialize(locality: nil)
    raise ArgumentError if locality.blank?

    @locality = locality
  end

  def fetch_delivery_info
    raise NotImplementedError
  end
end
