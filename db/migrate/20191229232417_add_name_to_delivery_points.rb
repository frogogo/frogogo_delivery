class AddNameToDeliveryPoints < ActiveRecord::Migration[6.0]
  def change
    add_column :delivery_points, :name, :string
  end
end
