--שאילתות ללא פרמטרים--
SELECT personid, firstname, lastname 
FROM person
WHERE personid IN (SELECT  librarianid FROM  librarian)
ORDER BY personid

SELECT p.personid, p.firstname, p.lastname, count(*)
FROM booklending b
JOIN person p ON p.personid = b.librarianid
GROUP BY p.personid, p.firstname, p.lastname

SELECT p.* , c.active, c.maxbooks
FROM client c
JOIN person p ON p.personid = c.clientid
WHERE clientid IN (SELECT clientid
                          FROM booklending
                          WHERE lendingdate 
                          BETWEEN to_date('10/01/2005','dd/mm/yyyy') 
                          AND to_date('10/01/2025','dd/mm/yyyy') )

SELECT p.playid, p.playname, t.countcopy  
FROM play p
JOIN (SELECT playid, count(*) AS countcopy
             FROM playcopy pc
             GROUP BY playid ) t ON p.playid = t.playid

--DELETE פקודות----
COMMIT
DELETE FROM bookcopy
WHERE copyid NOT IN (SELECT copyid
                            FROM booklending )

SELECT *
FROM bookcopy
ORDER BY copyid

ROLLBACK

COMMIT
DELETE FROM playlending
WHERE lendingdate < to_date('01/01/2010','dd/mm/yyyy')

SELECT *
FROM playlending
ORDER BY lendingid

ROLLBACK

--UPDATE פקודות----
COMMIT
UPDATE bookpublisher
SET publishername = 'am oved'
WHERE publishername = 'Wiley'

SELECT *
FROM bookpublisher
ORDER BY publisherid

ROLLBACK

COMMIT
UPDATE client
SET maxbooks = maxbooks + 1
WHERE active = 1 AND clientid NOT IN (SELECT clientid
                                             FROM booklending
                                             WHERE lendingdate < ADD_MONTHS(SYSDATE, -36) )

SELECT *
FROM client
ORDER BY clientid

ROLLBACK
