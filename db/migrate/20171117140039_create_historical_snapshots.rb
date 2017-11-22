class CreateHistoricalSnapshots < ActiveRecord::Migration[5.0]
  def change
    create_table :historical_snapshots do |t|
      t.belongs_to :financial_institution
      t.decimal    :average_user_balance
      t.decimal    :sum_balance
      t.integer    :sum_message_clicks
      t.integer    :total_messages
      t.integer    :total_users
      t.timestamps
    end
  end
end


