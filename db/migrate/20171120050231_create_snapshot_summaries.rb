class CreateSnapshotSummaries < ActiveRecord::Migration[5.0]
  def change
    create_view :snapshot_summaries
  end
end
