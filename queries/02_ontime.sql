SELECT 0 AS Initial_Fine, * INTO 1_ontime
FROM 1_days
WHERE ((([1_days].[Days_borrowed])<=28));
