class CreateGoalStatistics < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE VIEW goal_statistics AS
        SELECT
          goals.id AS goal_id,
          (balance*100/target_amount) as percent_saved
        FROM 
          goals 
    SQL
  end

  def down
    execute "DROP VIEW goal_statistics"
  end
end
