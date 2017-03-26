class CreateDemographics < ActiveRecord::Migration[5.0]
  def change
    create_table :demographics do |t|
      t.string :key
      t.string :value
      t.belongs_to :user
      t.timestamps
    end
  end
end
