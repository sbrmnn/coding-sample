SELECT
  offers.id AS offer_id,
  COUNT(messages)  AS delivered,
  coalesce(SUM(messages.clicks), 0)       AS click_through
FROM
  offers
  LEFT JOIN messages
    ON messages.message_obj_id = offers.id
    AND messages.message_obj_type = 'Offer'
GROUP BY
  offers.id