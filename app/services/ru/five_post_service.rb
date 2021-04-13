class RU::FivePostService < DeliveryService
  FIVE_POST_NAME = 'FivePost'

  def initialize(locality)
    super

    @delivery_service = RU::FivePostAdapter.new
    @provider = Provider.find_by(name: FIVE_POST_NAME)
    @subdivision_name = locality.subdivision.name
    @locality_fias_code = locality.data['city_fias_id']
  end

  def fetch_delivery_methods
    DeliveryMethod.create_or_find_by!(
      method: :pickup,
      deliverable: locality
    )
  end

  def fetch_pickup_points(delivery_method)
    return unless super

    pickup_points = RU::FivePostAdapter.new.pickup_point_list

    delivery_points_attributes = pickup_points.map { |params| RU::FivePostPoint.new(params) }
      .select { |five_post| five_post.locality_fias_code == @locality_fias_code }
      .map { |five_post| five_post.to_attributes(@provider.id) }

    return if delivery_points_attributes.blank?

    delivery_method.delivery_points
      .insert_all(delivery_points_attributes)
  end
end
