class GoalStatistic < ApplicationRecord
  self.primary_key = "goal_id"
  belongs_to :goal
end
