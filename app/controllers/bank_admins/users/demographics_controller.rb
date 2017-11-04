class BankAdmins::Users::DemographicsController < BankAdmins::ApplicationController
  before_action :find_user

  def index
    @demographics = @user.try(:demographics).where(demographic_params)
    json_response(@demographics)
  end

  def show
    @demographic = @user.try(:demographics).find_by(id: params[:id])
    if @demographic
      status = :ok
    else
      status = :not_found
    end
    json_response(@demographic)
  end

  def create
    @demographics = @user.try(:demographics)
    @demographic =  Demographic.new(demographic_params)
    @demographics << @demographic
    status = @demographic.errors.any? ? :unprocessable_entity :  :created
    json_response(@demographic)
  end

  def update
    @demographic = @user.try(:demographics).try{ |obj| obj.find_by(:id=> params[:id])}
    if @demographic
      @demographic.update_attributes(demographic_params) 
      status = @demographic.errors.any? ? :unprocessable_entity :  :ok
    else
      status = :not_found
    end 
    json_response(@demographic)
  end

  def destroy
    @demographic = @user.try(:demographics).try{ |obj| obj.where(:id=> params[:id]).first }
    if @demographic
      @demographic.destroy
      status = :ok
    else
      status = :not_found
    end
    json_response(@demographic) 
  end

  protected

  def demographic_params
    if params[:demographic].blank?
      {}
    else
     params.require(:demographic).permit(:key, :value)
    end
  end
end
