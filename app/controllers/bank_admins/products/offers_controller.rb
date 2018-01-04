class BankAdmins::Products::OffersController < BankAdmins::ApplicationController
  before_action :find_product

  def index
    @offers = @product.try(:offers).try(:with_stats)
    json_response(@offers)
  end

  protected

  def find_product
    @product = current_bank_admin.products.find_by(id: params[:product_id])
  end
end
