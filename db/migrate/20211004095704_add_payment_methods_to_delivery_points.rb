class AddPaymentMethodsToDeliveryPoints < ActiveRecord::Migration[6.1]
  def change
    add_column :delivery_points, :payment_methods, :string, array: true, default: []
  end
end
