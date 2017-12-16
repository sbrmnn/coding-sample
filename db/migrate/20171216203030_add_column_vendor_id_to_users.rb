class AddColumnVendorIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :vendor_id, :integer
  end
end
