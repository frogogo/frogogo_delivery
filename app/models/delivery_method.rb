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
  scope :active, -> { where(inactive: false) }

  enum method: { post: 0, courier: 1, pickup: 2 }

  belongs_to :deliverable, polymorphic: true
  belongs_to :provider

  has_many :delivery_points, dependent: :destroy

  def courier_delivery_dates
    return unless courier?

    Hash[(estimate_delivery_date..(estimate_delivery_date + 7.days)).to_a.product(time_intervals)]
  end

  def estimate_delivery_date
    return if date_interval.blank?

    # Only for frogogo.ru
    Time.use_zone('Moscow') do
      @estimate_delivery_date = Date.current + date_interval.last.to_i.days
      # +1 day if Time.current > 4pm
      @estimate_delivery_date += 1.day if Time.current > Time.current.middle_of_day + 4.hours
      @estimate_delivery_date = @estimate_delivery_date.next_weekday if @estimate_delivery_date.on_weekday?
    end

    @estimate_delivery_date
  end
end
