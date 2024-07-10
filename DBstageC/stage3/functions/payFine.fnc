create or replace noneditionable function payFine(client_id in varchar2, payment in out number) return number is
/*-------------------------------------------------------------------------------------------------------------------------------------------------------- 
 This function performs a fine payment. 
 Parameters: client_id - ID of the client who pays the fine.
             payment   - The amount of money he pays. 
                       In the function, this parameter is updated to the change of the payment: if the payment>0, the client get change
                                                                                                if the payment<0, the client hadn't pay the total fine...
----------------------------------------------------------------------------------------------------------------------------------------------------------*/  
  isActive number;
  total_fine fines.totalfine%type;
  lastInsertFrom varchar2(10); -- for raising a specific exceptin when not data found 
  
  cursor overDueDate is
  select lendingId, copyId, title, dueDate
  from (select lendingId, copyId, dueDate
        from bookLending 
        where clientId = client_id and dueDate<sysdate and returnDate is null)l
        natural join (select copyId, bookId
                      from Bookcopy)c
                      natural join (select bookId, title
                                   from book)b;
                   
  overDueDateRec overDueDate%rowtype;
begin
  lastInsertFrom:='client';
  select active into isActive
  from client
  where clientId=client_id;
  lastInsertFrom:='fines';
  select totalFine into total_fine
  from fines
  where clientId=client_id;
  --update fine
  if total_fine>payment then
    update fines
    set totalFine = total_fine-payment
    where clientId = client_id;
  else 
  -- There is no remaining fine
    -- 1. Remove the client from fines 
    delete from fines
    where clientId = client_id;
    -- 2. The client should be active...
    if isActive = 0 then
      -- Checking if he has books whose due date has passed, If so, print their details
      isActive:= 1;
      for overDueDateRec in overDueDate
        loop
          if isActive=1 then
            isActive:=0;
          end if;
          dbms_output.put_line('---------------------------------------------------------------------------------------------------');
          dbms_output.put_line('Book copy #'||overDueDateRec.Copyid||' ('||overDueDateRec.Title||') had to be retuned in: '||overDueDateRec.Duedate);
          dbms_output.put_line('The amount of the estimated fine for this book is: '||calculateFine_book(overDueDateRec.Lendingid)||' shekel.');
          dbms_output.put_line('---------------------------------------------------------------------------------------------------');
        end loop;
        -- If client can be active, update it
        if isActive=1 then
          update client
          set active= isActive
          where clientId=client_id;
          dbms_output.put_line('Total fine was paid, client: '||client_id||' is active now.');
        end if;
    end if;
  end if;
  --calculate change or the remaining fine (positive payment=> change. negative payment=> remaining fine).
  payment:= payment-total_fine;
  
  return (isActive);
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      if lastInsertFrom = 'client' then
        RAISE_APPLICATION_ERROR(-20001, 'Client ID: '||client_id||' does not exist in the system.');
      else
        dbms_output.put_line('There is not a fine for client: '||client_id);
        return (isActive);
      end if;
end payFine;
/
