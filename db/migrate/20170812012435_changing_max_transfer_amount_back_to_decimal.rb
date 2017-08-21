class ChangingMaxTransferAmountBackToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :financial_institutions, :max_transfer_amount, :decimal, default: 0, precision: 10, scale: 2, null: false
    change_column :users, :max_transfer_amount, :decimal, default: 0, precision: 10, scale: 2, null: false
  end
end
