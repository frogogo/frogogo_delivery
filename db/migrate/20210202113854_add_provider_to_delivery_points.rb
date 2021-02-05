class AddProviderToDeliveryPoints < ActiveRecord::Migration[6.0]
  def change
    DeliveryPoint.destroy_all

    add_reference :delivery_points, :provider, null: false, foreign_key: true
  end
end
