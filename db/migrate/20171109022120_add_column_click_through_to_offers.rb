class AddColumnClickThroughToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :click_through, :integer, default: 0
  end
end
