class HistoricalSnapshot < ApplicationRecord
  belongs_to :financial_institution
  before_validation :set_date, if: lambda { self.date.blank? }
  validates_presence_of :date

  protected

  def set_date
    self.date = Time.now
  end
end
