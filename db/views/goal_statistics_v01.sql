SELECT
 goals.id AS goal_id,
 (balance*100/target_amount) as percent_saved
FROM 
 goals 