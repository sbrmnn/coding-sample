class CreateXrefGoalTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :xref_goal_types do |t|
      t.string :type
      t.string :name
      t.string :department
      t.timestamps
    end
  end
end
