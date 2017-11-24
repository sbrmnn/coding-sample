class BankAdmins::XrefGoalTypesController < BankAdmins::ApplicationController
   
   def index
     @xref_goal_types = current_bank_admin.xref_goal_types.where(xref_goal_type_params)
     json_response(@xref_goal_types)
   end

   def create
     @xref_goal_type = XrefGoalType.new(xref_goal_type_params)
     current_bank_admin.financial_institution.xref_goal_types << @xref_goal_type
     json_response(@xref_goal_type)
   end
  
   protected
   
   def xref_goal_type_params
    if params[:xref_goal_type].blank?
      {}
    else
      params.require(:xref_goal_type).permit(:code, :name, :department)
    end
   end
end
