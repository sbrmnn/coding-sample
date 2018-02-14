class CreateRecurringTransferRules < ActiveRecord::Migration[5.0]
  def change
    create_table :recurring_transfer_rules do |t|
      t.belongs_to :goal, null: false
      t.string :amount, limit: 50, null: false
      t.string :frequency, limit: 10
      t.integer :repeats
      t.timestamp :start_dt, null: false
      t.timestamp :end_dt, null: false
      t.timestamp :deleted_at
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE recurring_transfer_rules
           ADD CONSTRAINT check_frequency CHECK (((frequency)::text = ANY ((ARRAY['day'::character varying, 'week'::character varying, 'month'::character varying])::text[]))),
           ADD CONSTRAINT check_repeat CHECK ((repeats = ANY (ARRAY[1, 2, 3])))
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE recurring_transfer_rules
            DROP CONSTRAINT check_frequency,
            DROP CONSTRAINT check_repeat
        SQL
      end
     end
  end
end
