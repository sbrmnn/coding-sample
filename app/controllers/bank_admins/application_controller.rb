class BankAdmins::ApplicationController < ApplicationController
    before_filter :require_bank_admin_login
    
    protected

    def current_bank_admins_financial_institution
      current_bank_admin.financial_institution
    end
end

