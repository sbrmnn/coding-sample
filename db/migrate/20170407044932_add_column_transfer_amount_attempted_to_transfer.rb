class AddColumnTransferAmountAttemptedToTransfer < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :transfer_amount_attempted, :integer
  end
end
