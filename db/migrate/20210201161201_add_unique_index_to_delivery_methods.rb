class AddUniqueIndexToDeliveryMethods < ActiveRecord::Migration[6.0]
  def change

    # Destroy all duplicates
    Locality.find_each do |locality|
      grouped = locality.delivery_methods.group_by{ |method| method.method }
      grouped.values.each do |group|
        first = group.shift
        group.each { |duplicate| duplicate.destroy }
      end
    end

    # Add index
    add_index :delivery_methods, %i[method deliverable_id], unique: true
  end
end
