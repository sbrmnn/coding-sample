class AddColumnXrefGoalTypeIdToGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :goals, :xref_goal_type_id, :integer
    add_foreign_key :goals, :xref_goal_types
  end
end
