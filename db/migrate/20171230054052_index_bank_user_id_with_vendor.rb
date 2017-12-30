class IndexBankUserIdWithVendor < ActiveRecord::Migration[5.0]
  def change
    add_index(:users, [:bank_user_id, :vendor_id], unique: true)
  end
end
