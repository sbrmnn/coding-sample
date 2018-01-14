class ChangePublicKeyToKey < ActiveRecord::Migration[5.0]
  def change
  	rename_column :vendors, :public_key, :key
  end
end
