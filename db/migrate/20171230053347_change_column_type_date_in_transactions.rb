class ChangeColumnTypeDateInTransactions < ActiveRecord::Migration[5.0]
  def up
  	change_column :transactions, :date, :datetime
  end

  def down
  	change_column :transactions, :date, :date
  end
end
