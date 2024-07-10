-- This trigger updates availability of a play when lending or returning it
create or replace noneditionable trigger play_lending_returning
  after insert or update of returndate
  on playlending 
  for each row
begin
  -- lending a play
  if :new.returndate is null
    then update playcopy
      set available = 0
      where playcopy.copyid = :new.copyid;
  else
    -- returning a play
    IF :new.returndate > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Return date cannot be in the future');
    END IF;
    update playcopy
      set available = 1
      where playcopy.copyid = :new.copyid;
  end if;
end playLending_return;
/
