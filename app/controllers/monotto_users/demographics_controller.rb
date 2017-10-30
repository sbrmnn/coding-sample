class MonottoUsers::DemographicsController < MonottoUsers::ApplicationController
  
  def index
    @demographics = Demographic.all.where(demographic_params)
    if @demographics.present?
      status = :ok
    else
      status = :not_found
    end
    json_response(@demographics, status)
  end

  def create
    @demographic = Demographic.create(demographic_params)
    if @demographic.errors.any?
      status = :unprocessable_entity
    else
      status = :created
    end
    json_response(@demographic, status)
  end

  def show
    @demographic = Demographic.find_by(id: params[:id])
    if @demographic
      status = @demographic.errors.any? ? :unprocessable_entity : :ok
    else
      status = :not_found
    end
    json_response(@demographic, status)
  end

  def update
    @demographic = Demographic.find_by(id: params[:id])
    if @demographic
      @demographic.update_attributes(demographic_params)
      status = :ok
    else
      status = :not_found
    end
    json_response(@demographic, status)
  end

  def destroy
   @demographic = Demographic.find_by(id: params[:id]).try(:destroy)
   if @demographic.present?
     status = :ok
   else
     status = :not_found
   end
   json_response(@demographic, status) 
  end

  protected

  def demographic_params
    if params[:demographic].nil?
      {}
    else
      params.require(:demographic).permit(:user_id, :key, :value)
    end
  end
end
