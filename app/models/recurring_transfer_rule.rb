class RecurringTransferRule < ApplicationRecord
  has_many :transfers
  belongs_to :goal
  validates_presence_of :amount, :start_dt, :repeats
  enum periods: [:day, :week, :month]
  validates :frequency, inclusion: { in: periods.keys }
end
