class ChangeColumnMaxTransferAmountInFinancialInstitutions < ActiveRecord::Migration[5.0]
  def change
    change_column :financial_institutions, :max_transfer_amount, :integer
  end
end
