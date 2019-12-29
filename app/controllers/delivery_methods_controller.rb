class DeliveryMethodsController < ApplicationController
  def index
    @delivery_methods = DeliveryMethod.search(search_params)
    return head :not_found if @delivery_methods.blank?

    @delivery_points = DeliveryPoint.where(delivery_method: @delivery_methods)
    @delivery_zone = @delivery_methods.first.deliverable.delivery_zone
    return head :not_found if @delivery_zone.blank?
  end

  private

  def search_params
    params.permit(:locale, :locality, :subdivision)
  end
end
