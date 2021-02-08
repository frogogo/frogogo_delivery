class DeliveryZonesController < ApplicationController
  def show
    @delivery_methods = DeliveryMethodsResolver.new(search_params).resolve
    return head :not_found if @delivery_methods.blank?

    @delivery_methods = @delivery_methods.active

    @delivery_zone = @delivery_methods.first.deliverable.delivery_zone
    return head :not_found if @delivery_zone.blank?
  end

  private

  def search_params
    params.permit(:locality, :subdivision, :longitude, :latitude, :locality_uid)
  end
end
