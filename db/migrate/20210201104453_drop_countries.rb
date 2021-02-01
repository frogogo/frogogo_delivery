class DropCountries < ActiveRecord::Migration[6.0]
  def up
    drop_table :countries
  end

  def down
    create_table :countries do |t|
      t.string :name, null: false
      t.string :iso_code, null: false
      t.string :language_code, null: false

      t.timestamps
    end
    add_index :countries, :name, unique: true
    add_index :countries, :iso_code, unique: true
    add_index :countries, :language_code, unique: true
  end
end
