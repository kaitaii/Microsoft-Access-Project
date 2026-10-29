SELECT Authors.[First Name], Authors.[Last Name], Authors.[Author ID] AS Authors_not_owned INTO Author_not_owned
FROM Authors
WHERE (((Authors.[Author ID]) Not In (SELECT authorid FROM authorowned)))
ORDER BY [First Name];
