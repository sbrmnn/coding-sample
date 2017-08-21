class RemoveTimestampsFromTransactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :transactions, :created_at
    remove_column :transactions, :updated_at 
  end
end
