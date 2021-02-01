class DeliveryMethodsResolver
  attr_reader :excluded_deliverable, :locality, :result

  def initialize(search_params)
    @locality_name = I18n.t(
      search_params[:locality], scope: %i[aliases], default: nil
    ) || search_params[:locality]
    @subdivision_name = search_params[:subdivision]
    @latitude = search_params[:latitude]
    @longitude = search_params[:longitude]
    @locality_uid = search_params[:locality_uid]
  end

  def resolve
    return if locality_name.blank? || subdivision_name.blank?

    @result = search_by_params

    # TODO: refactor
    if result.present? && !result.delivery_zone.inactive?
      delivery_methods = result.delivery_methods.order(updated_at: :asc)

      if delivery_methods.last.present? && delivery_methods.last.updated_at > 1.week.ago
        result.delivery_methods
      else
        fetch_new_data
      end
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

  # TODO: посмотреть, проверить, написать тесты
  def search_by_params
    case I18n.locale
    when :ru
      Locality.joins(:subdivision).find_by(
        name: locality_name,
        latitude: latitude,
        longitude: longitude,
        locality_uid: locality_uid,
        subdivisions: { name: subdivision_name }
      )
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
