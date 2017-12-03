class AddColumnTotalAmountOfCompletedGoalsToHistoricalSnapshots < ActiveRecord::Migration[5.0]
  def change
    add_column :historical_snapshots, :total_amount_of_completed_goals, :integer, default: 0
  end
end
