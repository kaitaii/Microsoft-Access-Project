SELECT [1_fine].[Author ID], Count(*) AS Popularity INTO Popularity
FROM 1_fine
GROUP BY [1_fine].[Author ID]
ORDER BY Count(*) DESC;
