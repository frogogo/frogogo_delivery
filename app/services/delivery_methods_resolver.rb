class DeliveryMethodsResolver
  TURKEY_POST_NAME = 'Turkey Post'

  attr_reader :country, :locality, :result

  def initialize(search_params)
    @country = Country.find_by(language_code: search_params[:locale])
    @locality_name = search_params[:locality]
    @subdivision_name = search_params[:subdivision]
  end

  def resolve
    return if country.blank?

    @result = search_by_params
    return result.delivery_methods if result.present?

    fetch_new_data
  end

  private

  attr_reader :locality_name, :subdivision, :subdivision_name

  def create_locality_and_subdivision
    @subdivision = Subdivision.find_or_create_by!(
      name: subdivision_name, country: country, delivery_zone: delivery_zone(subdivision_name, :regions)
    )
    @locality = Locality.find_or_create_by!(
      name: locality_name, subdivision: subdivision, delivery_zone: delivery_zone(locality_name, :cities)
    )
  end

  def fetch_new_data
    case country.language_code.to_sym
    when :ru
      create_locality_and_subdivision

      RU::BoxberryService.new(locality: locality).fetch_delivery_info
      # shoplogistics, etc...
      locality.delivery_methods
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
      DeliveryMethod.joins(:provider).where(providers: { name: TURKEY_POST_NAME }).limit(1)
    end
  end

  def delivery_zone(name, zone)
    DeliveryZone.find_by(
      zone: I18n.t(name, scope: [:delivery_zones, zone], locale: :ru, default: {})[:delivery_zone]
    )
  end
end
