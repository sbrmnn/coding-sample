class BankAdmins::Products::OffersController < ApplicationController
  def index 
    @product =  current_bank_admin.products.find_by(:id => params[:product_id])
    @offers  =  @product.offers
    json_response(@offers)
  end
end
