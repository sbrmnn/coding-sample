SELECT
  xref_goal_types.id          AS xref_goal_type_id,
  COUNT(goals)                AS total_num_of_goals
FROM
  xref_goal_types
  LEFT JOIN goals 
    ON goals.xref_goal_type_id    = xref_goal_type_id
GROUP BY 1