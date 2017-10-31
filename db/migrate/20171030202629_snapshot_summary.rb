class SnapshotSummary < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE VIEW snapshot_summary AS
        SELECT
          financial_institutions.id AS financial_institution_id,
          AVG(goals.balance) AS average_user_balance,
          SUM(goals.balance) AS sum_balance,
          SUM(messages.clicks)  AS sum_message_clicks,
          COUNT(messages)       as total_messages
        FROM
          financial_institutions
          LEFT JOIN users AS financial_institution_users
            ON financial_institution_users.financial_institution_id = financial_institutions.id
          LEFT JOIN goals 
            ON goals.user_id    = financial_institution_users.id
          LEFT JOIN messages
            ON messages.user_id = financial_institution_users.id
        GROUP BY
          financial_institutions.id
    SQL
  end

  def down
    execute "DROP VIEW snapshot_summary"
  end
end
