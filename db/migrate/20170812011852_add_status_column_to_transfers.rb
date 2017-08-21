class AddStatusColumnToTransfers < ActiveRecord::Migration[5.0]
  def change
    add_column :transfers, :status, "status", index: true
  end
end
