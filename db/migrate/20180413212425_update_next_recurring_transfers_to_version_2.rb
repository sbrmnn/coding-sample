class UpdateNextRecurringTransfersToVersion2 < ActiveRecord::Migration[5.0]
  def change
    update_view :next_recurring_transfers, version: 2, revert_to_version: 1
  end
end
