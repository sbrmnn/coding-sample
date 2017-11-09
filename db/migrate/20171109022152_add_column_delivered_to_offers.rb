class AddColumnDeliveredToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :delivered, :integer, default: 0
  end
end
