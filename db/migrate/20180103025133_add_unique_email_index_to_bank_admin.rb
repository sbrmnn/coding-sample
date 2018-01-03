class AddUniqueEmailIndexToBankAdmin < ActiveRecord::Migration[5.0]
  def change
    remove_index(:bank_admins, [:financial_institution_id, :email])
    add_index(:bank_admins, :email, unique: true)
  end
end
