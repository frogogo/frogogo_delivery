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
#  provider_id      :bigint           not null
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
  include Activatable
  include Dateable

  enum method: { post: 0, courier: 1, pickup: 2 }

  belongs_to :deliverable, polymorphic: true
  belongs_to :provider

  has_many :delivery_points, dependent: :destroy

  after_update_commit :update_delivery_points, if: :saved_change_to_inactive?

  def courier_delivery_dates
    return unless courier?

    ((Date.current)..(Date.current + 7.days)).map do |date|
      [calculate_esimate_delivery_date(date), time_intervals]
    end.to_h
  end

  def time_intervals
    return unless courier?

    self[:time_intervals] || constant_time_intervals
  end

  private

  def update_delivery_points
    delivery_points.update_all(inactive: inactive)
    delivery_points.touch_all
  end
end
