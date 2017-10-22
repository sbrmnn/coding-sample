class RemoveColumnTypeFromGoals < ActiveRecord::Migration[5.0]
  def change
    remove_column :goals, :type, :string
  end
end
