# == Schema Information
#
# Table name: providers
#
#  id              :bigint           not null, primary key
#  code            :string
#  inactive        :boolean          default(FALSE)
#  localities_list :jsonb
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_providers_on_name  (name) UNIQUE
#

class Provider < ApplicationRecord
  has_many :delivery_methods, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
