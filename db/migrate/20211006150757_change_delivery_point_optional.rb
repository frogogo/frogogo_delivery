class ChangeDeliveryPointOptional < ActiveRecord::Migration[6.1]
  def change
    change_column_null :delivery_points, :delivery_method_id, true
  end
end
