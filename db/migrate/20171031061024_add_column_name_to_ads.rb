class AddColumnNameToAds < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :name, :string, null: false
  end
end
