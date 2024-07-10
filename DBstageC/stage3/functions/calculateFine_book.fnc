create or replace noneditionable function calculateFine_book(lending_id in integer) return number is
/*--------------------------------------------------------------------------------------------
This function calculates the fine for returning a book late.
parameter: lending_id.
return the the amount of the fine.
---------------------------------------------------------------------------------------------*/    
  calculatedFine number:=0;
  FINE_PER_DAY constant number(2):= 5;
begin
  select (sysdate-dueDate)*FINE_PER_DAY into calculatedFine
  from bookLending
  where lendingId = lending_id; 
  return(round(calculatedFine, 2));      
end calculateFine_book;
/
