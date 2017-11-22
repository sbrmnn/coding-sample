class HistoricalSnapshotStat < ApplicationRecord
  self.primary_key = "financial_institution_id"
  belongs_to :financial_institution
end
