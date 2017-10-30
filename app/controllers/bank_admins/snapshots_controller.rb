class BankAdmins::SnapshotsController < BankAdmins::ApplicationController 
  def index
  	user_ids = current_bank_admin.users.pluck(:id)
  	goals = Goal.where(user_id: user_ids)
  	messages = Message.where(user_id: user_ids)
  	@active_users = user_ids.count
  	@saved_this_month = goals.sum(:collection)
  	@average_saved_per_user = goals.average(:collection)
    @offers_shown = messages.count
    @offers_clicked = messages.sum(:clicks)
  end
end
