# == Schema Information
#
# Table name: countries
#
#  id            :bigint           not null, primary key
#  iso_code      :string           not null
#  language_code :string           not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Country < ApplicationRecord
  has_many :delivery_zones, dependent: :destroy
  has_many :subdivisions, dependent: :destroy
  has_many :localities, through: :subdivisions

  validates :iso_code, presence: true, uniqueness: true
  validates :language_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  def default_subdivision
    subdivisions.find_by(name: Subdivision::DEFAULT_NAME)
  end
end
