class CreateDeliveryMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_methods do |t|
      t.belongs_to :provider, foreign_key: true
      t.references :deliverable, polymorphic: true

      t.string :name, null: false
      t.integer :method, default: 0
      t.boolean :inactive, default: false
      t.string :date_interval
      t.string :time_intervals, array: true

      t.timestamps
    end
  end
end
