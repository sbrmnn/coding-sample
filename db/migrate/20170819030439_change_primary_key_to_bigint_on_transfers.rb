class ChangePrimaryKeyToBigintOnTransfers < ActiveRecord::Migration[5.0]
  def change
  	change_column :transfers, :id, :bigint
  end
end
