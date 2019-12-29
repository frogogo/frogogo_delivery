# == Schema Information
#
# Table name: delivery_zones
#
#  id                           :bigint           not null, primary key
#  fee                          :float            not null
#  free_delivery_gold_threshold :float            not null
#  free_delivery_threshold      :float            not null
#  zone                         :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  country_id                   :bigint           not null
#
# Indexes
#
#  index_delivery_zones_on_country_id           (country_id)
#  index_delivery_zones_on_country_id_and_zone  (country_id,zone) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#

class DeliveryZone < ApplicationRecord
  belongs_to :country

  enum zone: {
    default: 0, "1": 1, "2": 2, "3": 3, "4": 4,
    "5": 5, "6": 6, "7": 7, "8": 8, "9": 9
  }

  validates :fee, presence: true
  validates :free_delivery_gold_threshold, presence: true
  validates :free_delivery_threshold, presence: true
end
