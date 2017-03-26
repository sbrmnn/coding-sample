class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.belongs_to :financial_institution, null: false
      t.string :sequence, null: false
      t.string :bank_identifier, null: false
      t.string :savings_account_identifier, null: false
      t.string :checking_account_identifier, null: false
      t.boolean :transfers_active, default: true
      t.boolean :safety_net_active, default: true
      t.integer :max_transfer_amount
      t.timestamps
    end
  end
end
