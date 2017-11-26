class CreateXrefGoalTypeStats < ActiveRecord::Migration[5.0]
  def change
    create_view :xref_goal_type_stats
  end
end
