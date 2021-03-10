class DeliveryMethodsController < ApplicationController
  before_action :set_locality

  def index
    @delivery_methods = DeliveryMethodsResolver.new(@locality).resolve
    return head :not_found if @delivery_methods.blank?

    @delivery_methods = @delivery_methods.active

    @delivery_zone = @delivery_methods.first.deliverable.delivery_zone
    return head :not_found if @delivery_zone.blank?

    return if request_version > 1

    @delivery_points = DeliveryPointsResolver
      .new(@delivery_methods.find_by(method: :pickup))
      .resolve

    return head :not_found if @delivery_points.blank?

    @delivery_points = @delivery_points
      .includes(:provider)
      .order(provider_id: :asc, date_interval: :asc)
  end

  private

  def set_locality
    locality_uid = params[:locality_uid] || locality_params.kladr_id

    @locality = Locality.find_by(locality_uid: locality_uid)
    @locality = Locality.create!(locality_params.locality_attributes) if @locality.blank?
    @locality = @locality.parent_locality if @locality.parent_locality.present?
  end

  def locality_params
    @locality_params ||= DaDataSuggestion.new(dadata_suggestion)
  end

  def dadata_suggestion
    dadata = DaDataService.instance

    if params[:locality_uid].present?
      dadata.suggestion_from_locality_uid(params[:locality_uid])
    else
      dadata.suggestion_from_locality_and_subdivision(
        params[:locality],
        params[:subdivision]
      )
    end
  end
end
