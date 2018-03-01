class Vendors::Users::DashboardUrlsController < Vendors::ApplicationController
  def create
  	@financial_institution_id = FinancialInstitution.where(name: params["FinancialInstitutionId"], vendor_id: current_vendor.id).first_or_create.id
    @checking_accounts =  params["Accounts"].map{|l| l["AccountNumber"] if l["AccountType"] == 'checking'}.compact
    @savings_accounts  =  params["Accounts"].map{|l| l["AccountNumber"] if l["AccountType"] == 'savings'}.compact
    @bank_user_id      =  params["CustomerId"]
    query_arr = []
    @checking_accounts.map{|ca| query_arr << "checking[]=#{ca}"}
    @savings_accounts.map{ |sa| query_arr << "savings[]=#{sa}"}
    @vendor_user_key = User.where(bank_user_id: @bank_user_id).first.try(:vendor_user_key).try(:key)
    if @vendor_user_key.blank?
       @vendor_user_key = VendorUserKey.create(vendor_id: current_vendor.id).key
    end
    query_arr << "vendor_user_key=#{@vendor_user_key}" 
    query_arr << "financial_institution_id=#{@financial_institution_id}"
    query_arr << "bank_user_id=#{@bank_user_id}"
    query_string = query_arr.join("&")
    json_response({url: "#{request.env["HTTP_HOST"]}?#{query_string}"})
  end
end


