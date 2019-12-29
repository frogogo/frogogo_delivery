class DeliveryAdapter
  attr_reader :locality, :request_body

  def initialize(locality: nil)
    @locality = locality
  end

  def localities_list
    raise NotImplementedError
  end

  def delivery_info
    raise ArgumentError if locality.blank? || locality.class != Locality
  end
end
