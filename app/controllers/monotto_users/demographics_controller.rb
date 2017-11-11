class MonottoUsers::DemographicsController < MonottoUsers::ApplicationController
  
  def index
    @demographics = Demographic.all.where(demographic_params)
    json_response(@demographics)
  end

  def create
    @demographic = Demographic.create(demographic_params)
    json_response(@demographic)
  end

  def show
    @demographic = Demographic.find_by(id: params[:id])
    json_response(@demographic)
  end

  def update
    @demographic = Demographic.find_by(id: params[:id])
    if @demographic
      @demographic.update_attributes(demographic_params)
    end
    json_response(@demographic)
  end

  def destroy
   @demographic = Demographic.find_by(id: params[:id]).try(:destroy)
   json_response(@demographic) 
  end

  protected

  def demographic_params
    if params[:demographic].blank?
      {}
    else
      params.require(:demographic).permit(:user_id, :key, :value)
    end
  end
end
