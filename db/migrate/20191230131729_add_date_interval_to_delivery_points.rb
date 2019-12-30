class AddDateIntervalToDeliveryPoints < ActiveRecord::Migration[6.0]
  def change
    add_column :delivery_points, :date_interval, :string
  end
end
