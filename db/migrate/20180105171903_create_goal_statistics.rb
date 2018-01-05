class CreateGoalStatistics < ActiveRecord::Migration[5.0]
  def change
    create_view :goal_statistics
  end
end
