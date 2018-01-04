class AddIndexProductIdToOffers < ActiveRecord::Migration[5.0]
  def change
  	 add_index(:offers, :product_id)
  end
end
