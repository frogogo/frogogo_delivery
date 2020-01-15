class DeliveryMethodsController < ApplicationController
  def index
    @delivery_methods = DeliveryMethodsResolver.new(search_params).resolve
    return head :not_found if @delivery_methods.blank?

    @delivery_methods = DeliveryMethodsFilter.new(@delivery_methods).filter
    @delivery_points = DeliveryPoint.active.where(delivery_method: @delivery_methods)
    @delivery_zone = @delivery_methods.first.deliverable.delivery_zone
    return head :not_found if @delivery_zone.blank?
  end

  private

  def search_params
    params.permit(:locality, :subdivision)
  end
end
