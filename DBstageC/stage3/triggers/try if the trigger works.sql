select *
from booklending natural join bookcopy
where lendingid = 1001

select * from bookcopy

update bookcopy
set available = 0
where copyid = 650

update booklending
set returndate = null
where lendingid = 1001
