class Vendors::UsersController < Vendors::ApplicationController
   def index
     @users = current_vendor.users
     json_response(@users)
   end
end
