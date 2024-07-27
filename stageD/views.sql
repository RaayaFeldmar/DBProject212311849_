-- create a view of all details of books in the library
CREATE OR REPLACE VIEW all_existings_books_details AS
SELECT bookId, title, bookLanguage, pages, categoryName, 
       author, publisherName, locationC, 
       count(*) AS AMOUNT_OF_COPIES, 
       C.AVAILABLES AS AMOUNT_OF_AVAILABLE_COPIES
FROM Book NATURAL JOIN
     Book_Author NATURAL JOIN
     Bookcategory NATURAL JOIN
     Bookpublisher NATURAL JOIN
     Bookcopy NATURAL JOIN
     (SELECT bookId, SUM(available) AS availables
     FROM Bookcopy
     GROUP BY bookId) C   
GROUP BY bookId, title, bookLanguage, pages, categoryName, author, publisherName, locationC, C.AVAILABLES;

SELECT * FROM all_existings_books_details

--select books by category and language
SELECT categoryName, title, bookLanguage, AMOUNT_OF_AVAILABLE_COPIES, locationC
FROM all_existings_books_details
WHERE categoryName IN 
      (&<NAME="category" 
         LIST="select distinct categoryName from all_existings_books_details" 
         MULTISELECT="yes" 
         TYPE="string" 
         RESTRICTED="yes">)
&<NAME="language" 
  MULTISELECT="yes" 
  TYPE="string" 
  LIST="select distinct bookLanguage from all_existings_books_details"  
  RESTRICTED="yes" 
  TYPE="string" 
  PREFIX="and bookLanguage in (" SUFFIX=")">
GROUP BY bookId, title, bookLanguage, locationC, categoryName, AMOUNT_OF_AVAILABLE_COPIES
ORDER BY categoryName;

--select books that have no copies available
SELECT bookId, title, bookLanguage, categoryName, AMOUNT_OF_COPIES AS AMOUNT_OF_NOT_AVAILABLE_COPIES
FROM all_existings_books_details
WHERE AMOUNT_OF_AVAILABLE_COPIES = 0
GROUP BY bookId, title, bookLanguage, categoryName, AMOUNT_OF_COPIES
ORDER BY bookId;

--drop the view
DROP VIEW all_existings_books_details;

--create view
CREATE OR REPLACE VIEW books_details_and_related_orders AS
SELECT Book.Bookid, title, bookLanguage, availables AS AMOUNT_OF_AVAILABLE_COPIES , readerOrderDate, clientId, AMOUNT_OF_ACTIVE_ORDERS 
FROM Book JOIN
     (SELECT bookId, SUM(available) AS availables
     FROM Bookcopy
     GROUP BY bookId) C ON Book.Bookid = C.BOOKID
     LEFT JOIN Bookordering ON Book.bookId = Bookordering.Bookid 
     LEFT JOIN
     (SELECT bookId, COUNT(*) AS AMOUNT_OF_ACTIVE_ORDERS
     FROM Ordering NATURAL JOIN Bookordering
     WHERE status IN('Confirmed', 'Delivered', 'Shipped')
     GROUP BY bookId) O ON Bookordering.Bookid = O.BOOKID;

--select all orders of specific client
SELECT *
FROM books_details_and_related_orders
WHERE clientId = &<NAME= "clientID" REQUIRED=TRUE>;

--select all books that have no copies available and display active orders of them
SELECT bookId, title, NVL(AMOUNT_OF_ACTIVE_ORDERS, 0) AS AMOUNT_OF_ACTIVE_ORDERS
FROM books_details_and_related_orders
WHERE AMOUNT_OF_AVAILABLE_COPIES = 0
GROUP BY bookId, title, AMOUNT_OF_ACTIVE_ORDERS
ORDER BY bookId;
