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
#

class DeliveryMethod < ApplicationRecord
  include Activatable
  include Dateable

  enum method: { post: 0, courier: 1, pickup: 2 }

  belongs_to :deliverable, polymorphic: true

  has_many :delivery_points, dependent: :destroy

  after_save :update_locality_timestamp

  def courier_delivery_dates
    return unless courier?

    ((Date.current)..(Date.current + 7.days)).map do |date|
      estimated_delivery_date = calculate_estimated_delivery_date(date)
      [estimated_delivery_date, time_intervals(date: estimated_delivery_date)]
    end.to_h
  end

  def time_intervals(date: calculate_estimated_delivery_date(Date.current))
    return unless courier?

    self[:time_intervals] || default_time_intervals(date)
  end

  private

  def update_locality_timestamp
    deliverable.touch(:delivery_methods_updated_at)
  end
end
