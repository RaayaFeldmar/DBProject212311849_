--שאילתות עם פרמטרים--
SELECT * 
FROM book
WHERE pages 
BETWEEN &<name= "min_pages" type= "integer" default= 0> 
AND &<name= "max_pages" type= "integer" default= 500>
ORDER BY bookid

SELECT p.*, b.duedate
FROM booklending b
JOIN person p ON p.personid = b.clientid
WHERE b.duedate 
BETWEEN &<name= "min_date" type= "date" required = true> 
AND &<name= "max_date" type= "date" required = true> 
ORDER BY p.personid

SELECT * 
FROM book b1
JOIN bookcategory bc ON b1.categoryid = bc.categoryid
WHERE bc.categoryname =  &<name= "category_name" type= "string" list=" Action, Art, Autobiography, Biography, Business, Children's, Comic , Cookbook, Diary, Dictionary, Encyclopedia, Fantasy, Guide, Health, Historical fiction, History, Hobbies, Home and garden, Humor, Journal, Math, Mystery, Philosophy, Picture book, Poetry, Political thriller, Satire, Science, Science fiction, Short story, Suspense, Thriller, Travel"> 
ORDER BY b1.bookid

SELECT *
FROM bookcopy b2
WHERE b2.available = 1
AND b2.bookid = &<name= "book_id" type= "integer" required = true hint= "number between 1-500"> 
ORDER BY b2.copyid

