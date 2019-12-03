class AddDeliveryZoneReferencesToLocalitiesAndSubdivisions < ActiveRecord::Migration[6.0]
  def change
    add_reference :localities, :delivery_zone, foreign_key: true
    add_reference :subdivisions, :delivery_zone, foreign_key: true
  end
end
