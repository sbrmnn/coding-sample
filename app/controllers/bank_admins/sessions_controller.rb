class BankAdmins::SessionsController < BankAdmins::ApplicationController 
  skip_before_action :require_bank_admin_login, only: [:create], raise: false
  
  def create
  	check_valid_login?(BankAdmin)
  end

  def destroy
    current_bank_admin.invalidate_token
    head :ok
  end
end
