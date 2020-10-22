class DeliveryService
  def initialize(locality)
    raise ArgumentError if locality.class != Locality

    @locality = locality
    @subdivision = @locality.subdivision
  end

  def fetch_delivery_info
    !provider.inactive?
  end

  def fetch_localities_list
    !provider.inactive?
  end

  private

  attr_reader :delivery_service, :locality, :provider, :response, :subdivision

  def localities_list
    return provider.localities_list if provider.localities_list.present?

    provider.localities_list = fetch_localities_list
    provider.save

    provider.localities_list
  end

  def courier_delivery_method_inactive?
    if I18n.t('excluded_deliverables.boxberry.courier.localities').include?(locality.name)
      return true
    end

    locality.delivery_methods
      .joins(:provider)
      .courier
      .where.not(inactive: true, providers: { name: provider.name })
      .any?
  end
end
