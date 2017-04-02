class CreateGoals < ActiveRecord::Migration[5.0]
  def change
    create_table :goals do |t|
      t.belongs_to :user, null: false
      t.string :name, null: false
      t.integer :amount, null: false
      t.integer :completion, null: false
      t.integer :priority, null: false
      t.timestamps
    end
  end
end
