class Vendors::FinancialInstitutionsController < Vendors::ApplicationController
   
   def index
     @financial_institutions = current_vendor.financial_institutions
     json_response(@financial_institutions)
   end

   def create
     @financial_institution = FinancialInstitution.new(financial_institution_params)
     current_vendor.financial_institutions << @financial_institution
     json_response(@financial_institution)
   end

   def show
     @financial_institution = current_vendor.financial_institutions.find_by(id: params[:id])
     json_response(@financial_institution)
   end

   def update
     @financial_institution = current_vendor.financial_institutions.find_by(id: params[:id])
     if @financial_institution
       @financial_institution.update_attributes(financial_institution_params) 
     end 
     json_response(@financial_institution)
   end

   def destroy
     @financial_institution = current_vendor.financial_institutions.find_by(id: params[:id])
     if @financial_institution
       @financial_institution.destroy
     end
     json_response(@financial_institution)
   end
   
   protected
   
   def financial_institution_params
    if params[:financial_institution].blank?
      {}
    else
      params.require(:financial_institution).permit(:core, :location, :mobile, :name,
                                                    :notes, :relationship_manager, :web)
    end
   end
end
