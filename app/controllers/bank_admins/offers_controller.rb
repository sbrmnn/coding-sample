class BankAdmins::OffersController < BankAdmins::ApplicationController
   
   def index
     @offers = current_bank_admin.offers.where(offer_params)
     json_response(@offers)
   end

   def create
     @offer = Offer.new(offer_params)
     current_bank_admin.financial_institution.offers << @offer
     json_response(@offer)
   end

   def show
     @offer = current_bank_admin.offers.find_by(id:  params[:id])
     json_response(@offer)
   end

   def update
     @offer = current_bank_admin.offers.find_by(id: params[:id])
     if @offer
       @offer.update_attributes(offer_params) 
     end 
     json_response(@offer)
   end

   def destroy
     @offer = current_bank_admin.offers.find_by(id: params[:id])
     if @offer
       @offer.destroy
     end
     json_response(@offer)
   end

   protected
  
   def offer_params
     if params[:offer].blank?
      {}
     else
      params.require(:offer).permit(:name, :condition, :symbol, :value, :ad_name, :click_through, :delivered, :product_name, :xref_goal_name)
     end
   end 
end
