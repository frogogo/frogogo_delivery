class AddNotNullConstraintForForeignKeys < ActiveRecord::Migration[6.0]
  def change
    change_column_null :delivery_methods, :provider_id, false
    change_column_null :delivery_points, :delivery_method_id, false
    change_column_null :delivery_zones, :country_id, false
    change_column_null :localities, :subdivision_id, false
    change_column_null :subdivisions, :country_id, false
  end
end
