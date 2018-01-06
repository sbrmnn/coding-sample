SELECT v.name, u.financial_institution_id, u.id user_id 
FROM vendors v, financial_institutions f, users u 
WHERE v.id = f.vendor_id AND f.id = u.financial_institution_id