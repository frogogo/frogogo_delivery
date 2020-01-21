class ChangeColumnsLatitudeLongitudeToDecimal < ActiveRecord::Migration[6.0]
  def change
    remove_column :delivery_points, :latitude
    remove_column :delivery_points, :longitude

    add_column :delivery_points, :latitude, :decimal, precision: 10, scale: 6
    add_column :delivery_points, :longitude, :decimal, precision: 10, scale: 6
  end
end
