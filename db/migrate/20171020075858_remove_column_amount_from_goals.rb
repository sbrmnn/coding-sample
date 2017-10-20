class RemoveColumnAmountFromGoals < ActiveRecord::Migration[5.0]
  def change
    remove_column :goals, :amount, :integer
  end
end
