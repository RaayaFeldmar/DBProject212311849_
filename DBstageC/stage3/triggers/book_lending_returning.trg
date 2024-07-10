-- This trigger updates availability of a book when lending or returning it
create or replace noneditionable trigger book_lending_returning
  after insert or update of returndate
  on booklending 
  for each row 
begin
  -- lending a book
  if :new.returndate is null
    then update bookcopy
      set available = 0
      where bookcopy.copyid = :new.copyid;
  else
    -- returning a book
    IF :new.returndate > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Return date cannot be in the future');
    END IF;
    update bookcopy
      set available = 1
      where bookcopy.copyid = :new.copyid;
  end if;
end bookLending_return;
/
