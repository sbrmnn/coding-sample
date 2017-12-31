class ChangeEndDateType < ActiveRecord::Migration[5.0]
  def up
    change_column :transfers, :end_date, :timestamp
  end

  def down
    change_column :transfers, :end_date, :date
  end
end
