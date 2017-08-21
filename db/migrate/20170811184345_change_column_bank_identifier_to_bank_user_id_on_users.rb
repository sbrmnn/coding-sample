class ChangeColumnBankIdentifierToBankUserIdOnUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :bank_identifier, :bank_user_id
  end
end
