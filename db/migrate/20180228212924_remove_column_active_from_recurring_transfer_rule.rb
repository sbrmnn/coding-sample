class RemoveColumnActiveFromRecurringTransferRule < ActiveRecord::Migration[5.0]
  def change
    remove_column :recurring_transfer_rules, :active, :boolean
  end
end
