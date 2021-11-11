class ChangeLocalityIndex < ActiveRecord::Migration[6.1]
  def change
    remove_index :localities, [:name, :subdivision_id], unique: true
    add_index :localities, [:locality_uid, :subdivision_id], unique: true
  end
end
