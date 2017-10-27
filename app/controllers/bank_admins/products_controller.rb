class BankAdmins::ProductsController < BankAdmins::ApplicationController
   def index
     @products = current_bank_admin.products.where(ad_params)
     json_response(@products, :ok)
   end

   def create
     @product = Product.new(ad_params)
     current_bank_admin.financial_institution.products << @product
     status = @product.errors.any? ? :unprocessable_entity : :created
     json_response(@product, status)
   end

   def show
     @product = current_bank_admin.products.find_by(id:  params[:id])
     if @product
       status = :ok
     else
       status = :not_found
     end
     json_response(@product, status)
  end

  def update
     @product = current_bank_admin.products.find_by(id: params[:id])
     if @product
       @product.update_attributes(ad_params) 
       status = @product.errors.any? ? :unprocessable_entity :  :ok
     else
       status = :not_found
     end 
     json_response(@product, status)
   end

   def destroy
     @product = current_bank_admin.products.find_by(id: params[:id])
     if @product
       @product.destroy
       status = :ok
     else
      status = :not_found
     end
     json_response(@product, status)
   end

   protected
  
   def ad_params
    if params[:product].nil?
      {}
    else
      params.require(:product).permit(:name)
    end
   end
end
