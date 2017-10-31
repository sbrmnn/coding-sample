class BankAdmins::OffersController < BankAdmins::ApplicationController
   
   def index
     @offers = current_bank_admin.offers.where(offer_params)
     json_response(@offers, :ok)
   end

   def create
     @offer = Offer.new(offer_params)
     current_bank_admin.financial_institution.offers << @offer
     status = @offer.errors.any? ? :unprocessable_entity : :created
     json_response(@offer, status)
   end

   def show
     @offer = current_bank_admin.offers.find_by(id:  params[:id])
     if @offer
       status = :ok
     else
       status = :not_found
     end
     json_response(@offer, status)
   end

   def update
     @offer = current_bank_admin.offers.find_by(id: params[:id])
     if @offer
       @offer.update_attributes(offer_params) 
       status = @offer.errors.any? ? :unprocessable_entity :  :ok
     else
       status = :not_found
     end 
     json_response(@offer, status)
   end

   def destroy
     @offer = current_bank_admin.offers.find_by(id: params[:id])
     if @offer
       @offer.destroy
       status = :ok
     else
      status = :not_found
     end
     json_response(@offer, status)
   end

   protected
  
   def offer_params
    if params[:offer].blank?
      {}
    else
      params.require(:offer).permit(:name, :condition, :symbol, :value)
    end
   end 
end
