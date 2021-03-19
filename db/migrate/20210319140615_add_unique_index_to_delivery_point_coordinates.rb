class AddUniqueIndexToDeliveryPointCoordinates < ActiveRecord::Migration[6.1]
  def change
    add_index :delivery_points, %i[latitude longitude], unique: true
  end
end
