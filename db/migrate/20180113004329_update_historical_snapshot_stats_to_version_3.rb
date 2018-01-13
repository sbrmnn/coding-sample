class UpdateHistoricalSnapshotStatsToVersion3 < ActiveRecord::Migration[5.0]
  def change
    update_view :historical_snapshot_stats, version: 3, revert_to_version: 2
  end
end
