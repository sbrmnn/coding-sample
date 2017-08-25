class ChangeTransferAmountAttemptedToDecimal < ActiveRecord::Migration[5.0]
  def change
  	change_column :transfers, :transfer_amount_attempted , :decimal, precision: 10, scale: 2
  end
end
