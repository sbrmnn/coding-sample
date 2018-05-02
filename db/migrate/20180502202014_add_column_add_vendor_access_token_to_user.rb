class AddColumnAddVendorAccessTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :vendor_access_token, :string
  end
end
