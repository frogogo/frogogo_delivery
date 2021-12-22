class RU::FivePostPoint
  CHECKOUT = 'TOBACCO'
  PARCEL_TERMINAL = 'POSTAMAT'

  def initialize(params, provider)
    @full_address = params['fullAddress']
    @latitude = params['address']['lat']
    @longitude = params['address']['lng']
    @postal_code = params['address']['zipCode']
    @working_hours = params['workHours']
    @date_interval = params['deliverySL']&.first
    @short_address = params['shortAddress']
    @fias_code = params['localityFiasCode']
    @point_id = params['id']
    @type = params['type']
    @payment_methods = payment_methods(params)
    @provider = provider
  end

  def to_attributes
    {
      address: @full_address,
      code: @postal_code,
      created_at: Time.current,
      date_interval: date_interval,
      latitude: @latitude,
      longitude: @longitude,
      name: name,
      payment_methods: @payment_methods,
      provider_id: @provider.id,
      updated_at: Time.current,
      working_hours: working_hours,
      delivery_method_id: delivery_method.id
    }
  end

  def payment_methods(hash_params)
    methods = []
    methods << 'cash' if hash_params['cashAllowed'] == true
    methods << 'card' if hash_params['cardAllowed'] == true

    methods
  end

  def name
    return "Касса супермаркета «Пятёрочка», #{@short_address}" if @type == CHECKOUT

    "Постамат в супермаркете «Пятёрочка», #{@short_address}"
  end

  def working_hours
    "C #{@working_hours.first['opensAt']} до #{@working_hours.first['closesAt']}"
  end

  def date_interval
    return nil if @date_interval.blank?

    @date_interval['sl']
  end

  def delivery_method
    DeliveryMethod.create_or_find_by(
      method: :pickup,
      deliverable: locality
    )
  end

  def locality
    locality =
      Locality.find_by('data @> ?', { settlement_fias_id: @fias_code }.to_json) ||
      Locality.find_by('data @> ?', { city_fias_id: @fias_code }.to_json)

    return locality unless locality.blank?
    return nil if dadata_suggestion.nil?

    locality = Locality.find_by(locality_uid: dadata_suggestion.kladr_id)
    locality = Locality.create!(dadata_suggestion.locality_attributes) if locality.blank?
    locality = locality.parent_locality if locality.parent_locality.present?

    locality
  end

  def dadata_suggestion
    dadata = DaDataService.instance
    dadata_suggestion ||= dadata.suggestion_from_locality_uid(@fias_code)
    DaDataSuggestion.new(dadata_suggestion) if dadata_suggestion.present?
  end
end
