class ApplicationController < ActionController::API
  include ActionController::Caching
  include ActionController::HttpAuthentication::Token::ControllerMethods

  ACCEPT_LANGUAGE_HEADER = 'HTTP_ACCEPT_LANGUAGE'
  LANGUAGE_CODE_REGEXP = /^[a-z]{2}/

  before_action :authenticate!
  before_action :set_locale!

  around_action :switch_locale

  private

  attr_reader :locale

  def authenticate!
    authenticate_with_http_token do |token, _options|
      raise SecurityError if token != Rails.application.credentials.dig(:api_token)
    end
  end

  def set_locale!
    @locale = request.env[ACCEPT_LANGUAGE_HEADER]&.scan(LANGUAGE_CODE_REGEXP)&.first

    raise ArgumentError if locale.blank?
  end

  def switch_locale(&action)
    I18n.with_locale(locale, &action)
  end
end
