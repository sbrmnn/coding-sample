class AddColumnRuleIdToTransfers < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :rule_id, :integer
  end
end
