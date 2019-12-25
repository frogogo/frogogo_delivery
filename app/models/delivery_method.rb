# == Schema Information
#
# Table name: delivery_methods
#
#  id               :bigint           not null, primary key
#  date_interval    :string
#  deliverable_type :string
#  inactive         :boolean          default(FALSE)
#  method           :integer          default("post")
#  time_intervals   :string           is an Array
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deliverable_id   :bigint
#  provider_id      :bigint
#
# Indexes
#
#  index_delivery_methods_on_deliverable_type_and_deliverable_id  (deliverable_type,deliverable_id)
#  index_delivery_methods_on_provider_id                          (provider_id)
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id)
#

class DeliveryMethod < ApplicationRecord
  scope :active, -> { where(inactive: false) }

  enum method: { post: 0, courier: 1, pickup: 2 }

  belongs_to :deliverable, polymorphic: true
  belongs_to :provider

  validates :name, presence: true
end
