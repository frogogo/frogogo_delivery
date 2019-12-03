class AddZoneToDeliveryZones < ActiveRecord::Migration[6.0]
  def change
    add_column :delivery_zones, :zone, :integer
    change_column_null :delivery_zones, :zone, false
    add_index :delivery_zones, [:country_id, :zone], unique: true

    remove_column :delivery_zones, :default
  end
end
