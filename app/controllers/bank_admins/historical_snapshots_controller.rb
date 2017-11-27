class BankAdmins::HistoricalSnapshotsController < ApplicationController
  def index
    @historical_snapshot = current_bank_admin.try(:historical_snapshots).where("date > ?", 6.months.ago).order('date ASC')
    json_response(@historical_snapshot)
  end
end
