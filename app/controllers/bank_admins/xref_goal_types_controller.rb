class BankAdmins::XrefGoalTypesController < BankAdmins::ApplicationController
   
   def index
     @xref_goal_types = current_bank_admin.xref_goal_types.where(xref_goal_type_params)
     json_response(@xref_goal_types)
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
