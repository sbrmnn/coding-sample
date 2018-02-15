class ChangeConstraintCheckFrequency < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE recurring_transfer_rules
           DROP CONSTRAINT check_repeat,
           ADD CONSTRAINT check_repeat CHECK ((repeats = ANY (ARRAY[0, 1, 2, 3])))
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE recurring_transfer_rules
            DROP CONSTRAINT check_repeat,
            ADD CONSTRAINT check_repeat CHECK ((repeats = ANY (ARRAY[1, 2, 3])))
        SQL
      end
    end
  end
end
