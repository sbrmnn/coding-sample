class Vendors::Users::DashboardUrlsController < Vendors::ApplicationController
  # TODO: cut down create action code and migrate code to lib/dasboard_url.rb
  def create
    begin
     url = DashboardUrlBuilder.new(current_vendor.id).consume_json(params[:dashboard_url]).get
     resp = {url: url}
    rescue RuntimeError => e
     resp = {error: "JSON malformed.", reason: JSON.parse(e.to_s)}
     status = :bad_request
    end
    json_response(resp, nil, status)
  end

  private

  def bank_user_id
    params["dashboard_url"]["CustomerId"]
  end

  def financial_institution_name
    params["dashboard_url"]["FinancialInstitutionId"]
  end

  def accounts
   if params["dashboard_url"]["Accounts"].is_a? Array
     params["dashboard_url"]["Accounts"].map{|l| l.permit("AccountNumber", "AccountType")}
   else
     nil
   end
  end
end


