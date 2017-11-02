class BankAdmins::ProductsController < BankAdmins::ApplicationController
   
   def index
     @products = current_bank_admin.products.where(product_params)
     json_response(@products)
   end

   def create
     @product = Product.new(product_params)
     current_bank_admin.financial_institution.products << @product
     json_response(@product)
   end

   def show
     @product = current_bank_admin.products.find_by(id:  params[:id])
     json_response(@product)
   end
=begin
   def update
     @product = current_bank_admin.products.find_by(id: params[:id])
     if @product
       @product.update_attributes(product_params) 
       status = @product.errors.any? ? :unprocessable_entity :  :ok
     else
       status = :not_found
     end 
     json_response(@product)
   end

   def destroy
     @product = current_bank_admin.products.find_by(id: params[:id])
     if @product
       @product.destroy
       status = :ok
     else
      status = :not_found
     end
     json_response(@product)
   end
=end
   protected
  
   def product_params
    if params[:product].blank?
      {}
    else
      params.require(:product).permit(:name)
    end
   end
end
