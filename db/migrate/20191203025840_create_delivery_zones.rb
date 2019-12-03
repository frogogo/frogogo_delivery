class CreateDeliveryZones < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_zones do |t|
      t.belongs_to :country, foreign_key: true
      t.boolean :default, default: false
      t.float :fee, null: false
      t.float :free_delivery_gold_threshold, null: false
      t.float :free_delivery_threshold, null: false

      t.timestamps
    end
  end
end
