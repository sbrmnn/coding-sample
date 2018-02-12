 WITH prev_transfers_tb AS (
         SELECT transfers_in.user_id, transfer_out.amount,
            avg(transfers_in.diff) AS avg_days,
            avg(transfers_in.transfer_amount_attempted) AS avg_amount
           FROM ( select distinct ON(user_id) user_id, amount from transfers order by user_id, id desc) transfer_out,
            LATERAL ( SELECT transfers.user_id,
                    transfers.updated_at,
                    transfers.updated_at::date - lag(transfers.updated_at::date) OVER (ORDER BY transfers.updated_at) AS diff,
                    transfers.transfer_amount_attempted
                   FROM transfers
                   WHERE transfers.user_id = transfer_out.user_id
                  ORDER BY transfers.updated_at DESC
                 LIMIT 3) transfers_in
          GROUP BY transfers_in.user_id, transfer_out.amount
        ), amount_to_complete AS (
         SELECT goals.id,
            goals.user_id,
            goals.xref_goal_type_id,
            goals.priority,
            rank() OVER (PARTITION BY goals.user_id ORDER BY goals.priority) AS rank_priority,
            goals.target_amount - goals.balance AS remaining
           FROM goals
          WHERE (goals.target_amount - goals.balance) > 0::numeric
        )
    SELECT a.id as goal_id,
    p.user_id,
    a.xref_goal_type_id,
    a.priority,
    p.amount,
    CASE
        WHEN p.avg_days is null THEN 3 ELSE p.avg_days
    END AS avg_days,
    CASE
        WHEN p.avg_amount is NULL THEN
                                       CASE
                                           WHEN p.amount > 50000 THEN 10
                                           WHEN p.amount > 10000 THEN 8
                                           WHEN p.amount > 5000 THEN 6
                                           WHEN p.amount > 500 THEN 4
                                           ELSE 0
                                        END
                                    ELSE p.avg_amount
    END AS avg_amount                                       
    FROM prev_transfers_tb p,
    amount_to_complete a
    WHERE p.user_id = a.user_id;