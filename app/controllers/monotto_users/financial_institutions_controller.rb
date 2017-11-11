class MonottoUsers::FinancialInstitutionsController < MonottoUsers::ApplicationController
   
   def index
     @financial_institutions = FinancialInstitution.all.where(financial_institution_params)
     json_response(@financial_institutions)
   end

   def create
     @financial_institution = FinancialInstitution.create(financial_institution_params)
     json_response(@financial_institution)
   end

   def show
     @financial_institution = FinancialInstitution.find_by(id: params[:id])
     json_response(@financial_institution)
   end

   def update
      @financial_institution = FinancialInstitution.find_by(id: params[:id])
      if @financial_institution.present?
        @financial_institution.update_attributes(financial_institution_params)
      end
      json_response(@financial_institution)
   end

   def destroy
     @financial_institution = FinancialInstitution.find_by(id: params[:id]).try(:destroy)
     json_response(@financial_institution) 
   end

   protected

   def financial_institution_params
     if params[:financial_institution].blank?
      {}
     else
      params.require(:financial_institution).permit(:name, :location, :core, :web, :mobile, :notes, :relationship_manager, :max_transfer, :transfers_active)
     end
   end
end
