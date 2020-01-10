module Activatable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(inactive: false) }
  end
end
