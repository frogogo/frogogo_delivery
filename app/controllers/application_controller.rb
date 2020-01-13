class ApplicationController < ActionController::API
  include ActionController::Caching

  before_action :authenticate
  before_action :set_locale!

  around_action :switch_locale

  private

  attr_reader :locale

  def authenticate
    # TODO: add authentication
    true
  end

  def set_locale!
    raise ArgumentError if params[:locale].blank?

    @locale = params[:locale].to_sym
  end

  def switch_locale(&action)
    I18n.with_locale(locale, &action)
  end
end
