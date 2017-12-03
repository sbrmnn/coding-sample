class AddColumnLastSevenDaysUserSignupToHistoricalSnapshots < ActiveRecord::Migration[5.0]
  def change
    add_column :historical_snapshots, :last_seven_days_user_signup, :integer
  end
end
