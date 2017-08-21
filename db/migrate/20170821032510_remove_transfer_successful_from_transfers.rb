class RemoveTransferSuccessfulFromTransfers < ActiveRecord::Migration[5.0]
  def change
    remove_column :transfers, :transfer_successful
  end
end
