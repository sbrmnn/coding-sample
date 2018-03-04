class Vendors::Users::DashboardUrlsController < Vendors::ApplicationController
  # TODO: cut down create action code and migrate code to lib/dasboard_url.rb
  def create
    begin
     errors = []
     query_arr = []
     errors << "Financial Institution id must be present in json" if params["dashboard_url"]["FinancialInstitutionId"].blank?
     @financial_institution_id = FinancialInstitution.where(name: params["dashboard_url"]["FinancialInstitutionId"], vendor_id: current_vendor.id).first_or_create.id
     if params["dashboard_url"]["Accounts"].is_a? Array
       @checking_accounts =  params["dashboard_url"]["Accounts"].map{|l| l["AccountNumber"] if l["AccountType"] == 'checking'}.compact
       @savings_accounts  =  params["dashboard_url"]["Accounts"].map{|l| l["AccountNumber"] if l["AccountType"] == 'savings'}.compact
       if @checking_accounts.present? && @savings_accounts.present?
         @checking_accounts.map{|ca| query_arr << "checking[]=#{ca}"}
         @savings_accounts.map{ |sa| query_arr << "savings[]=#{sa}"}
       else
        errors << "Checking account information must be present in json." if @checking_accounts.blank?
        errors << "Savings account information must be present in json."   if @savings_accounts.blank?
       end
     else
       errors << "Checking and Savings account information must be present in json."
     end
     @bank_user_id      =  params["dashboard_url"]["CustomerId"]
     errors << "Customer id must be present in json." if @bank_user_id.blank?
     @vendor_user_key = User.where(bank_user_id: @bank_user_id).first.try(:vendor_user_key).try(:key)
     if @vendor_user_key.blank?
        @vendor_user_key = VendorUserKey.create(vendor_id: current_vendor.id).key
     end
     if errors.present?
      raise RuntimeError.new(errors) 
     else
      query_arr << "financial_institution_id=#{@financial_institution_id}"
      query_arr << "bank_user_id=#{@bank_user_id}"
      query_string = query_arr.join("&")
      status = :ok
      resp = {url: "https://#{current_vendor.name}.monotto.com/#{@vendor_user_key}?#{query_string}"}
     end
    rescue RuntimeError => e
     resp = {error: "JSON malformed.", reason: JSON.parse(e.to_s)}
     status = :bad_request
    end
    json_response(resp, nil, status)
  end
end


