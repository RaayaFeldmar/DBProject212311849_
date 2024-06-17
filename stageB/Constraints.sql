
--default
ALTER TABLE bookcopy 
MODIFY available NUMBER(1) DEFAULT 1;

ALTER TABLE bookLending
MODIFY lendingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

--unique
ALTER TABLE bookPublisher 
ADD CONSTRAINT pname_unique UNIQUE (publisherName);


--nullable
ALTER TABLE librarian 
MODIFY userpassword NULL;

--check
ALTER TABLE client
ADD CONSTRAINT active_ch CHECK (active=0 OR active=1); 

ALTER TABLE bookLending 
ADD CONSTRAINT dueDate_ch CHECK (duedate > lendingdate) ENABLE NOVALIDATE;  
