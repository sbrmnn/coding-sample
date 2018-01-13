SELECT
  financial_institutions.id AS financial_institution_id,
  coalesce(SUM(transfers.amount), 0) AS thirty_day_savings
FROM
  financial_institutions
  LEFT JOIN users 
    ON users.financial_institution_id = financial_institutions.id 
  LEFT JOIN transfers 
    ON transfers.user_id = users.id 
  WHERE transfers.status = 'successful' AND transfers.end_date < now()
GROUP BY 1


