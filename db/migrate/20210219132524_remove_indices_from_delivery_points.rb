class RemoveIndicesFromDeliveryPoints < ActiveRecord::Migration[6.1]
  def change
    remove_index :delivery_points, %w[address delivery_method_id], unique: true
    remove_index :delivery_points, %w[latitude longitude], unique: true
  end
end
