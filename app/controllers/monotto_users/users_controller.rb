class MonottoUsers::UsersController < MonottoUsers::ApplicationController
  
  def index
    @users = User.all.where(params[:user])
    if @users.present?
      status = :ok
    else
      status = :not_found
    end
    json_response(@users)
  end

  def create
    @user = User.create(user_params)
    if @user.errors.any?
      status = :unprocessable_entity
    else
      status = :created
    end
    json_response(@user)
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user
      status = :ok
    else
      status = :not_found
    end
    json_response(@user)
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.present?
      @user.update_attributes(user_params)
      status = @user.errors.any? ? :unprocessable_entity : :ok
    else
      status = :not_found
    end
    json_response(@user)
  end

  def destroy
    @user = User.find_by(id: params[:id]).try(:destroy)
    if @user.present?
      status = :ok
    else
      status = :not_found
    end
    json_response(@user) 
  end

   protected
   
   def user_params
     params.require(:user).permit(:bank_user_id, :savings_account_identifier, :checking_account_identifier,
                                  :transfers_active, :safety_net_active, :max_transfer_amount, :financial_institution_id)
   end
end
