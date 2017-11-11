class BankAdmins::SnapshotsController < BankAdmins::ApplicationController 
  def index
    @snapshot_summary = current_bank_admin.financial_institution.try(:snapshot_summary)
    json_response(@snapshot_summary)
  end
end
