--delete all duplicated book lendings, exclude the latest lending.
DELETE
FROM booklending T1
WHERE returnDate IS NULL AND
      EXISTS (SELECT *
              FROM Booklending T2
              WHERE T1.copyid = T2.copyid AND
                    T2.returndate IS NULL AND
                    T1.lendingdate<=T2.lendingdate AND
                    T1.lendingid <> T2.lendingid);
                    
--delete all unrequested book copies
DELETE
FROM bookCopy
WHERE copyId NOT IN (SELECT DISTINCT copyId
                    FROM bookLending)
               
