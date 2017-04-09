class AddDefaultToCompletionInGoalsTable < ActiveRecord::Migration[5.0]
  def change
  	change_column :goals, :completion, :integer, :default => 0
  end
end
