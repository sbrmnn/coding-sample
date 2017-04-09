class AddIndexNameForGoals < ActiveRecord::Migration[5.0]
  def change
  	add_index :goals, [:user_id, :name], unique: true
  end
end
