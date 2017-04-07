class AddColumnNextTransferDatetimeToTransfer < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :next_transfer_datetime, :datetime
  end
end
