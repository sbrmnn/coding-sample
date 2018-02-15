class RemoveColumnEndDtInRecurringTransferRule < ActiveRecord::Migration[5.0]
  def change
  	remove_column :recurring_transfer_rules, :end_dt, :timestamp
  end
end
