class RemoveLocalCodeFromLocalities < ActiveRecord::Migration[6.1]
  def change
    remove_column :localities, :local_code, :string
  end
end
