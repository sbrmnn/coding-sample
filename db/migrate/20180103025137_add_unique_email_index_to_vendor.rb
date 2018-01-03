class AddUniqueEmailIndexToVendor < ActiveRecord::Migration[5.0]
  def change
  	remove_index :vendors, :email
  	add_index(:vendors, :email, unique: true)
  end
end
