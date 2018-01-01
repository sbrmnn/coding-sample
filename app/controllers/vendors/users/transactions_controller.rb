class Vendors::Users::TransactionsController < ApplicationController
  skip_before_action :require_vendor_login
end
