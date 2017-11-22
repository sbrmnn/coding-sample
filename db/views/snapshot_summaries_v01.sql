SELECT
  financial_institutions.id AS financial_institution_id,
  coalesce(AVG(goals.balance), 0)          AS average_user_balance,
  coalesce(SUM(goals.balance), 0)          AS sum_balance,
  coalesce(SUM(messages.clicks) , 0)       AS sum_message_clicks,
  COUNT(messages)                          AS total_messages,
  COUNT(financial_institution_users)       AS total_users,
  COUNT(last_seven_days_user_signup)       AS last_seven_days_user_signup
FROM
  financial_institutions
  LEFT JOIN users AS financial_institution_users
    ON financial_institution_users.financial_institution_id = financial_institutions.id
  LEFT JOIN goals 
    ON goals.user_id    = financial_institution_users.id
  LEFT JOIN messages
    ON messages.user_id = financial_institution_users.id
    AND messages.message_obj_type = 'Offer'
  LEFT JOIN users AS last_seven_days_user_signup
    ON last_seven_days_user_signup.financial_institution_id = financial_institutions.id
    AND last_seven_days_user_signup.created_at > now()::date - 7
GROUP BY 1