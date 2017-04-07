class ChangeAmountInTransfers < ActiveRecord::Migration[5.0]
  def change
  	change_column :transfers, :amount, :integer
  end
end
