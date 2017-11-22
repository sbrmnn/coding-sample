SELECT
  financial_institutions.id AS financial_institution_id,
  coalesce(MAX(hs.sum_balance) - MIN(hs.sum_balance),0) AS thirty_day_savings
FROM
  financial_institutions
  LEFT JOIN historical_snapshots AS hs
    ON hs.financial_institution_id  = financial_institutions.id
    AND  hs.created_at > now()::date - 31
GROUP BY 1