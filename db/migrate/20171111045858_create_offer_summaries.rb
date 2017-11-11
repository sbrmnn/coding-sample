class CreateOfferSummaries < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE VIEW offer_summaries AS
        SELECT
          offers.id AS offer_id,
          COUNT(messages)  AS delivered
        FROM
          offers
          LEFT JOIN messages
            ON messages.message_obj_id = offers.id
            AND messages.message_obj_type = 'Offer'
        GROUP BY
          offers.id
    SQL
  end

  def down
    execute "DROP VIEW offer_summaries"
  end
end
