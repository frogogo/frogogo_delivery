class CreateLocalities < ActiveRecord::Migration[6.0]
  def change
    create_table :localities do |t|
      t.belongs_to :subdivision, foreign_key: true
      t.string :name, null: false
      t.string :local_code
      t.string :postal_code

      t.timestamps
    end
    add_index :localities, [:name, :subdivision_id], unique: true
    add_index :localities, [:local_code, :subdivision_id], unique: true
    add_index :localities, :postal_code, unique: true
  end
end
