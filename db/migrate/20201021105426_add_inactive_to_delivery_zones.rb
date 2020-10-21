class AddInactiveToDeliveryZones < ActiveRecord::Migration[6.0]
  def change
    add_column :delivery_zones, :inactive, :boolean, default: false

    DeliveryZone.find_by(zone: '6').update_column(:inactive, true)
  end
end
