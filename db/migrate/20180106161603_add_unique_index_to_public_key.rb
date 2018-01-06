class AddUniqueIndexToPublicKey < ActiveRecord::Migration[5.0]
  def change
  	add_index(:vendors, :public_key, unique: true)
  end
end
