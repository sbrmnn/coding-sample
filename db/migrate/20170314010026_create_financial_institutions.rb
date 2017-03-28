class CreateFinancialInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :financial_institutions do |t|
      t.string :name
      t.string :location
      t.string :core
      t.string :web
      t.string :mobile
      t.text :notes
      t.string :relationship_manager
      t.integer :max_transfer
      t.boolean :transfers_active
      t.timestamps
    end
  end
end
