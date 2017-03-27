class BankAdmins::Users::DemographicsController < ApplicationController
   
   def index
     @demographics = current_bank_admin.users.demographics
     json_response(@demographics, :ok)
   end

   def create
     @user_demographics = current_bank_admin.users.where(:id=> params[:user_id]).first.try(:demographics)
     if @user_demographics
        @demographic =  Demographic.new(demographic_params)
        @user_demographics << @demographic
        status = @demographic.errors.any? :unprocessable_entity :  :created
        json_response(@demographic, status)
     else
        json_response("user not found", :not_found)
     end
   end

   def update
     @demographic = current_bank_admin.users
                   .where(:id => params[:user_id])
                   .first.try(:demographics).try{ |obj| obj.where(:id=> params[:id]).first }
     if @demographic
       @demographic.update_attributes(user_params) 
       status = @demographic.errors.any? :unprocessable_entity :  :ok
       json_response(@demographic, status)
     else
      json_response(@demographic, :not_found)
     end 
   end

   def destroy
    
   end

   protected

   def demographic_params
     params.require(:demographic).permit(:key, :value)
   end
end
