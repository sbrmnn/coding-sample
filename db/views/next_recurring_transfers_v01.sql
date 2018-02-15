WITH last_dt_table AS (
SELECT rule_id, max(t.created_at) as last_dt from transfers t, recurring_transfer_rules r where t.status = 'successful' and t.rule_id= r.id and r.deleted_at is null group by rule_id),
all_rules AS (select r.id, r.goal_id, r.repeats, r.frequency, r.start_dt from recurring_transfer_rules r, goals g where g.id = r.goal_id and r.deleted_at is null)
select a.id as rule_id, a.goal_id, a.repeats, CASE WHEN l.last_dt is null THEN a.start_dt WHEN l.last_dt > start_dt THEN l.last_dt ELSE a.start_dt END + (a.repeats || a.frequency)::interval as next_trasnfer from all_rules a LEFT JOIN last_dt_table l ON l.rule_id = a.id
