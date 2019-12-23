class DeliveryService
  attr_reader :locality, :fetched_response

  def initialize(locality: nil)
    @locality = locality
  end

  def delivery_info
    raise NotImplementedError
  end

  def localities_list
    raise NotImplementedError
  end
end
