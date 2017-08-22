class AddEndDateToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :end_date, :date
  end
end
