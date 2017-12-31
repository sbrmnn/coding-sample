class DropIndexUsersOnFinancialInstitutionIdAndBankUserIdFromUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_index(:users, column: [:financial_institution_id, :bank_user_id])
  end
end
