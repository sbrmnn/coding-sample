class IndexBankUserIdWithFinancialInstitutionId < ActiveRecord::Migration[5.0]
  def change
  	add_index(:users, [:bank_user_id, :financial_institution_id], unique: true)
  end
end
