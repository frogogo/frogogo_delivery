class DeliveryMethodsResolver
  attr_reader :excluded_deliverable

  def initialize(locality)
    @locality = locality
  end

  def resolve
    return if @locality.delivery_zone.blank?
    return if @locality.delivery_zone.inactive?

    delivery_methods = @locality.delivery_methods

    # TODO: refactor
    if delivery_methods.any? && delivery_methods.last.updated_at > 1.week.ago
      @locality.delivery_methods
    else
      fetch_new_data
    end
  end

  private

  attr_reader :locality_name, :subdivision, :subdivision_name, :latitude, :longitude, :locality_uid

  def create_locality_and_subdivision
    @subdivision = Subdivision.create_or_find_by!(
      name: subdivision_name,
      delivery_zone: region_delivery_zone(subdivision_name)
    )
    @locality = Locality.create_or_find_by!(
      name: locality_name,
      subdivision: subdivision,
      latitude: latitude,
      longitude: longitude,
      locality_uid: locality_uid,
      delivery_zone: city_delivery_zone(subdivision_name, locality_name) ||
        subdivision.delivery_zone
    )
  end

  def fetch_new_data
    case I18n.locale
    when :ru
      create_locality_and_subdivision

      return if locality.delivery_zone.inactive? || subdivision.delivery_zone.inactive?

      RU::BoxberryService.new(locality).fetch_delivery_methods
      RU::RussianPostService.new(locality).fetch_delivery_method

      locality.delivery_methods.active
    end
  end

  def region_delivery_zone(subdivision_name)
    DeliveryZone.find_by(
      zone: I18n.t(
        subdivision_name, scope: %i[delivery_zones regions], default: {}
      )[:delivery_zone]
    )
  end

  def city_delivery_zone(subdivision_name, locality_name)
    locality_zone = I18n.t(
      subdivision_name, scope: %i[delivery_zones cities region], default: {}
    )[locality_name.to_sym]

    return if locality_zone.nil?

    DeliveryZone.find_by(
      zone: locality_zone[:delivery_zone]
    )
  end
end
