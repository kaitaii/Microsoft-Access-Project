SELECT Nz(DateReturned,#11/1/2018#) AS Returned, DateDiff("d",DateBorrowed,Returned) AS Days_borrowed, * INTO [days borrowed]
FROM [Checkout Log];
