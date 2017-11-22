class BankAdmins::Products::OffersController < BankAdmins::ApplicationController
  before_action :find_product

  def index
    @offers = @product.try(:offers).try(:with_status)
    json_response(@offers)
  end

  protected

  def find_product
    @product = current_bank_admin.try(:products).try{ |obj| obj.find_by(id: params[:product_id]) }
  end
end
