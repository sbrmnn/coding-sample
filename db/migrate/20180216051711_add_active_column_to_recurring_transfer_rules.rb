class AddActiveColumnToRecurringTransferRules < ActiveRecord::Migration[5.0]
  def change
    add_column :recurring_transfer_rules, :active, :boolean, default: true
  end
end
