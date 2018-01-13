class UpdateHistoricalSnapshotStatsToVersion2 < ActiveRecord::Migration[5.0]
  def change
    update_view :historical_snapshot_stats, version: 2, revert_to_version: 1
  end
end
