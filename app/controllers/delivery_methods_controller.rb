class DeliveryMethodsController < ApplicationController
  def index
    @delivery_methods = DeliveryMethodsResolver.new(search_params).resolve
    return head :not_found if @delivery_methods.blank?

    @delivery_methods = @delivery_methods
      .joins(:provider)
      .merge(Provider.active)
      .active

    @delivery_zone = @delivery_methods.first.deliverable.delivery_zone
    return head :not_found if @delivery_zone.blank?
  end

  private

  def search_params
    params.permit(
      :locality, :subdivision, :longitude, :latitude, :kladrId
    ).transform_keys(&:underscore)
  end
end
