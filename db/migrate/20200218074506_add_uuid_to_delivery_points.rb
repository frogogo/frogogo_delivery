class AddUuidToDeliveryPoints < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'
    add_column :delivery_points, :uuid, :uuid, default: 'gen_random_uuid()', null: false
  end
end
