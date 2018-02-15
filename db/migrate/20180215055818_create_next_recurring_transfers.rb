class CreateNextRecurringTransfers < ActiveRecord::Migration[5.0]
  def change
    create_view :next_recurring_transfers
  end
end
