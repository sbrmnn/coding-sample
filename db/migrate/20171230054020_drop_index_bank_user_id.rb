class DropIndexBankUserId < ActiveRecord::Migration[5.0]
  def change
  	remove_index(:users, column: :bank_user_id)
  end
end
