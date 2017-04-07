class AddColumnTransferSuccessfulToTransfer < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :transfer_successful, :boolean
  end
end
