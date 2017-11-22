class SnapshotSummary < ApplicationRecord
  self.primary_key = "financial_institution_id"
  belongs_to :financial_institution
  has_many :historical_snapshot_stats, through: :financial_institution
end
