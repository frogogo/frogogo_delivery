class RemoveNotNullConstraintFromCodeFieldsInSubdivisions < ActiveRecord::Migration[6.0]
  def change
    change_column_null :subdivisions, :iso_code, true
    change_column_null :subdivisions, :local_code, true
  end
end
