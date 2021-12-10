# == Schema Information
#
# Table name: subdivisions
#
#  id               :bigint           not null, primary key
#  iso_code         :string
#  name             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  delivery_zone_id :bigint
#

class Subdivision < ApplicationRecord
  DEFAULT_NAME = 'Default'

  belongs_to :delivery_zone, optional: true

  has_many :delivery_methods, as: :deliverable, dependent: :destroy
  has_many :localities, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  before_create :set_delivery_zone

  private

  def set_delivery_zone
    self.delivery_zone = DeliveryZone.find_by(
      zone: I18n.t(
        name, scope: %i[delivery_zones regions], default: {}
      )[:delivery_zone]
    )
  end
end
