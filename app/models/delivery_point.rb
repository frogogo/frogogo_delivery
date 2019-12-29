# == Schema Information
#
# Table name: delivery_points
#
#  id                 :bigint           not null, primary key
#  address            :string           not null
#  code               :string
#  directions         :string
#  latitude           :string
#  longitude          :string
#  phone_number       :string
#  working_hours      :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  delivery_method_id :bigint
#
# Indexes
#
#  index_delivery_points_on_address_and_delivery_method_id  (address,delivery_method_id) UNIQUE
#  index_delivery_points_on_delivery_method_id              (delivery_method_id)
#
# Foreign Keys
#
#  fk_rails_...  (delivery_method_id => delivery_methods.id)
#

class DeliveryPoint < ApplicationRecord
  belongs_to :delivery_method

  validates :address, presence: true
end
