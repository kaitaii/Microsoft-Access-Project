SELECT * INTO Books_with_world
FROM Books
WHERE (((Books.[Title]) Like '*world*'))
ORDER BY Books.ISBN;
