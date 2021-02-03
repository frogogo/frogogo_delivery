# == Schema Information
#
# Table name: localities
#
#  id                          :bigint           not null, primary key
#  delivery_methods_updated_at :datetime
#  latitude                    :float
#  local_code                  :string
#  locality_uid                :string
#  longitude                   :float
#  name                        :string           not null
#  postal_code                 :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  delivery_zone_id            :bigint
#  subdivision_id              :bigint           not null
#

class Locality < ApplicationRecord
  belongs_to :delivery_zone, optional: true
  belongs_to :subdivision

  has_many :delivery_methods, as: :deliverable, dependent: :destroy

  validates :name, presence: true

  before_create :set_delivery_zone

  def set_delivery_zone
    # Поиск зоны доставки по городу
    locality_zone = I18n.t(
      subdivision.name,
      scope: %i[delivery_zones cities region],
      default: {}
    )[name.to_sym]

    if locality_zone.present?
      self.delivery_zone = DeliveryZone.find_by(zone: locality_zone[:delivery_zone])
    else
      self.delivery_zone = subdivision.delivery_zone
    end
  end
end
