# == Schema Information
#
# Table name: delivery_points
#
#  id                 :bigint           not null, primary key
#  address            :string           not null
#  code               :string
#  date_interval      :string
#  directions         :string
#  inactive           :boolean          default(FALSE)
#  latitude           :decimal(10, 6)
#  locality_name      :string
#  longitude          :decimal(10, 6)
#  name               :string
#  payment_methods    :string           default([]), is an Array
#  phone_number       :string
#  uuid               :uuid             not null
#  working_hours      :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  delivery_method_id :bigint
#  provider_id        :bigint           not null
#

class DeliveryPoint < ApplicationRecord
  include Activatable
  include Dateable

  belongs_to :delivery_method, touch: true, optional: true
  belongs_to :provider, touch: true

  validates :address, presence: true
  validates :latitude, :longitude, presence: true
  validates :latitude, uniqueness: { scope: :longitude }

  delegate :courier?, to: :delivery_method
  delegate :deliverable, to: :delivery_method

  scope :ordered, -> { includes(:provider).order(provider_id: :asc, date_interval: :asc) }
  scope :without_five_post, -> { where.not(provider: Provider.find_by(name: 'FivePost')) }
end
