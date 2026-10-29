SELECT Days_borrowed*0.05 AS Initial_Fine, * INTO 1_overdue
FROM 1_days
WHERE ((([1_days].[Days_borrowed])>28));
