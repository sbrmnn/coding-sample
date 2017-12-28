class AddSavingsAccountIdentifierToGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :goals, :default_savings_account_identifier, :string
  end
end
