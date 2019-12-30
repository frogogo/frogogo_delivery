class AddLocalitiesListToProviders < ActiveRecord::Migration[6.0]
  def change
    add_column :providers, :localities_list, :jsonb
  end
end
