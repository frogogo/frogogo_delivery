class CreateSubdivisions < ActiveRecord::Migration[6.0]
  def change
    create_table :subdivisions do |t|
      t.belongs_to :country, foreign_key: true
      t.string :iso_code, null: false
      t.string :local_code, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :subdivisions, :iso_code, unique: true
    add_index :subdivisions, [:local_code, :country_id], unique: true
    add_index :subdivisions, [:name, :country_id], unique: true
  end
end
