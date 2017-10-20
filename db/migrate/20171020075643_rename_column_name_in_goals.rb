class RenameColumnNameInGoals < ActiveRecord::Migration[5.0]
  def change
  	rename_column :goals, :name, :type
  end
end
