class CreateBankAdminsFinancialInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_admins_financial_institutions do |t|

      t.timestamps
    end
  end
end
