class AddFiledsToLocalities < ActiveRecord::Migration[6.0]
  def change
    add_column :localities, :latitude, :float
    add_column :localities, :longitude, :float
    add_column :localities, :district, :string
  end
end
