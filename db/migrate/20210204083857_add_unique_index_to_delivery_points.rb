class AddUniqueIndexToDeliveryPoints < ActiveRecord::Migration[6.0]
  def change
    DeliveryPoint.destroy_all
    add_index :delivery_points, %i[latitude longitude], unique: true
  end
end
