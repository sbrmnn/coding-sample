class BankAdmins::ProductsController < BankAdmins::ApplicationController
   
   def index
     @products = current_bank_admin.products.where(product_params)
     json_response(@products, :ok)
   end
=begin
   def create
     @product = Product.new(product_params)
     current_bank_admin.financial_institution.products << @product
     status = @product.errors.any? ? :unprocessable_entity : :created
     json_response(@product, status)
   end
=end
   def show
     @product = current_bank_admin.products.find_by(id:  params[:id])
     if @product
       status = :ok
     else
       status = :not_found
     end
     json_response(@product, status)
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
=end
   protected
  
   def product_params
    if params[:product].nil?
      {}
    else
      params.require(:product).permit(:name)
    end
   end
end
