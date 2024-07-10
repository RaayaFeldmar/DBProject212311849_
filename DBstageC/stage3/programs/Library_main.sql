/*---------------------------------------------------------------------------------------------------------------------------------------------------------
This program simulates the system of book lendings in the library.
The program tries to lend a book to a random customer. 
If the customer is blocked due to books he holds late or due to a fine registered on his name,
   the program returns all the books in his possession and the date for their return has passed, as well as payment of a fine and the return of the excess.
   After that, the program performs the book loan again.
If the loan failed because the client borrowed the maximum amount of books allowed, 
  the program prints an appropriate message.
-----------------------------------------------------------------------------------------------------------------------------------------------------------*/
declare 
  librarian_ID librarian.librarianid%type;
  client_ID client.clientid%type;
  copy_ID bookcopy.copyid%type;
  book_ID book.bookid%type;
  client_name varchar2(100);
  book_title book.title%type;
  fine_payment fines.totalfine%type;
  isActive number:= 0;
  flag boolean:= true;
  
  cursor over_due_date_books is
    select copyId
    from bookLending
    where clientId = client_ID and returnDate is null and dueDate<TRUNC(sysdate);
  book_rec over_due_date_books%rowtype;
begin
  dbms_output.put_line('**************************************************************************************************************************************');
  dbms_output.put_line('                                  Welcome to the the library program');
  dbms_output.put_line('**************************************************************************************************************************************');
  
  --select randomally librarian
  select librarianId into librarian_ID
  from librarian
  order by dbms_random.value
  fetch first row only;
    
  --select randomally client
  select clientid into client_ID
  from client
  order by dbms_random.value
  fetch first row only; 
  
  --select randomally book
  select copyid, bookId into copy_ID, book_ID
  from bookcopy
  where available=1
  order by dbms_random.value
  fetch first row only;
  
  --select client and book details for user friendly message...
  select firstName||' '||lastName into client_name
  from person
  where personId = client_ID;
  
  select title into book_title
  from book
  where bookId = book_ID;
  
  dbms_output.put_line('Client #'||client_ID||' ('||client_name||') wants to lend the book copy #'||copy_ID||' ('||book_title||').');
  
  lending_book(librarian_id => librarian_ID, client_id => client_ID, copy_id => copy_ID);
  
  EXCEPTION
    when OTHERS then
      case SQLCODE
        when -20003 then
          dbms_output.new_line();
          dbms_output.put_line('The client is not active!!!');
          for book_rec in over_due_date_books
            loop
              if flag then
                dbms_output.new_line();
                dbms_output.put_line('The client returns the books that are overdue...');
                flag:= false;
              end if;
              dbms_output.new_line();
              returning_book(book_rec.copyid);
            end loop;
            if flag = false then
              dbms_output.new_line();
            end if;
          --check for a fine
          for fine in (select totalfine from fines where clientId = client_ID)
            loop
              dbms_output.put_line('The client have a fine of '||fine.totalfine||' NIS.');
              fine_payment:= ROUND(fine.totalfine+5, -1);
              dbms_output.put_line('The client pays '||fine_payment||' NIS');
              isActive:= payfine(client_id => client_ID, payment => fine_payment);
              dbms_output.put_line('The client receives an excess of '||fine_payment||' NIS.');
            end loop;
          if isActive = 1 then
            -- The client is active now, so he tries to lend the book again
            dbms_output.new_line();
            dbms_output.put_line('The client tries to lend the book again...');
            lending_book(librarian_id => librarian_ID, client_id => client_ID, copy_id => copy_ID);
            dbms_output.new_line();
          end if;
        when -20004 then
          dbms_output.put_line('Too much books');
       end case;
END;
/
