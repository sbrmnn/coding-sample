class RenameVendorKeysTableToVendorUserKeys < ActiveRecord::Migration[5.0]
  def change
  	rename_table :vendor_keys, :vendor_user_keys
  end
end
