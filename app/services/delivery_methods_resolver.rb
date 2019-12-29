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

    return result if result.present?

    create_locality_and_subdivision
    # RU::BoxberryService.new(locality).delivery_info
  end

  private

  attr_reader :locality_name, :subdivision, :subdivision_name

  def create_locality_and_subdivision
    @subdivision = Subdivision.create!(name: subdivision_name, country: country)
    @locality = Locality.create!(name: locality_name, subdivision: subdivision)
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
