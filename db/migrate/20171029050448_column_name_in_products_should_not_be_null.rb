class ColumnNameInProductsShouldNotBeNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :products, :name, false
  end
end
