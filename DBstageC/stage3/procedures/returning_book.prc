create or replace noneditionable procedure returning_book(copy_id in number) is
/*--------------------------------------------------------------------------------------------
This procedure performs a returning a specific book.
parameter: copy_id.
---------------------------------------------------------------------------------------------*/  

fineStr varchar2(100);
finePerDay constant number(2):= 5;
calculatedFine fines.totalfine%type;
book_title book.title%type;

book_not_borrowed EXCEPTION;
PRAGMA EXCEPTION_INIT( book_not_borrowed, -20011 );
book_multiple_borrowed EXCEPTION;
PRAGMA EXCEPTION_INIT( book_multiple_borrowed, -20012 );

cursor c is
  select * from Booklending
  where copyId = copy_id and returnDate is null
  for update of returnDate;
lending_rec c%rowtype;

begin
  select title into book_title
  from bookcopy natural join book
  where copyid = copy_id;
  
  open c;
  fetch c into lending_rec;
  if c%notfound then
      RAISE_APPLICATION_ERROR(-20011, 'Book copy: '||copy_id||' is not borrowed.');
  elsif c%rowcount > 1 then
      RAISE_APPLICATION_ERROR(-20012, 'Book copy: '||copy_id||' is borrowed for multiple clients...');
  elsif sysdate > lending_rec.duedate then -- The book was returned late. A fine must be calculated for it.
    calculatedFine:= (sysdate - lending_rec.dueDate)*finePerDay;
    MERGE INTO fines f
    USING (SELECT lending_rec.clientid clientId, calculatedFine totalFine from dual) tmpTable
    ON (f.clientId = tmpTable.clientId)
    WHEN MATCHED THEN UPDATE SET f.totalFine = f.totalfine+tmpTable.Totalfine
    WHEN NOT MATCHED THEN INSERT (clientId, totalFine) VALUES (tmpTable.clientId, tmpTable.totalFine);
    fineStr:= chr(13)||chr(10)||'Client #'||lending_rec.clientid||' owes a fine of '||calculatedFine||' NIS for this book.';
  end if;
  update Booklending -- Update the returningDate (Current date).
    set returnDate = sysdate
    where current of c;
  close c;
  
  dbms_output.put_line('The book '||book_title||' has been successfully returned'||fineStr);
  exception
    when NO_DATA_FOUND then
      RAISE_APPLICATION_ERROR(-20002, 'Book Copy ID: '||copy_id||' does not exist in the system.');
end returning_book;
/
