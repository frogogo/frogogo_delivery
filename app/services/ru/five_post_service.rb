class RU::FivePostService < DeliveryService
  FIVE_POST_NAME = 'FivePost'

  def initialize(locality, delivery_method: nil)
    super

    @delivery_service = RU::FivePostAdapter.new(locality)
    @provider = Provider.find_by(name: FIVE_POST_NAME)
    @subdivision_name = locality.subdivision.name
    @delivery_method = delivery_method
  end

  def fetch_delivery_methods
    DeliveryMethod.create_or_find_by!(
      method: :pickup,
      deliverable: locality
    )
  end

  def fetch_pickup_points(delivery_method)
    return unless super

    @response = delivery_service.pickup_ponit_list

    delivery_points_attributes = response.map { |params| RU::FivePostPoint.new(params) }
      .select { |five_post| five_post.canonical_city_name == locality.name.downcase }
      .select { |five_post| five_post.canonical_region_name == @subdivision_name.downcase }
      .map { |five_post| five_post.to_attributes(@provider.id) }

    return if delivery_points_attributes.blank?

    delivery_method.delivery_points
      .insert_all(delivery_points_attributes)
  end
end
