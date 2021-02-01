# == Schema Information
#
# Table name: delivery_zones
#
#  id                           :bigint           not null, primary key
#  courier_fee                  :float            default(0.0), not null
#  free_delivery_gold_threshold :float            not null
#  free_delivery_threshold      :float            not null
#  inactive                     :boolean          default(FALSE)
#  pickup_fee                   :float            default(0.0), not null
#  post_fee                     :float            default(0.0), not null
#  zone                         :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

class DeliveryZone < ApplicationRecord
  enum zone: {
    default: 0, "1": 1, "2": 2, "3": 3, "4": 4,
    "5": 5, "6": 6, "7": 7, "8": 8, "9": 9
  }

  validates :courier_fee, presence: true
  validates :pickup_fee, presence: true
  validates :post_fee, presence: true
  validates :free_delivery_gold_threshold, presence: true
  validates :free_delivery_threshold, presence: true

  def delivery_fee
    courier_fee
  end

  def fee
    courier_fee
  end
end
