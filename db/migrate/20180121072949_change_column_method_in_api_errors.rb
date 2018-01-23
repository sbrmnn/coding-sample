class ChangeColumnMethodInApiErrors < ActiveRecord::Migration[5.0]
  def change
  	rename_column :api_errors, :method, :function
  end
end
