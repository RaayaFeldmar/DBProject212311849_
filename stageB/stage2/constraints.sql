
--default
ALTER TABLE client 
MODIFY active DEFAULT 1;

ALTER TABLE bookCopy 
MODIFY available DEFAULT 1;

ALTER TABLE playCopy 
MODIFY available DEFAULT 1;

ALTER TABLE bookLending
MODIFY (lendingDate DEFAULT SYSDATE,
       dueDate DEFAULT TRUNC(SYSDATE)+14);
       
ALTER TABLE playLending
MODIFY (lendingDate DEFAULT SYSDATE,
       dueDate DEFAULT TRUNC(SYSDATE)+14);


--unique
ALTER TABLE bookPublisher 
ADD CONSTRAINT book_publisher_unique UNIQUE (publisherName);

ALTER TABLE playPublisher 
ADD CONSTRAINT play_publisher_unique UNIQUE (publisherName);

ALTER TABLE bookCategory 
ADD CONSTRAINT book_category_unique UNIQUE (categoryName);

ALTER TABLE playCategory 
ADD CONSTRAINT play_category_unique UNIQUE (categoryName);

ALTER TABLE librarian 
ADD CONSTRAINT username_unique UNIQUE (userName);


--nullable
ALTER TABLE librarian 
MODIFY userpassword NULL;

--check
ALTER TABLE client
ADD (CONSTRAINT active_ch CHECK (active IN(0,1)),
    CONSTRAINT maxBooks_ch CHECK (maxBooks > 0)); 
    
ALTER TABLE book
ADD CONSTRAINT pages_ch CHECK (pages > 0);
    
ALTER TABLE bookCopy
ADD CONSTRAINT book_available_ch CHECK (available IN(0,1));

ALTER TABLE playCopy
ADD CONSTRAINT play_available_ch CHECK (available IN(0,1));

ALTER TABLE bookLending 
ADD (CONSTRAINT book_dueDate_ch CHECK (duedate >= lendingdate) ENABLE NOVALIDATE,
    CONSTRAINT book_returnDate_ch CHECK (returnDate >=  TRUNC(lendingDate)));
    
ALTER TABLE playLending 
ADD (CONSTRAINT play_dueDate_ch CHECK (duedate > lendingdate) ENABLE NOVALIDATE,
    CONSTRAINT play_returnDate_ch CHECK (returnDate >=  lendingDate));
