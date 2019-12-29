class DeliveryAdapter
  attr_reader :locality, :request_body

  def initialize(locality)
    raise ArgumentError if locality.class != Locality

    @locality = locality
  end
end
