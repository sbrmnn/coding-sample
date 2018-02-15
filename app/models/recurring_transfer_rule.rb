class RecurringTransferRule < ApplicationRecord
  has_many :transfers
  belongs_to :goal
  validates_presence_of :amount, :start_dt, :frequency, :repeats
  enum periods: [:days, :week, :month]
  validates :frequency, inclusion: { in: periods.keys }
  acts_as_paranoid
end
