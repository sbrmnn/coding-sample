class AddDefaultNotNulllToSavingsAcctBalance < ActiveRecord::Migration[5.0]
  def change
  	change_column_null :goals, :savings_acct_balance, false
  end
end
