class Vendors::Users::DashboardUrlsController < Vendors::ApplicationController
  def create
    begin
     url = DashboardUrlBuilder.new(current_vendor.id, params[:dashboard_url]).build.get
     resp = {url: url}
    rescue RuntimeError => e
     resp = {error: "JSON malformed.", reason: JSON.parse(e.to_s)}
     status = :bad_request
    end
    json_response(resp, nil, status)
  end
end


