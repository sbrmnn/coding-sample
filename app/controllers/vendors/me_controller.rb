class Vendors::MeController < Vendors::ApplicationController
  def show
    json_response(current_vendor)
  end
end
