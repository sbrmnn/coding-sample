class Goal < ApplicationRecord
  belongs_to :user

  validates_presence_of :user
  validates :name, uniqueness: { scope: :user_id }
  validates :completion, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :priority, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :amount, numericality: { greater_than: 0}
end
