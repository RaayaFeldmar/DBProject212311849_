create or replace noneditionable procedure extensionOfAllLendings_book(client_id in varchar2) is
/*------------------------------------------------------------------------
This procedure extends all book lendings of specific client.
parameter: client_id
--------------------------------------------------------------------------*/
i number:=0;
due_date date;
book_title book.title%type;
flag integer;

cursor lendingsBooks is
select *
from booklending
where clientId=client_id and returnDate is null
for update of returnDate;
lendingBooksRec lendingsBooks%rowtype;

begin
    --Checking if client_id exists.
    select count(*) into flag
    from client
    where clientId = client_id;
    if flag = 0 then
      RAISE_APPLICATION_ERROR(-20001, 'Client ID: '||client_id||' does not exist in the system.');
    end if;
    
    for lendingBooksRec in lendingsBooks
      loop
        flag:= 0;
        -- Calculating the possible due date by calculateDueDate_book function.
        due_date:= calculateDueDate_book(lendingBooksRec.copyId);
        -- Selecting title for printing lending details
        select title into book_title
        from bookcopy natural join book
        where copyid = lendingBooksRec.Copyid;
        
        if due_date>lendingBooksRec.Duedate then
          update bookLending
          set dueDate = due_date
          where current of lendingsBooks;
          if SQL%rowcount>0 then
            i:= i+1;
            -- Printing details of the updating lending
            dbms_output.put_line('Book copy #'||lendingBooksRec.Copyid||' ('||book_title||') due date has been successfully extended.');
            dbms_output.put_line('The previous due date: '||lendingBooksRec.Duedate);
            dbms_output.put_line('The updated due date: '||due_date); 
            dbms_output.new_line();
          end if;
       else
          dbms_output.put_line('Book copy #'||lendingBooksRec.Copyid||' ('||book_title||') due date could not been extended.');
          dbms_output.put_line('The due date: '||lendingBooksRec.Duedate);
          dbms_output.new_line();
        end if;
     end loop;
     if flag=1 then
       dbms_output.put_line('The client has no books that he did not return');
     else
       dbms_output.put_line('The due date of '||i||' books has been successfully extended.');
     end if;
end extensionOfAllLendings_book;
/
