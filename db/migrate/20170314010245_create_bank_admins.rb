class CreateBankAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_admins do |t|
      t.belongs_to :financial_institution, :null => false
      t.string :email, null: false
      t.string :name, null: false
      t.string :title, null: false
      t.string :phone, null: false
      t.text :notes
      t.boolean :is_primary, default: false
      t.string :password_digest
      t.string :token, unique: true
      t.datetime :token_created_at
      t.timestamps
    end
    add_index :bank_admins, [:token, :token_created_at]
    add_index :bank_admins, [:financial_institution_id, :email], unique: true
  end
end
