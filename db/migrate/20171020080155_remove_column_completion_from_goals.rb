class RemoveColumnCompletionFromGoals < ActiveRecord::Migration[5.0]
  def change
    remove_column :goals, :completion, :integer
  end
end
