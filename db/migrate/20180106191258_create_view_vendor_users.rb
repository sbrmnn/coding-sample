class CreateViewVendorUsers < ActiveRecord::Migration[5.0]
  def change
    create_view :view_vendor_users
  end
end
