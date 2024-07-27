--rename tables
RENAME Book TO Book1;
RENAME Librarian TO Librarian1;
COMMIT;
--alter tables
ALTER TABLE Book1 
ADD price NUMBER(5,2) NULL;

ALTER TABLE BookCategory 
ADD ( locationC VARCHAR2(30) NULL,
      color VARCHAR2(10) NULL,
      maxAmount NUMBER NULL);
      
ALTER TABLE Bookcopy
ADD purchaseDate DATE NULL;

ALTER TABLE Person 
MODIFY email NULL;

ALTER TABLE Librarian1
MODIFY startDate NULL;

ALTER TABLE person
MODIFY lastName NULL;

ALTER TABLE client
MODIFY maxBooks DEFAULT 4;

ALTER TABLE Book1
MODIFY bookLanguage DEFAULT 'Hebrew';

ALTER TABLE Book1
MODIFY pages NULL;

ALTER TABLE Bookcopy
MODIFY edition NULL;

--change book copy to week entity
ALTER TABLE Booklending
DROP CONSTRAINT SYS_C0010682

ALTER TABLE Bookcopy
 DROP PRIMARY KEY;
ALTER TABLE Bookcopy
ADD PRIMARY KEY(copyId, bookId);

ALTER TABLE Booklending
ADD bookId NUMBER(6) NOT NULL;
ALTER TABLE Booklending
ADD FOREIGN KEY (copyId, bookId) REFERENCES BookCopy(copyId, bookId);

-- modify BookCategory.categoryId to be auto genarated
ALTER TABLE Book1
DROP CONSTRAINT SYS_C0010643;

alter table BookCategory drop column categoryId;

alter table bookCategory
     add categoryId integer 
     generated always as identity (START WITH 1 INCREMENT BY 1);
     
alter table bookCategory 
add constraint bookCategory_pk primary key (categoryId);

ALTER TABLE bookCategory MODIFY (categoryName  INVISIBLE, locationC INVISIBLE, color INVISIBLE, maxAmount INVISIBLE);
ALTER TABLE bookCategory MODIFY (categoryName  VISIBLE, locationC VISIBLE, color VISIBLE, maxAmount VISIBLE);

ALTER TABLE Book1
ADD FOREIGN KEY (categoryId) REFERENCES BookCategory(categoryId);

INSERT INTO Bookcategory(Categoryname)
VALUES ('UNDEFINED');

-- modify BookPublisher.publisherId to be auto genarated
ALTER TABLE Book1
DROP CONSTRAINT SYS_C0010644;

alter table BookPublisher drop column publisherId;

alter table BookPublisher
     add publisherId integer 
     generated always as identity (START WITH 1 INCREMENT BY 1);
     
alter table BookPublisher 
add constraint bookPublisher_pk primary key (publisherId);

ALTER TABLE BookPublisher MODIFY (publisherName  INVISIBLE);
ALTER TABLE BookPublisher MODIFY (publisherName  VISIBLE);

ALTER TABLE Book1
ADD FOREIGN KEY (publisherId) REFERENCES BookPublisher(publisherId);

-- import data
-- import data to BookPublisher
INSERT INTO BookPublisher(Publishername)
SELECT DISTINCT bookpublisher
from Book 
where bookpublisher not in (select publishername from bookpublisher);

-- import data to BookCategory
INSERT INTO Bookcategory(Categoryname, Locationc, Color, Maxamount)
SELECT className, Locationc, Color, Maxamount
FROM Bookclass
WHERE className NOT IN (SELECT categoryName FROM Bookcategory);

MERGE INTO Bookcategory BT
USING ( 
    SELECT B.Classname, B.LocationC, B.Color, B.maxAmount 
    FROM Bookclass B) TMP
ON (BT.categoryName = TMP.className)
WHEN MATCHED THEN 
UPDATE SET 
    BT.LocationC = TMP.LocationC, 
    BT.Color = TMP.Color,
    BT.maxAmount = TMP.maxAmount;
    
-- import data to Client (and to Person)
SELECT COUNT(*)
FROM Reader
WHERE readerNumber IN (SELECT TO_NUMBER(personID) FROM Person);
       
INSERT INTO Person(Personid, Firstname, Lastname, Phone)
SELECT (TO_CHAR(readerNumber)), regexp_substr(readerName, '\S+', 1, 1), regexp_substr(readerName, '\S+', 1, 2), phone
FROM Reader;

INSERT INTO CLIENT(CLIENTID)
SELECT (TO_CHAR(readerNumber))
FROM Reader;

CREATE SEQUENCE fakePersonId INCREMENT BY 1 START WITH 374;

-- import data to Librarian (and to Person)
SELECT COUNT(*)
FROM Librarian
WHERE lUserName IN (SELECT userName FROM Librarian1);
       
CREATE GLOBAL TEMPORARY TABLE 
       tmp_librarian(personId VARCHAR2(9), 
       firstName VARCHAR2(50), 
       lastName VARCHAR2(50), 
       phone VARCHAR2(12), 
       userName VARCHAR2(50), 
       userPassword VARCHAR2(50))
ON COMMIT DELETE ROWS;

INSERT INTO tmp_librarian
SELECT  (TO_CHAR(fakePersonId.Nextval)),
        regexp_substr(librarianName, '\S+', 1, 1),
        regexp_substr(librarianName, '\S+', 1, 2),
        lPhone,
        lUserName,
        lPassword
    FROM Librarian;
    
INSERT INTO Person(Personid, Firstname, Lastname, Phone)
SELECT Personid, Firstname, Lastname, Phone
FROM tmp_librarian;

INSERT INTO Librarian1(librarianId, Username, Userpassword)
SELECT personId, Username, Userpassword
FROM tmp_librarian;

DROP TABLE tmp_librarian;

-- import data to Book
SELECT COUNT(*)
FROM book JOIN book1 NATURAL JOIN book_author 
ON bookname = title
WHERE book.authorname = author

SELECT COUNT(*) 
FROM book 
WHERE bookpublisher IS NULL
OR authorName IS NULL
OR publishYear IS NULL
ORDER BY bookid

SELECT MAX(bookId) -- returned 500, so the sequence should start at 501
FROM Book1;

CREATE GLOBAL TEMPORARY TABLE 
                      tmp_book(bookId NUMBER(6) GENERATED ALWAYS AS IDENTITY (START WITH 501 INCREMENT BY 1), 
                      oldBookId INTEGER)
ON COMMIT PRESERVE ROWS;

INSERT INTO tmp_book(oldbookid)
SELECT bookId
FROM Book;

INSERT INTO Book1(Bookid, Title, Categoryid, Publisherid, Price)
SELECT tmp_book.bookid, bookName, 81, publisherId, bookPrice
FROM Book JOIN tmp_book ON Book.Bookid = tmp_book.oldbookid
          JOIN Bookpublisher ON Book.Bookpublisher = Bookpublisher.Publishername;
          
MERGE INTO Book1 BT
USING ( 
    SELECT C.categoryId, B1.Bookid FROM
                        Book1 B1 JOIN tmp_book ON B1.BOOKID = tmp_book.bookid
                        JOIN (SELECT * FROM Book WHERE classId IS NOT NULL)B ON B.Bookid = tmp_book.oldbookid
                        NATURAL JOIN Bookclass
                        JOIN Bookcategory C ON Bookclass.Classname = C.Categoryname) TMP
ON (BT.bookId = TMP.bookId)
WHEN MATCHED THEN 
UPDATE SET 
    BT.categoryId = TMP.categoryId;
    
-- import data to Book_Author table
INSERT INTO Book_Author
SELECT authorName, tmp_book.bookId
FROM Book JOIN tmp_book ON Book.Bookid = tmp_book.oldbookid;
    
-- import data to BookCopy
INSERT INTO bookCopy(Copyid, Yearpublished, Bookid, Purchasedate)
SELECT copyCode, publishYear, tmp_book.bookId, purchasedate
FROM Bookcopyinstock JOIN Book ON Bookcopyinstock.Bookid = Book.Bookid 
     JOIN tmp_book ON Bookcopyinstock.Bookid = tmp_book.oldbookid
     
MERGE INTO Bookcopy BT
USING ( 
    SELECT tmp_book.bookId, copyCode FROM
                        (SELECT * FROM Bookcopyinstock WHERE status IN ('Withdrawn', 'borrowed', 'Borrowed')) BC1 
                        JOIN tmp_book ON BC1.bookId = tmp_book.oldbookid) TMP
ON (BT.bookId = TMP.bookId AND BT.copyId = TMP.copyCode)
WHEN MATCHED THEN 
UPDATE SET 
    available = 0;
    
-- change librarian identifier in Ordering table
ALTER TABLE Ordering
ADD librarianId VARCHAR2(9) REFERENCES Librarian1(Librarianid);

UPDATE Ordering
SET librarianId = (SELECT librarianId
                  FROM Librarian1
                  WHERE Ordering.Lusername = Librarian1.userName);
                  
ALTER TABLE Ordering DROP COLUMN lUserName;

-- change column name and data type of client identifier in BookOrdering table
ALTER TABLE Bookordering
ADD clientId VARCHAR2(9) REFERENCES Client(clientId);

UPDATE Bookordering
SET clientId = TO_CHAR(readerNumber);

ALTER TABLE Bookordering DROP COLUMN readerNumber;
   
-- update bookId in BookOrdering table
ALTER TABLE Bookordering RENAME COLUMN bookId TO bookId_old;

ALTER TABLE Bookordering
ADD bookId NUMBER(6) REFERENCES Book1(Bookid);

UPDATE Bookordering
SET bookId = (SELECT bookId
             FROM tmp_book
             WHERE Bookordering.Bookid = tmp_book.oldbookid);
                          
ALTER TABLE Bookordering DROP COLUMN bookId_old;

-- drop unnecessary tables
DROP TABLE Bookcopyinstock;
DROP TABLE Book;
DROP TABLE Bookclass;
DROP TABLE Reader;
DROP TABLE Librarian;
DROP TABLE tmp_book;

--rename tables
RENAME Book1 TO Book;
RENAME Librarian1 TO Librarian;
COMMIT;
         
