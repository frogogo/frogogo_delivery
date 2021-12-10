class RemoveIsoCodeFromSubdivisions < ActiveRecord::Migration[6.1]
  def change
    remove_column :subdivisions, :iso_code, :string
  end
end
