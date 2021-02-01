class DeliveryMethodsController < ApplicationController
  before_action :set_subdivision
  before_action :set_locality

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

  def set_subdivision
    @subdivision = Subdivision.find_or_create_by(name: params[:subdivision])
  end

  def set_locality
    @locality = @subdivision.localities.find_by(locality_uid: params[:locality_uid])
    @locality = @subdivision.localities.create!(new_locality_params) if @locality.blank?
  end

  def search_params
    params.permit(:locality, :subdivision, :longitude, :latitude, :locality_uid)
  end

  def new_locality_params
    params
      .permit(:longitude, :latitude, :locality_uid)
      .merge(name: params[:locality])
  end
end
