class RemoveTransferSuccessfulFromTransactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :transfers, :transfer_successful, :string
  end
end
