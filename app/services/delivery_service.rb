class DeliveryService
  attr_reader :locality, :request_body

  def initialize(locality: nil)
    @locality = locality
  end

  def fetch_dictionary
    raise NotImplementedError
  end

  def fetch_delivery_info
    raise ArgumentError if locality.blank?
  end
end
