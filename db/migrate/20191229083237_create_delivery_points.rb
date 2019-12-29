class CreateDeliveryPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_points do |t|
      t.belongs_to :delivery_method, foreign_key: true
      t.string :address, null: false
      t.string :code
      t.string :directions
      t.string :latitude
      t.string :longitude
      t.string :phone_number
      t.string :working_hours

      t.timestamps
    end
    add_index :delivery_points, %i[address delivery_method_id], unique: true
  end
end
