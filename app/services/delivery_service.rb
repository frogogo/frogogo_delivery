class DeliveryService
  attr_reader :locality, :response

  def initialize(locality: nil)
    @locality = locality
  end

  def fetch_delivery_info
    raise NotImplementedError
  end

  def fetch_localities_list
    raise NotImplementedError
  end
end
