class DropIndexBankUserId < ActiveRecord::Migration[5.0]
  def change
  	remove_index(:users, :name => 'index_users_on_bank_user_id')
  end
end
