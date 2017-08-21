class ChangePrimaryKeyToBigintOnTransactions < ActiveRecord::Migration[5.0]
  def change
    change_column :transactions, :id, :bigint
  end
end
