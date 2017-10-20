class AddColumnTargetAmountToGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :goals, :target_amount, :decimal, default: 0, precision: 10, scale: 2, null: false
  end
end
