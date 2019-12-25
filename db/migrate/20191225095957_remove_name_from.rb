class RemoveNameFrom < ActiveRecord::Migration[6.0]
  def change
    remove_column :delivery_methods, :name, type: :string
  end
end
