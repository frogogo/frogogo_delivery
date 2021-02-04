class DeliveryMethodsController < ApplicationController
  before_action :set_subdivision
  before_action :set_locality

  def index
    @delivery_methods = DeliveryMethodsResolver.new(@locality).resolve
    return head :not_found if @delivery_methods.blank?

    @delivery_methods = @delivery_methods.active

    @delivery_zone = @delivery_methods.first.deliverable.delivery_zone
    return head :not_found if @delivery_zone.blank?
  end

  private

  def set_subdivision
    @subdivision = Subdivision.find_or_create_by!(name: params[:subdivision])
  end

  def set_locality
    if params[:locality_uid].present?
      @locality = @subdivision.localities.find_by(locality_uid: params[:locality_uid])
      @locality = @subdivision.localities.create!(new_locality_params) if @locality.blank?
    else
      dadata_suggestion = DaDataService.instance.suggestion_from_locality_and_subdivision(
        params[:locality],
        params[:subdivision]
      )
      @locality = @subdivision.localities.find_by(locality_uid: dadata_suggestion.kladr_id)
      if @locality.blank?
        @locality = @subdivision.localities.create!(
          dadata_suggestion.locality_attributes.merge(name: params[:locality])
        )
      end
    end
  end

  def new_locality_params
    params
      .permit(:longitude, :latitude, :locality_uid)
      .merge(name: params[:locality])
  end
end
