class GetRidOfNonNullConstraintOnLocation < ActiveRecord::Migration[5.0]
  def change
  	change_column_null :financial_institutions, :location, true
  end
end
