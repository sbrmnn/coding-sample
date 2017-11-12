class RemoveNameFromOffer < ActiveRecord::Migration[5.0]
  def change
  	remove_column :offers, :name, :string
  end
end
