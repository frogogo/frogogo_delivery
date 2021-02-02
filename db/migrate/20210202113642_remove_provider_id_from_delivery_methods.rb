class RemoveProviderIdFromDeliveryMethods < ActiveRecord::Migration[6.0]
  def change
    remove_reference :delivery_methods, :provider, null: false
  end
end
