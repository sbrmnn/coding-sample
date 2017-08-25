class ChangeEndDateType < ActiveRecord::Migration[5.0]
  def change
  	change_column :transfers, :end_date , :timestamp
  end
end
