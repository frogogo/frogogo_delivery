class DeliveryMethodsController < ApplicationController
  def index
    if I18n.t("excluded_deliverables.all.#{search_params[:subdivision]}").include?(search_params[:locality])
      return head :not_found
    end

    @delivery_methods = DeliveryMethodsResolver.new(search_params).resolve
    return head :not_found if @delivery_methods.blank?

    @delivery_points = DeliveryPoint
      .active
      .where(delivery_method: @delivery_methods)
      .uniq { |delivery_point| [delivery_point.latitude, delivery_point.longitude] }

    @delivery_zone = @delivery_methods.first.deliverable.delivery_zone
    return head :not_found if @delivery_zone.blank?
  end

  private

  def search_params
    params.permit(:locality, :subdivision)
  end
end
