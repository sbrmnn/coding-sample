class ChangeColumnMaxTransferAmountInUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :max_transfer_amount, :integer
  end
end
