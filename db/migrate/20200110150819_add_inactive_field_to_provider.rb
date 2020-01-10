class AddInactiveFieldToProvider < ActiveRecord::Migration[6.0]
  def change
    add_column :providers, :inactive, :boolean, default: false
  end
end
