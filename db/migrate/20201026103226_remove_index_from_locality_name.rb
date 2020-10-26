class RemoveIndexFromLocalityName < ActiveRecord::Migration[6.0]
  def change
    remove_index :localities, column: %i[name subdivision_id], unique: true
  end
end
