# == Schema Information
#
# Table name: subdivisions
#
#  id               :bigint           not null, primary key
#  iso_code         :string
#  local_code       :string
#  name             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  country_id       :bigint           not null
#  delivery_zone_id :bigint
#
# Indexes
#
#  index_subdivisions_on_country_id                 (country_id)
#  index_subdivisions_on_delivery_zone_id           (delivery_zone_id)
#  index_subdivisions_on_iso_code                   (iso_code) UNIQUE
#  index_subdivisions_on_local_code_and_country_id  (local_code,country_id) UNIQUE
#  index_subdivisions_on_name_and_country_id        (name,country_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (delivery_zone_id => delivery_zones.id)
#

class Subdivision < ApplicationRecord
  belongs_to :delivery_zone, optional: true
  belongs_to :country

  has_many :delivery_methods, as: :deliverable, dependent: :destroy
  has_many :localities, dependent: :destroy

  validates :name, presence: true
end
