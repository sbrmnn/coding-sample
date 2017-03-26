class CreateTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :transfers do |t|
      t.belongs_to :user, null: false
      t.string :origin_account, null: false
      t.string :destination_account, null: false
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
