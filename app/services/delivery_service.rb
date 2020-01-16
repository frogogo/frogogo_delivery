class DeliveryService
  SYMBOLS_TO_DELETE = ','

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
    return true if I18n.t(:excluded_deliverables, scope: [:constants, provider.code.to_sym]).include?(subdivision.name)

    locality.delivery_methods.joins(:provider).courier.where.not(inactive: true, providers: { name: provider.name }).any?
  end

  def format_string(string)
    return if string.blank?

    string.strip.delete_prefix(SYMBOLS_TO_DELETE).delete_suffix(SYMBOLS_TO_DELETE)
  end
end
