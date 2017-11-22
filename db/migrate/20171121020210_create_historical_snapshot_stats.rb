class CreateHistoricalSnapshotStats < ActiveRecord::Migration[5.0]
  def change
    create_view :historical_snapshot_stats
  end
end
