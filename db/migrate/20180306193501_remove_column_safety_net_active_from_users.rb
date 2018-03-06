class RemoveColumnSafetyNetActiveFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :safety_net_active, :boolean
  end
end
