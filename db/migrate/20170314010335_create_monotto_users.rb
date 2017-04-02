class CreateMonottoUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :monotto_users do |t|
      t.string :email, null: false
      t.string :name
      t.string :password_digest
      t.string :token, unique: true
      t.datetime :token_created_at
      t.timestamps
    end
    add_index :monotto_users, [:token, :token_created_at]
    add_index :monotto_users, [:email], unique: true
  end
end
