class AddParentLocalityIdToLocalities < ActiveRecord::Migration[6.1]
  def change
    add_reference :localities, :parent_locality, foreign_key: { to_table: :localities }
  end
end
