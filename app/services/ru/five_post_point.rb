class RU::FivePostPoint
  CHECKOUT = 'TOBACCO'
  PARCEL_TERMINAL = 'POSTAMAT'

  def initialize(params)
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
    # Казань г —> Казань
    @city = params['address']['city'].split.first
    @payment_methods = payment_methods(params)
  end

  def to_attributes(provider_id)
    {
      address: @full_address,
      code: @postal_code,
      created_at: Time.current,
      date_interval: date_interval,
      latitude: @latitude,
      longitude: @longitude,
      name: name,
      payment_methods: @payment_methods,
      provider_id: provider_id,
      updated_at: Time.current,
      working_hours: working_hours,
      locality_name: @city
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

  def locality_fias_code
    @fias_code
  end

  def date_interval
    return nil if @date_interval.blank?

    @date_interval['sl']
  end
end
