class DeliveryAdapter
  attr_reader :locality, :request_body

  def initialize(locality: nil)
    @locality = locality
  end

  def validate_locality!
    raise ArgumentError if locality.blank? || locality.class != Locality
  end
end
