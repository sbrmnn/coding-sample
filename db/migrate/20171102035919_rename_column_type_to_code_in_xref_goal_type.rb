class RenameColumnTypeToCodeInXrefGoalType < ActiveRecord::Migration[5.0]
  def change
  	rename_column :xref_goal_types, :type, :code
  end
end
