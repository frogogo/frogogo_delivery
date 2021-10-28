class RU::FivePostService
  FIVE_POST_NAME = 'FivePost'

  def initialize
    @api = RU::FivePostAPI.new
    @provider = Provider.find_by(name: FIVE_POST_NAME)
  end

  def fetch_delivery_methods(locality)
    DeliveryMethod.create_or_find_by!(
      method: :pickup,
      deliverable: locality
    )
  end

  def assign_delivery_points_to_delivery_method(delivery_method)
    five_post_points = DeliveryPoint
      .joins(:provider)
      .where(providers: { name: 'FivePost' })
      .where('lower(locality_name) = ?', delivery_method.deliverable.name.downcase)

    delivery_method.delivery_points << five_post_points
  end

  def fetch_pickup_points
    pickup_points = @api.pickup_point_list

    delivery_points_attributes = pickup_points.map { |params| RU::FivePostPoint.new(params) }
      .map { |five_post| five_post.to_attributes(@provider.id) }

    return if delivery_points_attributes.blank?

    DeliveryPoint.insert_all(delivery_points_attributes)
  end
end
