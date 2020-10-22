class DeliveryMethodsResolver
  attr_reader :country, :excluded_deliverable, :locality, :result

  def initialize(search_params)
    @country = Country.find_by(language_code: I18n.locale)
    @locality_name = I18n.t(search_params[:locality], scope: %i[aliases], default: nil) || search_params[:locality]
    @subdivision_name = search_params[:subdivision]
  end

  def resolve
    return if country.blank? || locality_name.blank? || subdivision_name.blank?

    @result = search_by_params

    # TODO: refactor
    if result.present?
      return if result.delivery_zone.inactive?

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

  attr_reader :locality_name, :subdivision, :subdivision_name

  def create_locality_and_subdivision
    @subdivision = Subdivision.create_or_find_by!(
      name: subdivision_name,
      country: country,
      delivery_zone: delivery_zone(subdivision_name, :regions)
    )
    @locality = Locality.create_or_find_by!(
      name: locality_name,
      subdivision: subdivision,
      delivery_zone: delivery_zone(locality_name, :cities) || subdivision.delivery_zone
    )
  end

  def fetch_new_data
    case country.language_code.to_sym
    when :ru
      create_locality_and_subdivision

      return if locality.delivery_zone.inactive? || subdivision.delivery_zone.inactive?

      RU::BoxberryService.new(locality).fetch_delivery_info
      RU::RussianPostService.new(locality).fetch_delivery_info

      locality.delivery_methods.active
    end
  end

  def search_by_params
    case country.language_code.to_sym
    when :ru
      Locality.joins(:subdivision).find_by(
        name: locality_name,
        subdivisions: { name: subdivision_name, country: country }
      )
    when :tr
      country.default_subdivision
    end
  end

  def delivery_zone(name, zone)
    DeliveryZone.find_by(
      zone: I18n.t(name, scope: [:delivery_zones, zone], default: {})[:delivery_zone]
    )
  end
end
