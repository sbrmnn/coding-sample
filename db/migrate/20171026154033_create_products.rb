class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.belongs_to :financial_institution
      t.string :name
      t.timestamps
    end
    add_foreign_key :products, :financial_institutions
  end
end
