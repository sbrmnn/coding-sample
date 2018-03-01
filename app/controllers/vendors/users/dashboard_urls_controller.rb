class Vendors::Users::DashboardUrlsController < Vendors::ApplicationController
  def create
    if JSON::Validator.validate(json_schema, params["dashboard_url"])
     @financial_institution_id = FinancialInstitution.where(name: params["dashboard_url"]["FinancialInstitutionId"], vendor_id: current_vendor.id).first_or_create.id
     @checking_accounts =  params["dashboard_url"]["Accounts"].map{|l| l["AccountNumber"] if l["AccountType"] == 'checking'}.compact
     @savings_accounts  =  params["dashboard_url"]["Accounts"].map{|l| l["AccountNumber"] if l["AccountType"] == 'savings'}.compact
     @bank_user_id      =  params["dashboard_url"]["CustomerId"]
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
     resp = {url: "#{request.env["HTTP_HOST"]}?#{query_string}"}
     status = :ok
   else
    resp = {error: "JSON malformed."}
    status = :bad_request
   end
    json_response(resp, status)
  end

  private

  def json_schema
    {
      "CustomerId": "ucotest",
      "FinancialInstitutionId": "bankjoy",
      "CustomerType": "Consumer",
      "FirstName": "Arun",
      "LastName": "Test",
      "Email": "arun@example.net",
      "Accounts": [
        {
          "AccountNumber": "1234567890",
          "AccountName": "My Share",
          "AvailableAccountBalance": 299,
          "RoutingNumber": "012345678",
          "AccountOwnerType": "Personal",
          "AccountType": "savings"
        },
        {
          "AccountNumber": "0987654321",
          "AccountName": "My other share",
          "AvailableAccountBalance": 212,
          "RoutingNumber": "012345678",
          "AccountOwnerType": "Personal",
          "AccountType": "checking"
        }
      ]
    }
  end
end


