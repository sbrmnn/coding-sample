class Vendors::Users::MessagesController < ApplicationController
  skip_before_action :require_vendor_login
end
