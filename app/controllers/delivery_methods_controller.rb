class DeliveryMethodsController < ApplicationController
  def index
    @delivery_methods = DeliveryMethodsResolver.new(search_params).resolve
    return head :not_found if @delivery_methods.blank?

    @delivery_methods = @delivery_methods
      .joins(:provider)
      .merge(Provider.active)
      .active

    @delivery_points = DeliveryPoint
      .joins(:delivery_method)
      .merge(@delivery_methods)
      .active
      .order(provider_id: :asc, date_interval: :asc)
      .uniq { |delivery_point| [delivery_point.latitude, delivery_point.longitude] }

    @delivery_zone = @delivery_methods.first.deliverable.delivery_zone
    return head :not_found if @delivery_zone.blank?
  end

  private

  def search_params
    params.permit(:locality, :subdivision, :longitude, :latitude, :district)
  end
end
