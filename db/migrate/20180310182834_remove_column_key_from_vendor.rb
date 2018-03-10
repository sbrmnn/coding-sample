class RemoveColumnKeyFromVendor < ActiveRecord::Migration[5.0]
  def change
    remove_column :vendors, :key, :string
  end
end
