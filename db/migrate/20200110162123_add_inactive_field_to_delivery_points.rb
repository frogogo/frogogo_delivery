class AddInactiveFieldToDeliveryPoints < ActiveRecord::Migration[6.0]
  def change
    add_column :delivery_points, :inactive, :boolean, default: false
  end
end
