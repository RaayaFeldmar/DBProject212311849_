create or replace noneditionable function calculateDueDate_book(copy_id in number) return date is
/*--------------------------------------------------------------------------------------------
This function calculates the due date for returning the book
parameter: copy_id=> the copyId of the book.
return the due date.
---------------------------------------------------------------------------------------------*/  
  due_date date;
  tmp_num integer;
begin
  -- Checking the amount of copies available of this book excluding the requiered book
  select count(*) into tmp_num
  from Bookcopy
  where bookId = (select bookId from bookCopy where copyId = copy_id) and
        copyId <> copy_id and
        available = 1;
  if tmp_num = 0 then
    due_date:= TRUNC(SYSDATE + 7);
  elsif tmp_num < 3 then
    due_date:= TRUNC(SYSDATE + 14);
  else due_date:= TRUNC(ADD_MONTHS((SYSDATE),1));
  end if;
  return(due_date);
end calculateDueDate_book;
/
