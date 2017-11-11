class BankAdmins::AdsController < BankAdmins::ApplicationController
   
   def index
     @ads = current_bank_admin.ads.where(ad_params)
     json_response(@ads)
   end

   def create
     @ad = Ad.new(ad_params)
     current_bank_admin.financial_institution.ads << @ad
     status = @ad.errors.any? ? :unprocessable_entity : :created
     json_response(@ad)
   end

   def show
     @ad = current_bank_admin.ads.find_by(id: params[:id])
     json_response(@ad)
  end
=begin
  def update
     @ad = current_bank_admin.ads.find_by(id: params[:id])
     if @ad
       @ad.update_attributes(ad_params) 
       status = @ad.errors.any? ? :unprocessable_entity :  :ok
     else
       status = :not_found
     end 
     json_response(@ad)
   end

   def destroy
     @ad = current_bank_admin.ads.find_by(id: params[:id])
     if @ad
       @ad.destroy
       status = :ok
     else
      status = :not_found
     end
     json_response(@ad)
   end
=end
   protected
  
   def ad_params
    if params[:ad].blank?
      {}
    else
      params.require(:ad).permit(:header, :body, :link, :image, :name)
    end
   end
end
