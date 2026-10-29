SELECT [1_ontime].*, Books.Title, Books.Edition, Books.[Author ID], 0 AS Fine INTO 2_fine
FROM 1_ontime INNER JOIN Books ON [1_ontime].ISBN = Books.ISBN;
