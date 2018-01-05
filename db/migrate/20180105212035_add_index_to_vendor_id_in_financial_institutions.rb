class AddIndexToVendorIdInFinancialInstitutions < ActiveRecord::Migration[5.0]
  def change
  	add_index(:financial_institutions, :vendor_id)
  end
end
