class CreateRecurringTransferRules < ActiveRecord::Migration[5.0]
  def up
   execute <<-SQL
      CREATE TABLE recurring_transfer_rules( id integer PRIMARY KEY, goals_id integer NOT NULL, amount VARCHAR (50) NOT NULL, frequency VARCHAR(10) CONSTRAINT check_frequency CHECK (frequency in ('day', 'week', 'month')), repeats integer CONSTRAINT check_repeat CHECK ( repeats in (1,2,3)), start_dt timestamp NOT NULL, end_dt timestamp NOT NULL, deleted_at timestamp );
   SQL
  end

  def down
    execute <<-SQL
      DROP TABLE recurring_transfer_rules
    SQL
  end
end
