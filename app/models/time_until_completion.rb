class TimeUntilCompletion < ApplicationRecord
  self.primary_key = "xref_goal_type_id"
  belongs_to :xref_goal_type
end
