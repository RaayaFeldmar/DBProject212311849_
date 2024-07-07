-- update bookLending dueDate
UPDATE booklending
SET duedate = lendingdate+14
WHERE duedate < lendingdate;

-- update playLending dueDate
UPDATE playlending
SET duedate = lendingdate+14
WHERE duedate < lendingdate;

-- update bookCopy available 
UPDATE bookcopy
SET available = CASE
                  WHEN (copyid IN (SELECT copyId
                                    FROM booklending
                                    WHERE returndate IS NULL)) THEN 0
                  ELSE 1
                  END;
                  
-- update playCopy available 
UPDATE playcopy
SET available = CASE
                  WHEN (copyid IN (SELECT copyId
                                    FROM playlending
                                    WHERE returndate IS NULL)) THEN 0
                  ELSE 1
                  END;
                  
--increase maxBooks of the 5 most active clients since 2020
UPDATE client
SET maxBooks = maxBooks + 1
WHERE clientId in (SELECT clientId
                  FROM client NATURAL JOIN (SELECT clientId, COUNT(*)
                                            FROM booklending
                                            WHERE EXTRACT(YEAR FROM lendingDate) >= 2020
                                            GROUP BY clientId
                                            ORDER BY 2 DESC
                                            FETCH FIRST 5 ROWS ONLY));
                  
     
                  
                  
