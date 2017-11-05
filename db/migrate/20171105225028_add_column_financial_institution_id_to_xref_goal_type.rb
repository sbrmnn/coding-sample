class AddColumnFinancialInstitutionIdToXrefGoalType < ActiveRecord::Migration[5.0]
  def change
    add_column :xref_goal_types, :financial_institution_id, :integer
  end
end
