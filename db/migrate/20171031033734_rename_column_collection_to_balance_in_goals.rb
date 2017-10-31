class RenameColumnCollectionToBalanceInGoals < ActiveRecord::Migration[5.0]
  def change
  	rename_column :goals, :collection, :balance
  end
end
