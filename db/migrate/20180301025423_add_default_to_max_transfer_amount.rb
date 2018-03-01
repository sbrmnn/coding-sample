class AddDefaultToMaxTransferAmount < ActiveRecord::Migration[5.0]
  def change
  	change_column_default(:users, :max_transfer_amount, 25)
  	change_column_default(:financial_institutions, :max_transfer_amount, 25)
  end
end
