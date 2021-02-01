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
#  delivery_zone_id :bigint
#

class Subdivision < ApplicationRecord
  DEFAULT_NAME = 'Default'

  belongs_to :delivery_zone, optional: true
  belongs_to :country

  has_many :delivery_methods, as: :deliverable, dependent: :destroy
  has_many :localities, dependent: :destroy

  validates :name, presence: true
end
