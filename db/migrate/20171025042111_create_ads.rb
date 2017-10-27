class CreateAds < ActiveRecord::Migration[5.0]
  def change
    create_table :ads do |t|
      t.belongs_to :financial_institution
      t.string :header, null: false
      t.string :body, null: false
      t.string :link, null: false
      t.string :image
      t.timestamps
    end
    add_foreign_key :ads, :financial_institutions
  end
end
