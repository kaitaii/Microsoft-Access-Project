SELECT Books.Title, Books.Edition, Books.[Author ID], Nz(ISBN,'ISBN Missing') AS Complete_ISBN INTO ISBN_complete
FROM Books;
