class TimeUntilCompletion < ApplicationRecord
  self.primary_key = "goal_id"
  belongs_to :goal
end
