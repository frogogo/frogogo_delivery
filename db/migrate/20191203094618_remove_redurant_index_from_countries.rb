class RemoveRedurantIndexFromCountries < ActiveRecord::Migration[6.0]
  def change
    remove_index :countries, :name
  end
end
