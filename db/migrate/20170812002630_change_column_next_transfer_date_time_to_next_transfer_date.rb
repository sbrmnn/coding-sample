class ChangeColumnNextTransferDateTimeToNextTransferDate < ActiveRecord::Migration[5.0]
  def change
    remove_column :transfers, :next_transfer_datetime, :datetime
    add_column :transfers, :next_transfer_date, :date
  end
end
