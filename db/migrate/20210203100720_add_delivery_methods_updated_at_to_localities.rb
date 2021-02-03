class AddDeliveryMethodsUpdatedAtToLocalities < ActiveRecord::Migration[6.0]
  def change
    add_column :localities, :delivery_methods_updated_at, :datetime
  end
end
