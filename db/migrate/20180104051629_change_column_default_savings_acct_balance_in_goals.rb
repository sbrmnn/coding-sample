class ChangeColumnDefaultSavingsAcctBalanceInGoals < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :goals, :savings_acct_balance, 0
  end
end
