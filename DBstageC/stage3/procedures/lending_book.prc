create or replace noneditionable procedure lending_book(librarian_id in varchar, client_id in varchar, copy_id in number) is
/*--------------------------------------------------------------------------------------------
This procedure performs a lending to a requested book.
parameters: librarian_id, client_id, copy_id.
---------------------------------------------------------------------------------------------*/  
 
tmp_bool number(1);
tmp_num integer;
max_books number(2);
due_date date;
lastInsertFrom varchar2(10); -- for raising a specofic exceptin when not data found 
client_not_exists EXCEPTION;
book_not_exists EXCEPTION;
client_not_active EXCEPTION;
over_max_books EXCEPTION;
book_not_availeble EXCEPTION;
PRAGMA EXCEPTION_INIT( client_not_exists, -20001 );
PRAGMA EXCEPTION_INIT( book_not_exists, -20002 );
PRAGMA EXCEPTION_INIT( client_not_active, -20003 );
PRAGMA EXCEPTION_INIT( over_max_books, -20004 );
PRAGMA EXCEPTION_INIT( book_not_availeble, -20005 );

begin
-- Checking if the client is allowed to lend a book
  -- Checking if the client is active
  lastInsertFrom:='client';
  select active, maxBooks  into tmp_bool, max_books
  from client
  where clientId = client_id;
  if tmp_bool = 0 then
      RAISE_APPLICATION_ERROR(-20003, 'Client ID: '||client_id||' is not active.');
  end if;
  -- Checking if the client has not exceeded the max books
  select count(*) into tmp_num
  from bookLending
  where clientId = client_id and returnDate is null;
  if tmp_num >= max_books then
      RAISE_APPLICATION_ERROR(-20004, 'Client ID: '||client_id||' has already lended the maximum number of books he is allowed.');
  end if;
 
-- Checking if the book is available
  lastInsertFrom:='bookcopy';
  select available into tmp_bool
  from Bookcopy
  where copyId = copy_id;
  if tmp_bool=0 then
      RAISE_APPLICATION_ERROR(-20005, 'Book Copy ID: '||copy_id||' is not available.');
  end if;
  
-- Calculation of dueDate
  -- Checking the amount of copies available of this book
  select count(*) into tmp_num
  from Bookcopy
  where bookId = (select bookId from bookCopy where copyId = copy_id) and
        available = 1;
  if tmp_num = 1 then
    due_date:= TRUNC(SYSDATE + 7);
  elsif tmp_num < 4 then
    due_date:= TRUNC(SYSDATE + 14);
  else due_date:= TRUNC(ADD_MONTHS((SYSDATE),1));
  end if;
  
-- Inserting new tuple into bookLending table
  insert into bookLending(DUEDATE, CLIENTID, LIBRARIANID, COPYID)
  values (due_date, client_id, librarian_id, copy_id)
  returning lendingId into tmp_num;
  
-- Printing a success message with the due date
  if SQL%FOUND then
    dbms_output.put_line('The lending was done successfully.');
    dbms_output.put_line('LendingId: '||tmp_num);
    dbms_output.put_line('The book must be returned by: '||to_char(due_date, 'dd-mon-yyyy'));
  end if;
  
  exception
    when NO_DATA_FOUND then
      if lastInsertFrom = 'client' then
          RAISE_APPLICATION_ERROR(-20001, 'Client ID: '||client_id||' does not exist in the system.');
      elsif lastInsertFrom = 'bookcopy' then
          RAISE_APPLICATION_ERROR(-20002, 'Book Copy ID: '||copy_id||' does not exist in the system.');
      end if;
      
end lending_book;
/
