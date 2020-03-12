class UpdateFieldsInDeliveryZones < ActiveRecord::Migration[6.0]
  def change
    rename_column :delivery_zones, :fee, :courier_fee
    change_column_default :delivery_zones, :courier_fee, 0

    add_column :delivery_zones, :pickup_fee, :float, null: false, default: 0
    add_column :delivery_zones, :post_fee, :float, null: false, default: 0
  end
end
