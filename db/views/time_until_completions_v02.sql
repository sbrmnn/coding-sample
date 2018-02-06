with
prev_transfers_tb as (
        select transfers_in.user_id, avg(transfers_in.diff) avg_days, avg(transfers_in.transfer_amount_attempted) avg_amount
        FROM (
                SELECT DISTINCT(user_id) 
                FROM transfers) transfer_out,
        LATERAL (
                SELECT user_id, updated_at, updated_at::date - lag(updated_at::date) over (order by updated_at) as diff, transfer_amount_attempted 
                FROM transfers WHERE end_date <> 'infinity' and status='successful' and transfers.user_id = transfer_out.user_id order by updated_at desc limit 3) transfers_in
        GROUP BY transfers_in.user_id
),
amount_to_complete as (
        SELECT user_id, xref_goal_type_id, priority, rank() over(partition by user_id order by priority) as rank_priority, target_amount-balance as remaining 
        FROM goals 
        WHERE target_amount-balance > 0
        
)
select p.user_id, a.xref_goal_type_id, a.priority, round(p.avg_days*a.remaining/p.avg_amount,2) as days_until_completion from prev_transfers_tb p, amount_to_complete a where p.user_id = a.user_id;
