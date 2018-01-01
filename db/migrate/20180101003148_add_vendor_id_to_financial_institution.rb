class AddVendorIdToFinancialInstitution < ActiveRecord::Migration[5.0]
  def change
    add_column :financial_institutions, :vendor_id, :integer
  end
end
