# == Schema Information
#
# Table name: localities
#
#  id               :bigint           not null, primary key
#  local_code       :string
#  name             :string           not null
#  postal_code      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  delivery_zone_id :bigint
#  subdivision_id   :bigint           not null
#
# Indexes
#
#  index_localities_on_delivery_zone_id               (delivery_zone_id)
#  index_localities_on_local_code_and_subdivision_id  (local_code,subdivision_id) UNIQUE
#  index_localities_on_postal_code                    (postal_code) UNIQUE
#  index_localities_on_subdivision_id                 (subdivision_id)
#
# Foreign Keys
#
#  fk_rails_...  (delivery_zone_id => delivery_zones.id)
#  fk_rails_...  (subdivision_id => subdivisions.id)
#

class Locality < ApplicationRecord
  belongs_to :delivery_zone, optional: true
  belongs_to :subdivision

  has_many :delivery_methods, as: :deliverable, dependent: :destroy
  has_many :providers, through: :delivery_methods, dependent: :nullify

  validates :name, presence: true

  before_create :set_delivery_zone, if: -> { delivery_zone.blank? }

  def set_delivery_zone
    self.delivery_zone = subdivision.delivery_zone
  end
end
