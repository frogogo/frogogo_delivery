class RemoveDeliveryMethodsUpdatedAtFromLocalities < ActiveRecord::Migration[6.1]
  def change
    remove_column :localities, :delivery_methods_updated_at, :datetime
  end
end
