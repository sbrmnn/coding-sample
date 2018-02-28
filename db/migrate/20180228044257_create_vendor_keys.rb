class CreateVendorKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :vendor_keys do |t|
      t.belongs_to :vendor
      t.string :key
      t.belongs_to :user
      t.timestamps
    end
  end
end
