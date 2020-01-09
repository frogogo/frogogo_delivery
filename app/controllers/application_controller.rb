class ApplicationController < ActionController::API
  include ActionController::Caching

  before_action :authenticate
  before_action :set_locale!

  private

  def authenticate
    # TODO: add authentication
    true
  end

  def set_locale!
    raise ArgumentError if params[:locale].blank?

    I18n.locale = params[:locale].to_sym
  end
end
