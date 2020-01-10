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
  include Activatable

  has_many :delivery_methods, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  after_update_commit :update_inactive_field_in_delivery_methods, if: :saved_change_to_inactive?

  private

  def update_inactive_field_in_delivery_methods
    delivery_methods.update_all(inactive: inactive)
    delivery_methods.touch_all
  end
end
