class AddDefaultToEndDateToRecurringTransferRule < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :recurring_transfer_rules, :end_dt, 'infinity'
  end
end
