class AddPublicKeyToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :public_key, :string
  end
end
