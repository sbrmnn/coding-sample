class AddIndexGoalsUnique < ActiveRecord::Migration[5.0]
  def change
  	add_index(:goals, [:user_id, :priority], unique: true)
  end
end
