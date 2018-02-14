class RecurringTransferRule < ApplicationRecord
  has_many :transfers
  belongs_to :goal
  validates_presence_of :amount, :start_dt, :end_dt, :frequency, :repeats
  enum periods: [:day, :week, :month]
  validates :frequency, inclusion: { in: periods.keys }
  acts_as_paranoid
end
