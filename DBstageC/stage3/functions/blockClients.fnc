create or replace noneditionable function blockClients(allowedLate in number default 60) return number is
/*--------------------------------------------------------------------------------------------
This functions blocks all clients who had not returned books although their due date passed.
parameter: allowedlate=> the maximum days allowed to late.
return the ammount of clients blocked in this transaction.
---------------------------------------------------------------------------------------------*/  
  counter number:= 0;
  header constant varchar2(100):='You are blocked due to books you had not returned:'||chr(13)||chr(10);
  notifyMessage varchar2(500);
  
  cursor clientsToBlock is
  select clientId, count(*)
  from booklending natural join client
  where active = 1 and sysdate-duedate > allowedLate
  group by clientId;
  clientsRec clientsToBlock%rowtype;
  
  cursor lateBooksDetails is
  select clientId, dueDate, title
  from booklending natural join bookcopy natural join book
  where trunc(sysdate)>duedate;
  booksDetailsRec lateBooksDetails%rowtype;
  
  begin
  for clientsRec in clientsToBlock
    loop
      -- Block the client
      update client
      set active = 0
      where clientId = clientsRec.Clientid;
      -- Create notify message
      notifyMessage:= header;
      for booksDetailsRec in lateBooksDetails
        loop
          if booksDetailsRec.Clientid=clientsRec.Clientid then
             notifyMessage:= notifyMessage||'The book '||booksDetailsRec.title||' had to be returned in '||booksDetailsRec.dueDate||chr(13)||chr(10);
          end if;
        end loop;
      --insert to notification table
      insert into notifications(personId, msg)
      values(clientsRec.Clientid, notifyMessage);
      -- Increase the counter
      counter:= counter+1;
    end loop;
  return(counter);
end blockClients;
/
