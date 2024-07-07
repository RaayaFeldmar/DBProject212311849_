--select books by category and language
select bookId, title, bookLanguage, count(*) as amount_of_available_copies
from book natural join bookcopy
where categoryId in (&<name="category" list="select categoryId, categoryName from bookcategory" multiselect="yes" description="yes" restricted="yes">)
&<name="language" list="select distinct bookLanguage from book" type="string" prefix="and bookLanguage=">
and available=1
group by bookId, title, bookLanguage
order by title

--select clients who lended books in a selected range dates
select distinct personId as clientID, firstName, lastName, phone, email
from person join Booklending
on personId = clientId
where lendingDate between &<name="from date" type="date" default="select min(lendingDate) from bookLending" required=true> and &<name="to date" type="date" default=sysdate required=true>
order by &<name="order by" list="personId, ID, firstName, first name, lastname, last name" description="yes" required=true>
&<name="decending" checkbox="desc, asc">

--select plays by category, options of available: 1=>a play that a copy of it is available
--                                                0=>a play that a copy of it is not available
--                                                null=>all plays 
select distinct playId, playname, categoryName
from play natural join playCategory
where categoryName in (&<name="category" type="string" list="select distinct categoryName from playCategory" multiselect="yes" restricted="yes">)
&<name="available" hint="0 or 1"  prefix="and playId in (select distinct playId from playCopy where available=" suffix=")">
order by playId

--select librarians by the year of startDate
select librarianId as ID, firstName||' '||lastName as name, phone, email, userName, userPassword, startDate
from person join librarian
on personId = librarianId
where extract(year from startDate) in (&<name="year of strat date" list="select distinct extract(year from startDate) from librarian order by 1" multiselect="yes" required=true>)
&<name="order by" list="ID, name,  startDate" prefix="order by ">
