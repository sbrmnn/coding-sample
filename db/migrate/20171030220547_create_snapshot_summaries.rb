class CreateSnapshotSummaries < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE VIEW snapshot_summaries AS
        SELECT
          financial_institutions.id AS financial_institution_id,
          coalesce(AVG(goals.collection), 0)       AS average_user_collection,
          coalesce(SUM(goals.collection), 0)       AS sum_collection,
          coalesce(SUM(messages.clicks) , 0)       AS sum_message_clicks,
          COUNT(messages)                          AS total_messages,
          COUNT(financial_institution_users)       AS total_users
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
    execute "DROP VIEW snapshot_summaries"
  end
end
