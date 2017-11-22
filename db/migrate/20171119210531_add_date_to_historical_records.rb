class AddDateToHistoricalRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :historical_snapshots, :date, :timestamp
  end
end
