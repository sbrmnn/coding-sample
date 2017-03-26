class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.timestamps
    end
  end
end
