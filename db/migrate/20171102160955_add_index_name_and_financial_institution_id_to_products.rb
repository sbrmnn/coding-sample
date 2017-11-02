class AddIndexNameAndFinancialInstitutionIdToProducts < ActiveRecord::Migration[5.0]
  def change
  	add_index :products, [:name, :financial_institution_id], unique: true
  end
end
