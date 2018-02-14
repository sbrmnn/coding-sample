class AddIndexForDeletedAtForRecurringTransferRules < ActiveRecord::Migration[5.0]
  def change
  	add_index :recurring_transfer_rules, :deleted_at
  end
end
