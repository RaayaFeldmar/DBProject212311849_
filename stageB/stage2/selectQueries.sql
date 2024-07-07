-- books that all their copies are not available
SELECT categoryname, bookid, title, booklanguage, publishername
FROM book NATURAL JOIN bookcategory NATURAL JOIN bookpublisher NATURAL JOIN (SELECT DISTINCT bookId
                                                                              FROM book
                                                                              WHERE bookId NOT IN (SELECT bookId
                                                                                                  FROM bookcopy
                                                                                                  WHERE available=1))
ORDER BY categoryname,  title;

-- librarians who set more than 2 incorrect due dates
SELECT firstname, lastname, phone, email, mistakes
FROM person JOIN(SELECT librarianid, COUNT(*) AS mistakes
                  FROM (SELECT librarianid, lendingdate, duedate FROM booklending
                        UNION SELECT librarianid, lendingdate, duedate FROM playlending)
                  WHERE duedate> ADD_MONTHS(lendingdate, 2)
                  GROUP BY librarianid
                  HAVING COUNT(*)>1)
             ON personid=librarianid
ORDER BY mistakes DESC, lastname, firstname

-- clients who are holding books or plays whose due date has passed 30 days ago
SELECT firstname, lastname, phone, email, title, duedate, element_type
FROM person JOIN (SELECT clientid, title, duedate, 'book' AS element_type
                 FROM booklending NATURAL JOIN bookcopy NATURAL JOIN book
                 WHERE returndate IS NULL AND SYSDATE>ADD_MONTHS(dueDate, 1)
                 UNION
                 SELECT clientid, playname, duedate, 'game'
                 FROM playlending NATURAL JOIN playcopy NATURAL JOIN play
                 WHERE returndate IS NULL AND SYSDATE>ADD_MONTHS(dueDate, 1))
            on personid = clientid
ORDER BY lastname, firstname, element_type, duedate

-- average lendings per month
SELECT to_char(to_date(m, 'mm'), 'Month') as month, round(AVG(borrow_count), 2) AS avg_borrow_count
FROM (SELECT EXTRACT(YEAR FROM lendingdate) AS y, EXTRACT(MONTH FROM lendingdate) AS m, COUNT(*) AS borrow_count
      FROM (SELECT lendingDate FROM bookLending
           UNION ALL
           SELECT lendingdate FROM playLending) 
      GROUP  BY EXTRACT(YEAR FROM lendingdate), EXTRACT(MONTH FROM lendingdate))
GROUP BY m
ORDER BY m
