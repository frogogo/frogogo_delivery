# == Schema Information
#
# Table name: subdivisions
#
#  id         :bigint           not null, primary key
#  iso_code   :string           not null
#  local_code :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :bigint
#
# Indexes
#
#  index_subdivisions_on_country_id                 (country_id)
#  index_subdivisions_on_iso_code                   (iso_code) UNIQUE
#  index_subdivisions_on_local_code_and_country_id  (local_code,country_id) UNIQUE
#  index_subdivisions_on_name_and_country_id        (name,country_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#

class Subdivision < ApplicationRecord
  belongs_to :country

  validates :iso_code, presence: true
  validates :local_code, presence: true
  validates :name, presence: true
end
