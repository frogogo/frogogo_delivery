class DaDataSuggestion
  def initialize(data)
    @data = data
  end

  def kladr_id
    @data['kladr_id']
  end

  def locality_attributes
    {
      latitude: @data['geo_lat'],
      locality_uid: kladr_id,
      longitude: @data['geo_lon']
    }
  end
end
