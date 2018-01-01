class AddSavingsAcctBalanceToGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :goals, :savings_acct_balance, :decimal, precision: 10, scale: 2
  end
end
