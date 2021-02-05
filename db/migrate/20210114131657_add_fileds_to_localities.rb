class AddFiledsToLocalities < ActiveRecord::Migration[6.0]
  def change
    add_column :localities, :latitude, :float, if_not_exists: true
    add_column :localities, :longitude, :float, if_not_exists: true
    add_column :localities, :kladr_id, :string, if_not_exists: true
  end
end
