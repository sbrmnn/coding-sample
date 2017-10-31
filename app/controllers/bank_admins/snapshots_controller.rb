class BankAdmins::SnapshotsController < BankAdmins::ApplicationController 
  def index
    @snapshot_summary = current_bank_admin.financial_institution.try(:snapshot_summary)
    if @snapshot_summary
       status = :ok
    else
       status = :not_found
    end
    json_response(@snapshot_summary, status)
  end
end
