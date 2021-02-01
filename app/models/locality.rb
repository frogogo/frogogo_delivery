# == Schema Information
#
# Table name: localities
#
#  id               :bigint           not null, primary key
#  latitude         :float
#  local_code       :string
#  locality_uid     :string
#  longitude        :float
#  name             :string           not null
#  postal_code      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  delivery_zone_id :bigint
#  subdivision_id   :bigint           not null
#

class Locality < ApplicationRecord
  belongs_to :delivery_zone, optional: true
  belongs_to :subdivision

  has_many :delivery_methods, as: :deliverable, dependent: :destroy
  has_many :providers, through: :delivery_methods, dependent: :nullify

  validates :name, presence: true

  before_create :set_delivery_zone, if: -> { delivery_zone.blank? }

  def self.find_or_create_by_params(params)
    locality = Locality.find_by(locality_uid: params[:locality_uid])
    locality = Locality.create!(params) if locality.blank?
    locality
  end

  def set_delivery_zone
    self.delivery_zone = subdivision.delivery_zone
  end
end
