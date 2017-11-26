class BankAdmins::FinancialInstitutionsController < BankAdmins::ApplicationController
   
   def show
     @financial_institution = current_bank_admin.financial_institution
     json_response(@financial_institution)
   end

   def update
   	 @financial_institution = current_bank_admin.financial_institution
     if @financial_institution
       @financial_institution.update_attributes(financial_institution_params) 
     end 
     json_response(@financial_institution)
   end

   protected
  
   def financial_institution_params
    if params[:financial_institution].blank?
      {}
    else
      params.require(:financial_institution).permit(:max_transfer_amount, :transfers_active)
    end
   end

end
