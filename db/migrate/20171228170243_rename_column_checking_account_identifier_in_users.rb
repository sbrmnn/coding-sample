class RenameColumnCheckingAccountIdentifierInUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :savings_account_identifier, :default_savings_account_identifier
  end
end
