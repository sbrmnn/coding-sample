class ChangeBalanceColumnTypeInTransactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :transactions, :balance
    add_column :transactions, :balance, :decimal, default: 0, precision: 10, scale: 2, null: false
  end
end
