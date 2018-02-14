class RecurringTransferRule < ApplicationRecord
  has_many :transfers
  belongs_to :goal
  validates_presence_of :amount, :start_dt, :end_dt, :frequency, :repeats
end
