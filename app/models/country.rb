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
# Indexes
#
#  index_countries_on_iso_code       (iso_code) UNIQUE
#  index_countries_on_language_code  (language_code) UNIQUE
#  index_countries_on_name           (name) UNIQUE
#

class Country < ApplicationRecord
  has_many :subdivisions, dependent: :destroy

  validates :iso_code, presence: true, uniqueness: true
  validates :language_code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
