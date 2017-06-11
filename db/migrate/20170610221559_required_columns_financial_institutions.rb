class RequiredColumnsFinancialInstitutions < ActiveRecord::Migration[5.0]
  def change
  	change_column_null :financial_institutions, :name, false
  	change_column_null :financial_institutions, :location, false
  end
end
