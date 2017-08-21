class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.text :original_description
      t.text :split_type
      t.text :category
      t.string :currency, limit: 1
      t.decimal :amount, default: 0, precision: 10, scale: 2, null: false
      t.text :user_description
      t.text :memo
      t.text :classification
      t.text :account_name
      t.text :simple_description
      t.integer :balance
      t.belongs_to :user
      t.timestamps
    end
    add_foreign_key :transactions, :users
  end
end
