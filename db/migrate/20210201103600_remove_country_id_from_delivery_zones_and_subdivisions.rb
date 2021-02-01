class RemoveCountryIdFromDeliveryZonesAndSubdivisions < ActiveRecord::Migration[6.0]
  def change
    remove_reference :subdivisions, :country
    remove_reference :delivery_zones, :country
  end
end
