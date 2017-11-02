class AddProductIdToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :product_id, :integer
  end
end
