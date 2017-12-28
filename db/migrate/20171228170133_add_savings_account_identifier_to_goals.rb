class AddSavingsAccountIdentifierToGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :goals, :savings_account_identifier, :string
  end
end
