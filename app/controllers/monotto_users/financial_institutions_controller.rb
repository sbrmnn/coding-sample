class MonottoUsers::FinancialInstitutionsController < MonottoUsers::ApplicationController
   def index
     @financial_institutions = FinancialInstitution.all.where(params[:financial_institution])
     if @financial_institutions.present?
       status = :ok
     else
       status = :not_found
     end
     json_response(@financial_institutions, status)
   end

   def show
     @financial_institution = FinancialInstitution.find_by(id: params[:id])
     if @financial_institution
      status = :ok
     else
      status = :not_found
     end
     json_response(@financial_institution, status)
   end

   def create
     @financial_institution = FinancialInstitution.create(financial_institution_params)
     if @financial_institution.errors.any?
        status = :unprocessable_entity
     else
        status = :created
     end
     json_response(@financial_institution, status)
   end

   def update
      @financial_institution = FinancialInstitution.find_by(id: params[:id]).try{ |obj| obj.update_attributes(financial_institution_params)}
      if @financial_institution.present?
        status = :ok
      else
        status = :not_found
      end
      json_response(@financial_institution, status)
   end

   def destroy
     @financial_institution = FinancialInstitution.find_by(id: params[:id]).try(:destroy)
     if @financial_institutions.present?
       status = :ok
     else
       status = :not_found
     end
     json_response(@financial_institution, status) 
   end

   protected

   def financial_institution_params
     params.require(:transfer).permit(:name, :location, :core, :web, :mobile, :notes, :relationship_manager, :max_transfer, :transfers_active)
   end
end
