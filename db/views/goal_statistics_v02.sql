SELECT
 goals.id AS goal_id,
 (balance*100/target_amount) as percent_saved,
 (target_amount - balance) as amount_left
FROM 
 goals 