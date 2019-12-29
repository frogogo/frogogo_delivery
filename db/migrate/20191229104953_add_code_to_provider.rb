class AddCodeToProvider < ActiveRecord::Migration[6.0]
  def change
    add_column :providers, :code, :string
  end
end
