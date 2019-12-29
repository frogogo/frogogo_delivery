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

    search_by_params || fetch_new_data
  end

  private

  attr_reader :locality_name, :subdivision, :subdivision_name

  def create_locality_and_subdivision
    @subdivision = Subdivision.create!(name: subdivision_name, country: country)
    @locality = Locality.create!(name: locality_name, subdivision: subdivision)
  end

  def fetch_new_data
    case country.language_code.to_sym
    when :ru
      create_locality_and_subdivision

      RU::BoxberryService.new(locality).fetch_delivery_info
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
      )&.delivery_methods
    when :tr
      DeliveryMethod.joins(:provider).where(providers: { name: TURKEY_POST_NAME }).limit(1)
    end
  end
end
