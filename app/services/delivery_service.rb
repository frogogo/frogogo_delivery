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
    return false unless I18n.locale == :ru

    case provider.name
    when 'Boxberry'
      RU::ShopLogisticsService::SUBDIVISION_LIST.include?(subdivision.name)
    when 'ShopLogistics'
      !RU::ShopLogisticsService::SUBDIVISION_LIST.include?(subdivision.name) &&
        locality.delivery_methods.joins(:provider).courier.where(providers: { name: 'Boxberry' }).any?
    end
  end
end
