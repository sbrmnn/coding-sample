class BankAdmins::SnapshotsController < BankAdmins::ApplicationController 
  def index
    @snapshot_summary = SnapshotPresenter.new(current_bank_admin.financial_institution).summary
    json_response(@snapshot_summary)
  end
end
  