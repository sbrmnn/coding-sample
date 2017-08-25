class ChangeAmountToDecimal < ActiveRecord::Migration[5.0]
  def change
  	change_column :transfers, :amount , :decimal , precision: 10, scale: 2
  end
end
