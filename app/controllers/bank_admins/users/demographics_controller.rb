class BankAdmins::Users::DemographicsController < BankAdmins::ApplicationController
  before_action :find_user

  def index
    @demographics = @user.demographics.where(demographic_params)
    json_response(@demographics)
  end

  def show
    @demographic = @user.demographics.find_by(id: params[:id])
    json_response(@demographic)
  end

  def create
    @demographics = @user.demographics
    @demographic =  Demographic.new(demographic_params)
    @demographics << @demographic
    json_response(@demographic)
  end

  def update
    @demographic = @user.demographics.try{ |obj| obj.find_by(:id=> params[:id])}
    if @demographic
      @demographic.update_attributes(demographic_params) 
    end 
    json_response(@demographic)
  end

  def destroy
    @demographic = @user.demographics.try{ |obj| obj.where(:id=> params[:id]).first }
    if @demographic
      @demographic.destroy
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
