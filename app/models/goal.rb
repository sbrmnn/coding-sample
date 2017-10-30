class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :xref_goal_type
  validates_presence_of :user
  validates :priority, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :target_amount, numericality: { greater_than: 0}
  validates :collection, numericality: { greater_than: 0}
  validates_presence_of :user
end
