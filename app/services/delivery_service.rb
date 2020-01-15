class DeliveryService
  def initialize(locality)
    raise ArgumentError if locality.class != Locality

    @locality = locality
  end

  def fetch_delivery_info
    !provider.inactive?
  end

  def fetch_localities_list
    !provider.inactive?
  end

  private

  attr_reader :delivery_service, :locality, :provider, :response

  def localities_list
    return provider.localities_list if provider.localities_list.present?

    provider.localities_list = fetch_localities_list
    provider.save

    provider.localities_list
  end
end
