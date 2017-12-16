class CreateVendors < ActiveRecord::Migration[5.0]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :location
      t.string :core
      t.string :web
      t.string :mobile
      t.string :email
      t.text :notes
      t.string :relationship_manager
      t.string :password_digest
      t.string :token, unique: true
      t.datetime :token_created_at
      t.timestamps
    end
    add_index :vendors, [:token, :token_created_at]
    add_index :vendors, [:email]
  end
end


