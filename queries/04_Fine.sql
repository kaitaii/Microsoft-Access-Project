SELECT [1_overdue].*, Books.Title, Books.Edition, Books.[Author ID], Books.Cost AS Fine INTO 1_fine
FROM Books INNER JOIN 1_overdue ON Books.ISBN = [1_overdue].ISBN;
