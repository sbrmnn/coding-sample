class AddDateToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :date, :date
  end
end
