-- modify bookLending.lendingId to be auto genarated
alter table bookLending drop column lendingId;

alter table bookLending 
     add lendingId integer 
     generated always as identity (START WITH 1 INCREMENT BY 1);
     
alter table bookLending 
add constraint bookLending_pk primary key (lendingId);

ALTER TABLE bookLending MODIFY (lendingdate  INVISIBLE, duedate  INVISIBLE, returndate INVISIBLE, clientid INVISIBLE, librarianid INVISIBLE, copyid INVISIBLE);
ALTER TABLE bookLending MODIFY (lendingdate  VISIBLE, duedate  VISIBLE, returndate VISIBLE, clientid VISIBLE, librarianid VISIBLE, copyid VISIBLE);

-- create new table for saved culculated fines of clients.
CREATE TABLE fines
(
  clientId VARCHAR(9) NOT NULL,
  totalFine NUMBER(5) NOT NULL,
  PRIMARY KEY (clientId),
  FOREIGN KEY (clientId) REFERENCES client(clientId)
);

-- create new table for notifications.
CREATE TABLE notifications
(
  notifyId INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  personId VARCHAR2(9) NOT NULL,
  msg VARCHAR2(500) NOT NULL,
  msgDate DATE NOT NULL,
  PRIMARY KEY (notifyId),
  FOREIGN KEY (personId) REFERENCES person(personId)
);
ALTER TABLE notifications
MODIFY msgDate DEFAULT SYSDATE;


