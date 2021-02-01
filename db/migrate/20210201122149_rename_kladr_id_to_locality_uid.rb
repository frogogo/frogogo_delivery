class RenameKladrIdToLocalityUid < ActiveRecord::Migration[6.0]
  def change
    rename_column :localities, :kladr_id, :locality_uid
  end
end
