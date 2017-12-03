class AddColumnTotalNumOfGoalsToHistoricalSnapshots < ActiveRecord::Migration[5.0]
  def change
    add_column :historical_snapshots, :total_num_of_goals, :integer, default: 0
  end
end
