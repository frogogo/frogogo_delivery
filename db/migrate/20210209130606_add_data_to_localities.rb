class AddDataToLocalities < ActiveRecord::Migration[6.1]
  def change
    add_column :localities, :data, :jsonb
  end
end
