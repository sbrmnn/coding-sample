class BankAdmins::Users::DemographicsController < BankAdmins::ApplicationController
   
   def index
     @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
     @demographics = @user.try(:demographics).select(:id, :key, :value)
     record = @user.blank? ? "user not found" : @demographic
     status = @user.blank? ? :not_found : :ok
     json_response(record, status)
   end

   def create
     @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
     @demographics = @user.try(:demographics)
     if @demographics
       @demographic =  Demographic.new(demographic_params)
       @demographics << @demographic
       record = demographic
       status = @demographic.errors.any? ? :unprocessable_entity :  :created
     else
       record = @user.blank? ? "user not found" : @demographic
       status = :not_found
     end
     json_response(record, status)
   end

   def update
     @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
     @demographic = @user.try(:demographics).try{ |obj| obj.find_by(:id=> params[:id])}
     if @demographic
       @demographic.update_attributes(user_params) 
       record = @demographic
       status = @demographic.errors.any? ? :unprocessable_entity :  :ok
     else
      record = @user.blank? ? "user not found" : @demographic
      status = :not_found
     end 
      json_response(record, :not_found)
   end

   def destroy
     @user = current_bank_admin.users.find_by(:bank_identifier => params[:user_bank_identifier])
     @demographic = @user.try(:demographics).try{ |obj| obj.where(:id=> params[:id]).first }
     if @demographic
       @demographic.destroy 
       record = @demographic
       status = :ok
     else
       record = @user.blank? ? "user not found" : @demographic
       status = :not_found
     end
     json_response(record, status) 
   end

   protected

   def demographic_params
     params.require(:demographic).permit(:key, :value)
   end
end
