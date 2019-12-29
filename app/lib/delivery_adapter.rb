class DeliveryAdapter
  attr_reader :locality, :request_body

  def initialize(locality: nil)
    @locality = locality
  end

  def fetch_localities_list
    raise NotImplementedError
  end

  def fetch_delivery_info
    raise ArgumentError if locality.blank? || locality.class != Locality
  end
end
