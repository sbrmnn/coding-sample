class DropIndexUsersOnFinancialInstitutionIdAndBankUserIdFromUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_index(:users, :name => 'index_users_on_financial_institution_id_and_bank_user_id')
  end
end
