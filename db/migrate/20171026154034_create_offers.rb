class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.belongs_to :xref_goal_type
      t.belongs_to :financial_institution
      t.belongs_to :ad
      t.string :name, null: false
      t.string :condition, null: false
      t.string :symbol, :limit => 2, null: false
      t.decimal :value, precision: 10, scale: 2, null: false
      t.timestamps
    end
    add_foreign_key :offers, :financial_institutions
    add_foreign_key :offers, :ads
  end
end
