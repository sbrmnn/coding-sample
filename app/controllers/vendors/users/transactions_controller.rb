class Vendors::Users::TransactionsController < Vendors::ApplicationController
  skip_before_action :require_vendor_login
end
