class RemoveLocalCodeFromSubdivisions < ActiveRecord::Migration[6.1]
  def change
    remove_column :subdivisions, :local_code, :string
  end
end
