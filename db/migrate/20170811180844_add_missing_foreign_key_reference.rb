class AddMissingForeignKeyReference < ActiveRecord::Migration[5.0]
  def change
  	add_foreign_key :bank_admins, :financial_institutions
  	add_foreign_key :demographics, :users
  	add_foreign_key :goals, :users
  	add_foreign_key :transfers, :users
  	add_foreign_key :users, :financial_institutions
  end
end
