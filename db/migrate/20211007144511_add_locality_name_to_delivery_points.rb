class AddLocalityNameToDeliveryPoints < ActiveRecord::Migration[6.1]
  def change
    add_column :delivery_points, :locality_name, :string
  end
end
