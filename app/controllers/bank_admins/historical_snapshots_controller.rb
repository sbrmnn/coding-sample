class BankAdmins::HistoricalSnapshotsController < ApplicationController
  def index
    @historical_snapshot = current_bank_admin.financial_institution.try(:historical_snapshots)
    json_response(@historical_snapshot)
  end
end
