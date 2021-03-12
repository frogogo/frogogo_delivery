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
    return nil if dadata_suggestion.nil?

    locality_uid = params[:locality_uid] || dadata_suggestion.kladr_id

    @locality = Locality.find_by(locality_uid: locality_uid)
    @locality = Locality.create!(dadata_suggestion.locality_attributes) if @locality.blank?
    @locality = @locality.parent_locality if @locality.parent_locality.present?
  end

  def dadata_suggestion
    dadata = DaDataService.instance

    @dadata_suggestion ||= if request_version >= 2
                             dadata.suggestion_from_locality_uid(params[:locality_uid])
                           else
                             dadata.suggestion_from_locality_and_subdivision(
                               params[:locality],
                               params[:subdivision]
                             )
                           end

    DaDataSuggestion.new(@dadata_suggestion) if @dadata_suggestion.present?
  end
end
