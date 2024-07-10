/*-----------------------------------------------------------------------------------------
 This program simulates a library maintenance program.
 The program performs:
 1. Extending book lendings to random clients
 2. Blocking clients
 3. Notification of blocked clients
-------------------------------------------------------------------------------------------*/
declare
  max_late integer;
  random_clients_counter integer; 
  blocked_ammount number;
  
  cursor random_clients is
  select distinct clientId
  from booklending natural join client
  where active = 1 and returnDate is null and sysdate-duedate > max_late
  order by dbms_random.value;
  client_rec random_clients%rowtype;
begin
  DBMS_OUTPUT.ENABLE (buffer_size => NULL);
    
  max_late:= dbms_random.value(30, 120);
  
  dbms_output.put_line('**************************************************************************************************************************************');
  dbms_output.put_line('                                  Welcome to the the library maintenance program');
  dbms_output.put_line('**************************************************************************************************************************************');
  dbms_output.new_line();
  
  -- Extention of all book lendings of random clients
  random_clients_counter:= dbms_random.value(1, 15);
  dbms_output.put_line('The system has chosen randomally '||random_clients_counter||' customers and is extending all the lendings of the books they hold...');
  for client_rec in random_clients
    loop
      dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------------');
      dbms_output.put_line('Client #'||client_rec.clientId||', you have been saved from a blocking!!!');
      dbms_output.put_line('The system is extending all the lendings of the books you hold...'||chr(13)||chr(10));
      extensionofalllendings_book(client_rec.Clientid);
      random_clients_counter:= random_clients_counter-1;
      dbms_output.put_line('---------------------------------------------------------------------------------------------------------------------------------');
      exit when random_clients_counter=0;
    end loop;
    
    --Blocking all clients who have books whose due date has passed before more than max_late days.
    blocked_ammount:= blockclients(max_late);
    dbms_output.put_line(blocked_ammount||' clients had blocked!');
    
    --Print notifications details
    dbms_output.put_line(chr(13)||chr(10)||'The system is printing the blocked clients contact information and the messages...'||chr(13)||chr(10));
    for item in (select phone, firstName, lastName, msg 
                   from person natural join notifications
                   where trunc(msgDate)=trunc(sysdate))
      loop
        dbms_output.put_line('Phone: '||item.phone);
        dbms_output.put_line('Name: '||item.firstname||' '||item.lastname);
        dbms_output.put_line('Message: '||chr(13)||chr(10)||item.msg);
      end loop;
        
end;
