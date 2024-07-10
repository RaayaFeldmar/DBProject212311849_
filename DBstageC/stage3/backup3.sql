prompt PL/SQL Developer Export Tables for user LAX@XE
prompt Created by Chaya on Sunday, 7 July 2024
set feedback off
set define off

prompt Creating BOOKCATEGORY...
create table BOOKCATEGORY
(
  categoryid   NUMBER(3) not null,
  categoryname VARCHAR2(50) not null
)
;
alter table BOOKCATEGORY
  add primary key (CATEGORYID);
alter table BOOKCATEGORY
  add constraint BOOK_CATEGORY_UNIQUE unique (CATEGORYNAME);

prompt Creating BOOKPUBLISHER...
create table BOOKPUBLISHER
(
  publisherid   NUMBER(4) not null,
  publishername VARCHAR2(50) not null
)
;
alter table BOOKPUBLISHER
  add primary key (PUBLISHERID);
alter table BOOKPUBLISHER
  add constraint BOOK_PUBLISHER_UNIQUE unique (PUBLISHERNAME);

prompt Creating BOOK...
create table BOOK
(
  bookid       NUMBER(6) not null,
  title        VARCHAR2(50) not null,
  pages        NUMBER(4) not null,
  booklanguage VARCHAR2(50) not null,
  categoryid   NUMBER(3) not null,
  publisherid  NUMBER(4) not null
)
;
alter table BOOK
  add primary key (BOOKID);
alter table BOOK
  add foreign key (CATEGORYID)
  references BOOKCATEGORY (CATEGORYID);
alter table BOOK
  add foreign key (PUBLISHERID)
  references BOOKPUBLISHER (PUBLISHERID);
alter table BOOK
  add constraint PAGES_CH
  check (pages > 0);

prompt Creating BOOKCOPY...
create table BOOKCOPY
(
  copyid        NUMBER(8) not null,
  available     NUMBER(1) default 1 not null,
  yearpublished NUMBER(4) not null,
  edition       NUMBER(3) not null,
  bookid        NUMBER(6) not null
)
;
alter table BOOKCOPY
  add primary key (COPYID);
alter table BOOKCOPY
  add foreign key (BOOKID)
  references BOOK (BOOKID);
alter table BOOKCOPY
  add constraint BOOK_AVAILABLE_CH
  check (available IN(0,1));

prompt Creating PERSON...
create table PERSON
(
  personid  VARCHAR2(9) not null,
  firstname VARCHAR2(50) not null,
  lastname  VARCHAR2(50) not null,
  phone     VARCHAR2(12) not null,
  email     VARCHAR2(255) not null
)
;
alter table PERSON
  add primary key (PERSONID);

prompt Creating CLIENT...
create table CLIENT
(
  clientid VARCHAR2(9) not null,
  active   NUMBER(1) default 1 not null,
  maxbooks NUMBER(2) not null
)
;
alter table CLIENT
  add primary key (CLIENTID);
alter table CLIENT
  add foreign key (CLIENTID)
  references PERSON (PERSONID);
alter table CLIENT
  add constraint ACTIVE_CH
  check (active IN(0,1));
alter table CLIENT
  add constraint MAXBOOKS_CH
  check (maxBooks > 0);

prompt Creating LIBRARIAN...
create table LIBRARIAN
(
  librarianid  VARCHAR2(9) not null,
  startdate    DATE not null,
  username     VARCHAR2(50) not null,
  userpassword VARCHAR2(50)
)
;
alter table LIBRARIAN
  add primary key (LIBRARIANID);
alter table LIBRARIAN
  add constraint USERNAME_UNIQUE unique (USERNAME);
alter table LIBRARIAN
  add foreign key (LIBRARIANID)
  references PERSON (PERSONID);

prompt Creating BOOKLENDING...
create table BOOKLENDING
(
  lendingid   INTEGER generated always as identity,
  lendingdate DATE default SYSDATE not null,
  duedate     DATE default TRUNC(SYSDATE)+14 not null,
  returndate  DATE,
  clientid    VARCHAR2(9) not null,
  librarianid VARCHAR2(9) not null,
  copyid      NUMBER(8) not null
)
;
alter table BOOKLENDING
  add constraint BOOKLENDING_PK primary key (LENDINGID);
alter table BOOKLENDING
  add foreign key (CLIENTID)
  references CLIENT (CLIENTID);
alter table BOOKLENDING
  add foreign key (LIBRARIANID)
  references LIBRARIAN (LIBRARIANID);
alter table BOOKLENDING
  add foreign key (COPYID)
  references BOOKCOPY (COPYID);
alter table BOOKLENDING
  add constraint BOOK_DUEDATE_CH
  check (duedate >= lendingdate)
  novalidate;
alter table BOOKLENDING
  add constraint BOOK_RETURNDATE_CH
  check (returnDate >=  TRUNC(lendingDate));

prompt Creating BOOK_AUTHOR...
create table BOOK_AUTHOR
(
  author VARCHAR2(100) not null,
  bookid NUMBER(6) not null
)
;
alter table BOOK_AUTHOR
  add primary key (AUTHOR, BOOKID);
alter table BOOK_AUTHOR
  add foreign key (BOOKID)
  references BOOK (BOOKID);

prompt Creating FINES...
create table FINES
(
  clientid  VARCHAR2(9) not null,
  totalfine NUMBER(5) not null
)
;
alter table FINES
  add primary key (CLIENTID);
alter table FINES
  add foreign key (CLIENTID)
  references CLIENT (CLIENTID);

prompt Creating NOTIFICATIONS...
create table NOTIFICATIONS
(
  notifyid INTEGER generated always as identity,
  personid VARCHAR2(9) not null,
  msg      VARCHAR2(500) not null,
  msgdate  DATE default SYSDATE not null
)
;
alter table NOTIFICATIONS
  add primary key (NOTIFYID);
alter table NOTIFICATIONS
  add foreign key (PERSONID)
  references PERSON (PERSONID);

prompt Creating PLAYCATEGORY...
create table PLAYCATEGORY
(
  categoryid   NUMBER(3) not null,
  categoryname VARCHAR2(50) not null
)
;
alter table PLAYCATEGORY
  add primary key (CATEGORYID);
alter table PLAYCATEGORY
  add constraint PLAY_CATEGORY_UNIQUE unique (CATEGORYNAME);

prompt Creating PLAYPUBLISHER...
create table PLAYPUBLISHER
(
  publisherid   NUMBER(4) not null,
  publishername VARCHAR2(50) not null
)
;
alter table PLAYPUBLISHER
  add primary key (PUBLISHERID);
alter table PLAYPUBLISHER
  add constraint PLAY_PUBLISHER_UNIQUE unique (PUBLISHERNAME);

prompt Creating PLAY...
create table PLAY
(
  playid      NUMBER(6) not null,
  playname    VARCHAR2(50) not null,
  categoryid  NUMBER(3) not null,
  publisherid NUMBER(4) not null
)
;
alter table PLAY
  add primary key (PLAYID);
alter table PLAY
  add foreign key (CATEGORYID)
  references PLAYCATEGORY (CATEGORYID);
alter table PLAY
  add foreign key (PUBLISHERID)
  references PLAYPUBLISHER (PUBLISHERID);

prompt Creating PLAYCOPY...
create table PLAYCOPY
(
  copyid    NUMBER(8) not null,
  available NUMBER(1) default 1 not null,
  playid    NUMBER(6) not null
)
;
alter table PLAYCOPY
  add primary key (COPYID);
alter table PLAYCOPY
  add foreign key (PLAYID)
  references PLAY (PLAYID);
alter table PLAYCOPY
  add constraint PLAY_AVAILABLE_CH
  check (available IN(0,1));

prompt Creating PLAYLENDING...
create table PLAYLENDING
(
  lendingid   INTEGER not null,
  lendingdate DATE default SYSDATE not null,
  duedate     DATE default TRUNC(SYSDATE)+14 not null,
  returndate  DATE,
  copyid      NUMBER(8) not null,
  clientid    VARCHAR2(9) not null,
  librarianid VARCHAR2(9) not null
)
;
alter table PLAYLENDING
  add primary key (LENDINGID);
alter table PLAYLENDING
  add foreign key (COPYID)
  references PLAYCOPY (COPYID);
alter table PLAYLENDING
  add foreign key (CLIENTID)
  references CLIENT (CLIENTID);
alter table PLAYLENDING
  add foreign key (LIBRARIANID)
  references LIBRARIAN (LIBRARIANID);
alter table PLAYLENDING
  add constraint PLAY_DUEDATE_CH
  check (duedate > lendingdate)
  novalidate;
alter table PLAYLENDING
  add constraint PLAY_RETURNDATE_CH
  check (returnDate >=  lendingDate);

prompt Disabling triggers for BOOKCATEGORY...
alter table BOOKCATEGORY disable all triggers;
prompt Disabling triggers for BOOKPUBLISHER...
alter table BOOKPUBLISHER disable all triggers;
prompt Disabling triggers for BOOK...
alter table BOOK disable all triggers;
prompt Disabling triggers for BOOKCOPY...
alter table BOOKCOPY disable all triggers;
prompt Disabling triggers for PERSON...
alter table PERSON disable all triggers;
prompt Disabling triggers for CLIENT...
alter table CLIENT disable all triggers;
prompt Disabling triggers for LIBRARIAN...
alter table LIBRARIAN disable all triggers;
prompt Disabling triggers for BOOKLENDING...
alter table BOOKLENDING disable all triggers;
prompt Disabling triggers for BOOK_AUTHOR...
alter table BOOK_AUTHOR disable all triggers;
prompt Disabling triggers for FINES...
alter table FINES disable all triggers;
prompt Disabling triggers for NOTIFICATIONS...
alter table NOTIFICATIONS disable all triggers;
prompt Disabling triggers for PLAYCATEGORY...
alter table PLAYCATEGORY disable all triggers;
prompt Disabling triggers for PLAYPUBLISHER...
alter table PLAYPUBLISHER disable all triggers;
prompt Disabling triggers for PLAY...
alter table PLAY disable all triggers;
prompt Disabling triggers for PLAYCOPY...
alter table PLAYCOPY disable all triggers;
prompt Disabling triggers for PLAYLENDING...
alter table PLAYLENDING disable all triggers;
prompt Disabling foreign key constraints for BOOK...
alter table BOOK disable constraint SYS_C009920;
alter table BOOK disable constraint SYS_C009921;
prompt Disabling foreign key constraints for BOOKCOPY...
alter table BOOKCOPY disable constraint SYS_C009928;
prompt Disabling foreign key constraints for CLIENT...
alter table CLIENT disable constraint SYS_C009939;
prompt Disabling foreign key constraints for LIBRARIAN...
alter table LIBRARIAN disable constraint SYS_C009945;
prompt Disabling foreign key constraints for BOOKLENDING...
alter table BOOKLENDING disable constraint SYS_C009953;
alter table BOOKLENDING disable constraint SYS_C009954;
alter table BOOKLENDING disable constraint SYS_C009955;
prompt Disabling foreign key constraints for BOOK_AUTHOR...
alter table BOOK_AUTHOR disable constraint SYS_C009959;
prompt Disabling foreign key constraints for FINES...
alter table FINES disable constraint SYS_C0010043;
prompt Disabling foreign key constraints for NOTIFICATIONS...
alter table NOTIFICATIONS disable constraint SYS_C0010049;
prompt Disabling foreign key constraints for PLAY...
alter table PLAY disable constraint SYS_C009971;
alter table PLAY disable constraint SYS_C009972;
prompt Disabling foreign key constraints for PLAYCOPY...
alter table PLAYCOPY disable constraint SYS_C009977;
prompt Disabling foreign key constraints for PLAYLENDING...
alter table PLAYLENDING disable constraint SYS_C009985;
alter table PLAYLENDING disable constraint SYS_C009986;
alter table PLAYLENDING disable constraint SYS_C009987;
prompt Deleting PLAYLENDING...
delete from PLAYLENDING;
commit;
prompt Deleting PLAYCOPY...
delete from PLAYCOPY;
commit;
prompt Deleting PLAY...
delete from PLAY;
commit;
prompt Deleting PLAYPUBLISHER...
delete from PLAYPUBLISHER;
commit;
prompt Deleting PLAYCATEGORY...
delete from PLAYCATEGORY;
commit;
prompt Deleting NOTIFICATIONS...
delete from NOTIFICATIONS;
commit;
prompt Deleting FINES...
delete from FINES;
commit;
prompt Deleting BOOK_AUTHOR...
delete from BOOK_AUTHOR;
commit;
prompt Deleting BOOKLENDING...
delete from BOOKLENDING;
commit;
prompt Deleting LIBRARIAN...
delete from LIBRARIAN;
commit;
prompt Deleting CLIENT...
delete from CLIENT;
commit;
prompt Deleting PERSON...
delete from PERSON;
commit;
prompt Deleting BOOKCOPY...
delete from BOOKCOPY;
commit;
prompt Deleting BOOK...
delete from BOOK;
commit;
prompt Deleting BOOKPUBLISHER...
delete from BOOKPUBLISHER;
commit;
prompt Deleting BOOKCATEGORY...
delete from BOOKCATEGORY;
commit;
prompt Loading BOOKCATEGORY...
insert into BOOKCATEGORY (categoryid, categoryname)
values (1, 'Action');
insert into BOOKCATEGORY (categoryid, categoryname)
values (2, 'Art');
insert into BOOKCATEGORY (categoryid, categoryname)
values (3, 'Autobiography');
insert into BOOKCATEGORY (categoryid, categoryname)
values (4, 'Biography');
insert into BOOKCATEGORY (categoryid, categoryname)
values (5, 'Business');
insert into BOOKCATEGORY (categoryid, categoryname)
values (6, 'Children''s');
insert into BOOKCATEGORY (categoryid, categoryname)
values (7, 'Comic ');
insert into BOOKCATEGORY (categoryid, categoryname)
values (8, 'Cookbook');
insert into BOOKCATEGORY (categoryid, categoryname)
values (9, 'Diary');
insert into BOOKCATEGORY (categoryid, categoryname)
values (10, 'Dictionary');
insert into BOOKCATEGORY (categoryid, categoryname)
values (11, 'Encyclopedia');
insert into BOOKCATEGORY (categoryid, categoryname)
values (12, 'Fantasy');
insert into BOOKCATEGORY (categoryid, categoryname)
values (13, 'Guide');
insert into BOOKCATEGORY (categoryid, categoryname)
values (14, 'Health');
insert into BOOKCATEGORY (categoryid, categoryname)
values (15, 'Historical fiction');
insert into BOOKCATEGORY (categoryid, categoryname)
values (16, 'History');
insert into BOOKCATEGORY (categoryid, categoryname)
values (17, 'Hobbies');
insert into BOOKCATEGORY (categoryid, categoryname)
values (18, 'Home and garden');
insert into BOOKCATEGORY (categoryid, categoryname)
values (19, 'Humor');
insert into BOOKCATEGORY (categoryid, categoryname)
values (20, 'Journal');
insert into BOOKCATEGORY (categoryid, categoryname)
values (21, 'Math');
insert into BOOKCATEGORY (categoryid, categoryname)
values (22, 'Mystery');
insert into BOOKCATEGORY (categoryid, categoryname)
values (23, 'Philosophy');
insert into BOOKCATEGORY (categoryid, categoryname)
values (24, 'Picture book');
insert into BOOKCATEGORY (categoryid, categoryname)
values (25, 'Poetry');
insert into BOOKCATEGORY (categoryid, categoryname)
values (26, 'Political thriller');
insert into BOOKCATEGORY (categoryid, categoryname)
values (27, 'Satire');
insert into BOOKCATEGORY (categoryid, categoryname)
values (28, 'Science');
insert into BOOKCATEGORY (categoryid, categoryname)
values (29, 'Science fiction');
insert into BOOKCATEGORY (categoryid, categoryname)
values (30, 'Short story');
insert into BOOKCATEGORY (categoryid, categoryname)
values (31, 'Suspense');
insert into BOOKCATEGORY (categoryid, categoryname)
values (32, 'Thriller');
insert into BOOKCATEGORY (categoryid, categoryname)
values (33, 'Travel');
commit;
prompt 33 records loaded
prompt Loading BOOKPUBLISHER...
insert into BOOKPUBLISHER (publisherid, publishername)
values (1, 'Macmillan');
insert into BOOKPUBLISHER (publisherid, publishername)
values (2, 'Cambridge University Press');
insert into BOOKPUBLISHER (publisherid, publishername)
values (3, 'Penguin Random House');
insert into BOOKPUBLISHER (publisherid, publishername)
values (4, 'SImon and Schuster');
insert into BOOKPUBLISHER (publisherid, publishername)
values (5, 'Scholastic');
insert into BOOKPUBLISHER (publisherid, publishername)
values (6, 'ABC Publishing');
insert into BOOKPUBLISHER (publisherid, publishername)
values (7, 'BAR Publishing');
insert into BOOKPUBLISHER (publisherid, publishername)
values (8, 'Berg Publishers');
insert into BOOKPUBLISHER (publisherid, publishername)
values (9, 'Goodfellow Publishers');
insert into BOOKPUBLISHER (publisherid, publishername)
values (10, 'Hachette Books');
insert into BOOKPUBLISHER (publisherid, publishername)
values (11, 'HarperCollins');
insert into BOOKPUBLISHER (publisherid, publishername)
values (12, 'HarperCollins Publishers');
insert into BOOKPUBLISHER (publisherid, publishername)
values (13, 'Houghton MIfflin Harcourt Publishing Company');
insert into BOOKPUBLISHER (publisherid, publishername)
values (14, 'Wiley');
insert into BOOKPUBLISHER (publisherid, publishername)
values (15, 'Pearson');
insert into BOOKPUBLISHER (publisherid, publishername)
values (16, 'Ashgate Publishing');
insert into BOOKPUBLISHER (publisherid, publishername)
values (17, 'Baen');
insert into BOOKPUBLISHER (publisherid, publishername)
values (18, 'Bella books');
insert into BOOKPUBLISHER (publisherid, publishername)
values (19, 'Black Dog Publishing');
insert into BOOKPUBLISHER (publisherid, publishername)
values (20, 'Bloomsbury Publishing');
insert into BOOKPUBLISHER (publisherid, publishername)
values (21, 'Bonnier Books');
insert into BOOKPUBLISHER (publisherid, publishername)
values (22, 'Chronicle Books');
insert into BOOKPUBLISHER (publisherid, publishername)
values (23, 'DELTA publishing');
insert into BOOKPUBLISHER (publisherid, publishername)
values (24, 'Gefen Publishing House');
insert into BOOKPUBLISHER (publisherid, publishername)
values (25, 'Koren Publishers');
insert into BOOKPUBLISHER (publisherid, publishername)
values (26, 'Feldheim publishers');
insert into BOOKPUBLISHER (publisherid, publishername)
values (27, 'Hachai Publishing');
insert into BOOKPUBLISHER (publisherid, publishername)
values (28, 'Judaica Press');
insert into BOOKPUBLISHER (publisherid, publishername)
values (29, 'Ben Yehuda Press');
insert into BOOKPUBLISHER (publisherid, publishername)
values (30, 'Carmel Publishing House');
insert into BOOKPUBLISHER (publisherid, publishername)
values (31, 'Jewish Publication Society');
insert into BOOKPUBLISHER (publisherid, publishername)
values (32, 'Schocken');
commit;
prompt 32 records loaded
prompt Loading BOOK...
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (334, 'Waitress', 537, 'Arabic', 4, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (335, 'God of Cookery (Sik san)', 689, 'French', 12, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (336, 'Abbott and Costello Go to Mars', 807, 'Yiddish', 18, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (337, 'Gold of Naples, The (L''oro di Napoli)', 251, 'Hebrew', 16, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (338, 'Bad Chicken', 739, 'Arabic', 2, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (339, 'Munich', 375, 'Yiddish', 28, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (340, 'Buddy Holly Story, The', 898, 'French', 27, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (341, 'Song of Freedom', 660, 'French', 21, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (342, 'Cockpit', 514, 'English', 8, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (343, 'One Trick Pony', 832, 'Russian', 5, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (344, 'O.C. and Stiggs', 704, 'French', 24, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (345, 'Rigor Mortis (Geung si)', 602, 'English', 30, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (346, 'Unholy Three, The', 163, 'Yiddish', 21, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (347, 'Jack-O', 549, 'Russian', 16, 29);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (348, 'Chapter 27', 480, 'Arabic', 28, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (349, 'Impy''s Island', 347, 'Spanish', 14, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (350, 'Big Bad Mama II', 384, 'Arabic', 23, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (351, 'Robinson in Space', 556, 'Yiddish', 1, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (352, 'American Vagabond', 436, 'Russian', 19, 23);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (353, 'Porgy and Bess', 480, 'French', 12, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (354, 'Wolves', 217, 'Arabic', 1, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (355, 'They Call Me Renegade', 72, 'Spanish', 24, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (356, 'Los Marziano', 741, 'Yiddish', 9, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (357, 'London Conspiracy', 134, 'English', 17, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (358, 'Simply Irresistible', 641, 'Hebrew', 21, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (359, 'Stepmom', 851, 'Arabic', 27, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (360, 'Hidden Face, The (La cara oculta)', 555, 'Russian', 18, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (361, 'Beefcake', 53, 'Spanish', 8, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (363, 'Holiday in Handcuffs', 963, 'Russian', 21, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (364, 'Jason Becker: Not Dead Yet', 385, 'Arabic', 5, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (365, 'Tsotsi', 432, 'French', 17, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (366, 'Death at a Funeral', 919, 'Arabic', 3, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (367, 'Goodbye Charlie', 412, 'Hebrew', 24, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (368, 'Hotel', 50, 'Russian', 15, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (369, 'Every Other Weekend (Un week-end sur deux)', 869, 'Russian', 7, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (370, 'The Burglar', 566, 'Russian', 31, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (371, 'Meet the Feebles', 662, 'Arabic', 20, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (372, 'Lord of the Flies', 44, 'Russian', 19, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (373, 'When in Rome', 835, 'French', 18, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (374, 'King Lear (Korol Lir)', 517, 'Yiddish', 26, 6);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (375, 'Man of the House', 407, 'French', 30, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (376, 'Decampitated', 693, 'Spanish', 16, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (377, 'Suriyothai (a.k.a. Legend of Suriyothai, The)', 478, 'Hebrew', 4, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (378, 'Blade Runner', 27, 'Arabic', 25, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (379, 'Lifeguard', 358, 'French', 32, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (381, 'Confessions of a Teenage Drama Queen', 288, 'Russian', 5, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (382, 'Man of Aran', 66, 'French', 12, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (383, 'Spies Like Us', 898, 'Spanish', 11, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (384, 'Double Dhamaal', 227, 'Spanish', 15, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (385, 'Two Crimes (Dos cr?menes)', 636, 'Hebrew', 28, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (386, 'Boat People (Tau ban no hoi)', 92, 'Yiddish', 25, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (387, 'Turtle Diary', 968, 'Spanish', 10, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (388, 'For Whom the Bell Tolls', 467, 'French', 13, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (389, 'On the Run', 718, 'Russian', 10, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (390, 'My Left Eye Sees Ghosts (Ngo joh aan gin diy gwai)', 664, 'Hebrew', 26, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (391, 'Late Night Shopping', 703, 'Russian', 18, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (392, 'Tracy Morgan: Black and Blue', 207, 'Spanish', 23, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (393, 'Birdsong (Cant dels ocells, El)', 932, 'Arabic', 25, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (394, 'Dark Wind, The', 353, 'Russian', 11, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (395, 'Fantomas', 801, 'English', 10, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (396, 'Pride and Prejudice', 879, 'Russian', 3, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (397, 'The Butter Battle Book', 637, 'Russian', 20, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (398, 'Sand Sharks', 775, 'Hebrew', 16, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (399, 'Not Without My Daughter', 271, 'Yiddish', 16, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (400, 'RoboCop 2', 905, 'Arabic', 10, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (401, 'Betrayal', 657, 'Spanish', 30, 29);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (402, 'Midnight Dancers (Sibak)', 470, 'English', 8, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (404, 'Bolt', 169, 'Arabic', 26, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (405, 'Behind Enemy Lines', 35, 'Yiddish', 8, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (406, 'Skinwalkers', 302, 'Russian', 24, 6);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (407, 'Ars?ne Lupin', 51, 'Russian', 9, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (408, 'Mechanic, The', 43, 'English', 33, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (409, 'Imitation of Life', 735, 'French', 15, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (410, 'Rogue Trader', 688, 'French', 6, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (412, 'Parenthood', 9, 'Spanish', 15, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (413, 'Nothing But the Truth', 302, 'English', 20, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (414, 'Youngblood', 292, 'Yiddish', 27, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (415, 'Spring Subway', 564, 'Arabic', 11, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (416, 'Upstairs and Downstairs', 873, 'Spanish', 17, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (417, 'Escape to Athena', 886, 'Hebrew', 17, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (418, 'Mr. Skeffington', 467, 'French', 19, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (419, 'Harder They Fall, The', 481, 'Yiddish', 27, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (420, 'Don Quixote (Don Quijote de Orson Welles)', 885, 'English', 33, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (421, 'Street Fighter: Assassin''s Fist', 490, 'French', 26, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (422, 'Raze', 325, 'English', 5, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (423, 'Human Nature', 772, 'Hebrew', 16, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (424, 'Mad Max Beyond Thunderdome', 242, 'Hebrew', 27, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (425, 'Comedy of Innocence (Com?die de l''innocence)', 702, 'Hebrew', 26, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (426, 'How to Live Forever', 312, 'Russian', 14, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (427, 'Besieged (a.k.a. L'' Assedio)', 413, 'Russian', 23, 6);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (428, 'Life and Death of Colonel Blimp, The', 359, 'French', 25, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (429, 'Young Guns', 103, 'Arabic', 25, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (430, 'Satan''s Sword (Daibosatsu t?ge)', 15, 'English', 14, 23);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (431, 'Robin Williams: Weapons of Self Destruction', 772, 'Russian', 25, 29);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (432, 'The Wind in the Willows', 400, 'Russian', 8, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (433, 'Batman', 410, 'Hebrew', 8, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (435, 'Closet, The (Placard, Le)', 913, 'French', 13, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (436, '10', 399, 'Spanish', 3, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (437, 'Invincible Iron Man, The', 18, 'French', 12, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (438, 'Snails, The (Escargots, Les)', 588, 'French', 23, 9);
commit;
prompt 100 records committed...
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (439, 'In a Town This Size', 24, 'Arabic', 17, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (440, 'The Returned', 199, 'Yiddish', 12, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (441, 'Johnny Guitar', 916, 'French', 22, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (442, 'Wedding Planner, The', 985, 'Arabic', 31, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (443, 'Brick Lane', 603, 'Yiddish', 3, 29);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (444, 'Jason Goes to Hell: The Final Friday', 577, 'Yiddish', 2, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (446, 'Scum', 295, 'Arabic', 11, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (447, 'Love Streams', 504, 'English', 9, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (448, 'Chase, The', 376, 'Hebrew', 8, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (449, 'Stuart: A Life Backward', 29, 'French', 11, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (450, 'Arizona Raiders', 374, 'Arabic', 18, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (451, 'Nights in Rodanthe', 193, 'Yiddish', 23, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (452, 'Jean Gentil', 435, 'Yiddish', 19, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (453, 'Bombay Talkie', 16, 'English', 9, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (454, 'Deck the Halls', 592, 'French', 22, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (455, 'Dragon Seed', 117, 'Spanish', 23, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (456, 'Frozen', 433, 'Hebrew', 28, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (457, 'Mutants', 142, 'English', 19, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (459, 'Man of Tai Chi', 453, 'Hebrew', 12, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (460, 'Knock on Any Door', 933, 'Arabic', 19, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (461, 'Swann in Love (Un amour de Swann)', 757, 'Yiddish', 12, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (462, 'Flypaper', 990, 'Spanish', 12, 23);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (463, 'This Is England', 172, 'Russian', 13, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (464, 'Story of Seabiscuit, The', 760, 'Spanish', 23, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (465, 'Mister Buddwing', 297, 'English', 17, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (466, 'A Year Along the Abandoned Road', 940, 'English', 23, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (467, 'Do Fish Do It? (Fickende Fische)', 866, 'Russian', 14, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (468, 'Three Brave Men', 290, 'Yiddish', 4, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (469, 'Rampo (a.k.a. The Mystery of Rampo)', 430, 'Russian', 16, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (470, 'Love and Death on Long Island', 562, 'Hebrew', 12, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (471, 'Sun Also Rises, The (Tai yang zhao chang sheng qi)', 510, 'Russian', 8, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (472, 'Firestarter', 809, 'Yiddish', 6, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (473, 'Schultze Gets the Blues', 187, 'Russian', 11, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (474, 'Sexo, Amor e Trai??o', 310, 'Yiddish', 24, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (475, 'Finger, The (Dedo, El)', 939, 'Spanish', 8, 29);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (476, 'Bongwater', 58, 'Russian', 31, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (478, 'A Muppet Family Vacation', 326, 'Hebrew', 22, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (479, 'Walk Like a Man', 229, 'Russian', 30, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (480, 'His Girl Friday', 744, 'Arabic', 29, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (481, 'Barefoot Executive, The', 754, 'French', 23, 6);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (483, 'Twelve O''Clock High', 49, 'Russian', 28, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (484, 'Theatre of Blood', 677, 'Arabic', 29, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (485, 'Fill the Void (Lemale et ha''halal)', 514, 'Yiddish', 7, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (486, 'Little Miss Sunshine', 388, 'French', 29, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (487, 'Borrower, The', 245, 'Hebrew', 5, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (488, 'Don', 437, 'Arabic', 3, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (489, 'Something Borrowed', 973, 'Spanish', 11, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (490, 'Man of No Importance, A', 78, 'Yiddish', 30, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (491, 'America: Imagine the World Without Her', 814, 'Russian', 24, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (492, 'House', 573, 'Hebrew', 4, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (493, 'Tombstone', 461, 'Arabic', 3, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (494, 'Volver', 416, 'Hebrew', 25, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (495, 'Turner & Hooch', 505, 'English', 32, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (496, 'Attack, The', 100, 'French', 22, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (497, 'Avengers, The', 628, 'Hebrew', 16, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (498, 'Pok?mon: The First Movie', 757, 'Arabic', 33, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (499, 'Yamla Pagla Deewana 2', 484, 'French', 25, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (500, 'Killing of John Lennon, The', 402, 'French', 27, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (1, 'Den enskilde medborgaren', 171, 'Hebrew', 3, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (2, 'Best Intentions, The (Den goda viljan)', 100, 'Hebrew', 18, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (3, 'Fountain, The', 617, 'Spanish', 21, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (4, 'Always', 12, 'English', 26, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (5, 'Aamir', 295, 'English', 31, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (6, 'Until the End of the World (Bis ans Ende der Welt)', 524, 'Spanish', 22, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (7, 'Hansel & Gretel', 149, 'English', 1, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (8, 'Dude, Where''s My Car?', 227, 'Spanish', 13, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (9, 'Original Gangstas', 788, 'Russian', 29, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (10, 'Mutant Chronicles', 463, 'English', 31, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (11, 'Still Breathing', 39, 'Arabic', 17, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (12, 'Broadway Melody of 1940', 305, 'Spanish', 8, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (13, 'Pumpkinhead', 614, 'Hebrew', 17, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (14, 'Ladies in Lavender', 794, 'Russian', 25, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (15, 'GasLand', 550, 'English', 23, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (16, 'Holding, The', 229, 'English', 33, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (18, 'Lotto Land', 698, 'English', 9, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (19, 'Lucky Star', 447, 'French', 5, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (20, 'Day of the Dead 2: Contagium', 461, 'Arabic', 5, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (21, 'Wrestling Ernest Hemingway', 363, 'Spanish', 33, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (23, 'Los Marziano', 968, 'Arabic', 5, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (24, 'Rock & Rule', 859, 'English', 21, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (25, 'Salaam Bombay!', 688, 'English', 2, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (26, 'The Hire: Powder Keg', 504, 'English', 5, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (27, 'In the City (En la ciudad)', 376, 'Arabic', 6, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (28, 'Saving Otter 501', 61, 'Arabic', 23, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (29, 'Melvin and Howard', 906, 'Spanish', 25, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (30, 'Malice', 663, 'Hebrew', 5, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (31, 'Vlad Tepes (Vlad ;epe;)', 5, 'English', 33, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (32, 'Die! Die! My Darling! (Fanatic)', 114, 'Spanish', 10, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (33, 'Dragon Hunters (Chasseurs de dragons)', 176, 'Hebrew', 31, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (34, 'Sherlock Holmes', 25, 'Hebrew', 9, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (35, 'Stephanie Daley', 906, 'Hebrew', 15, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (36, 'Desperate Search', 751, 'French', 7, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (37, 'Lost in Space', 702, 'English', 19, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (38, 'Suture', 595, 'Yiddish', 5, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (39, '6954 Kilometri? Kotiin', 372, 'Hebrew', 1, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (41, 'Spiderwick Chronicles, The', 903, 'Hebrew', 18, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (42, 'Ocean Heaven ', 167, 'Hebrew', 18, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (43, 'Blue', 496, 'Hebrew', 18, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (44, 'Ninja: Shadow of a Tear', 439, 'English', 25, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (45, 'Bohemian Eyes (Boheemi el?? - Matti Pellonp??)', 612, 'Arabic', 5, 17);
commit;
prompt 200 records committed...
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (46, 'Brother Rat', 506, 'French', 3, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (47, 'French Twist (Gazon maudit)', 522, 'Arabic', 28, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (48, 'Double Wedding', 95, 'Hebrew', 22, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (49, 'Tillie''s Punctured Romance', 945, 'Hebrew', 31, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (50, 'Manborg', 317, 'Russian', 14, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (51, 'Invisible Target (Naam yi boon sik)', 220, 'Russian', 11, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (52, '4 Little Girls', 579, 'English', 28, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (53, 'Fritz the Cat', 883, 'Arabic', 17, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (54, 'Hatari!', 822, 'English', 23, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (55, 'Steppenwolf', 709, 'English', 16, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (56, 'Get Thrashed: The Story of Thrash Metal', 654, 'Russian', 29, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (57, 'Nightmare Alley', 296, 'Arabic', 29, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (58, 'Yes Man', 332, 'Hebrew', 23, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (59, 'Bambou', 729, 'French', 16, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (61, 'Happy Vacation', 117, 'French', 27, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (62, 'High Strung', 260, 'Hebrew', 23, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (63, 'Carol for Another Vacation', 793, 'Spanish', 8, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (64, 'Silent Action', 754, 'Spanish', 25, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (65, 'Viva', 462, 'Hebrew', 10, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (66, 'Raging Bull', 670, 'Spanish', 1, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (67, 'Great Day in the Morning', 55, 'Arabic', 31, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (69, 'Terminator 3: Rise of the Machines', 884, 'French', 1, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (70, 'A Lesson Before Dying', 580, 'English', 4, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (71, 'Salut cousin!', 788, 'Russian', 19, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (72, 'Glory Daze', 3, 'Yiddish', 17, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (73, 'No Man''s Land', 229, 'Yiddish', 4, 6);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (74, 'Feel the Noise', 232, 'Yiddish', 26, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (75, 'Mannequin 2: On the Move', 71, 'Russian', 33, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (76, 'Fire and Ice', 442, 'Spanish', 7, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (77, 'Grave, The', 944, 'Russian', 3, 6);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (78, 'Clerks', 908, 'Hebrew', 31, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (79, 'Krrish 3', 116, 'English', 27, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (80, 'Nightmare on Elm Street 5: The Dream Child, A', 111, 'Hebrew', 29, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (81, 'Sitcom', 442, 'Arabic', 33, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (82, 'First Comes Love', 615, 'French', 9, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (83, 'I Am Santa Claus', 981, 'Spanish', 2, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (84, 'Dating the Enemy', 957, 'English', 25, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (85, 'Jealousy', 617, 'Yiddish', 14, 23);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (86, 'Watch on the Rhine', 12, 'English', 18, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (87, 'Puccini for Beginners', 419, 'Spanish', 27, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (88, 'Top Secret!', 710, 'Spanish', 7, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (89, 'Arizona Dream', 847, 'Spanish', 9, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (90, 'Call, The', 187, 'Arabic', 8, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (91, 'Honeymoon', 115, 'Russian', 17, 29);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (92, 'Stars', 384, 'Russian', 25, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (93, 'Cool World', 271, 'French', 32, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (94, 'Resan Till Melonia', 530, 'Hebrew', 16, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (95, 'Sunshine', 131, 'Russian', 25, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (96, 'Genova (Summer in Genoa, A)', 126, 'Yiddish', 18, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (97, 'Slender Thread, The', 924, 'Arabic', 19, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (98, 'My Boyfriend''s Back', 854, 'Russian', 18, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (99, 'Trouble in Mind', 345, 'Arabic', 1, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (100, 'Forbidden City Cop (Dai lap mat tam 008)', 486, 'French', 21, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (101, 'Possession of David O''Reilly, The ', 199, 'English', 24, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (102, 'The Magnificent Gladiator', 97, 'French', 6, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (103, 'Dark Half, The', 107, 'Russian', 28, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (104, 'Ride with the Devil', 434, 'Russian', 13, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (106, 'Redemption (Hummingbird)', 498, 'French', 12, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (107, 'Singles', 987, 'Spanish', 26, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (108, 'Honeymooners, The', 564, 'French', 14, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (109, '2 + 2 (Dos m?s dos)', 740, 'Arabic', 19, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (110, 'Secret Ceremony', 664, 'Hebrew', 1, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (111, 'Cargo', 941, 'Hebrew', 12, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (112, 'Final Option, The (Who Dares Wins)', 907, 'Yiddish', 1, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (113, 'Gods and Monsters', 613, 'Yiddish', 26, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (114, 'Harvest', 53, 'Hebrew', 23, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (115, 'Zero Years, The', 337, 'Arabic', 33, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (116, 'Gertie the Dinosaur', 13, 'Yiddish', 27, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (117, 'A Blank on the Map', 366, 'Yiddish', 18, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (119, 'People, Places, Things', 816, 'Yiddish', 10, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (120, 'Ip Man: The Final Fight', 405, 'Hebrew', 24, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (121, 'Khumba', 960, 'Spanish', 21, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (122, 'Female Agents (Les femmes de l''ombre)', 671, 'Arabic', 24, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (123, 'The Fifth Season', 986, 'Hebrew', 26, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (124, 'Factotum', 53, 'French', 29, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (125, 'Bluebeard (Landru)', 18, 'Yiddish', 2, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (126, 'Braddock: Missing in Action III', 831, 'Yiddish', 26, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (127, 'Sita Sings the Blues', 125, 'Russian', 33, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (128, 'Darkest Hour, The', 96, 'Arabic', 31, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (129, 'Primal', 722, 'Yiddish', 25, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (130, 'George Lopez: Tall, Dark & Chicano', 137, 'Spanish', 26, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (131, 'Peter Pan', 395, 'Spanish', 30, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (132, 'Devil''s Carnival, The', 776, 'Arabic', 33, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (133, 'Just Cause', 194, 'Arabic', 25, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (134, 'Enemy Below, The', 839, 'Hebrew', 4, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (135, 'N?madak TX', 256, 'Arabic', 7, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (136, 'Romeo and Juliet', 877, 'Yiddish', 28, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (137, 'The Oscar', 690, 'Arabic', 1, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (138, 'Parasite', 328, 'Russian', 29, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (139, 'Jesse Stone: Benefit of the Doubt', 650, 'Spanish', 17, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (140, 'Basara: Princess Goh', 152, 'French', 9, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (141, 'Collector, The', 458, 'Hebrew', 19, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (142, 'Rosa Luxemburg', 74, 'Spanish', 20, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (143, 'Fat City', 139, 'Spanish', 31, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (144, 'Experience, The (Tadjrebeh)', 725, 'English', 21, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (145, 'Total Recall', 493, 'Spanish', 21, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (146, 'One Day in September', 478, 'Arabic', 30, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (147, 'Earthquake', 929, 'Arabic', 3, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (148, 'Dead Tired (Grosse Fatigue)', 298, 'Russian', 29, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (149, 'Short Eyes', 195, 'Hebrew', 2, 26);
commit;
prompt 300 records committed...
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (150, 'Mind Reader, The', 801, 'French', 21, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (151, 'Hunter, The', 826, 'Spanish', 9, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (152, 'Red Beret, The', 541, 'Hebrew', 32, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (153, 'Dead Man on Campus', 778, 'Yiddish', 3, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (154, 'Happythankyoumoreplease', 525, 'Yiddish', 25, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (155, 'Beyond the Lights', 411, 'Spanish', 33, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (156, 'No. 1 Ladies'' Detective Agency, The', 138, 'Russian', 5, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (157, 'Raincoat', 761, 'Arabic', 3, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (158, 'Welcome to Collinwood', 745, 'Hebrew', 21, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (159, 'Enemy of the State', 514, 'French', 28, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (160, 'Japon (a.k.a. Japan) (Jap?n)', 777, 'French', 30, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (161, 'Jackass 3.5', 287, 'Russian', 6, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (162, 'Under the Sand', 748, 'Hebrew', 15, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (163, 'The Bride Wore Red', 46, 'Hebrew', 12, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (164, 'Unfinished Song (Song for Marion)', 228, 'Hebrew', 15, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (165, 'The Incident', 272, 'Hebrew', 29, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (166, 'Gunga Din', 74, 'English', 12, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (167, 'Firewalker', 441, 'Hebrew', 11, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (168, 'Reconstituirea (Reconstruction)', 230, 'English', 13, 6);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (169, 'Scarlet Empress, The', 947, 'Hebrew', 23, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (170, 'Numb', 496, 'Russian', 8, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (171, 'Achilles and the Tortoise (Akiresu to kame)', 656, 'Russian', 17, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (172, 'Trial of the Incredible Hulk, The', 747, 'Russian', 12, 29);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (173, 'Exercice de l''?tat, L''', 185, 'Hebrew', 29, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (175, 'Blue Chips', 174, 'Arabic', 24, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (176, 'Mean Machine', 954, 'French', 11, 6);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (177, 'Crude Oasis, The', 405, 'Spanish', 23, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (178, 'Let No Man Write My Epitaph', 612, 'Arabic', 28, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (179, 'Fraternity Demon', 602, 'Yiddish', 17, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (180, 'Nueba Yol', 570, 'Russian', 1, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (181, 'Nobody Owns Me (Mig ?ger ingen)', 990, 'English', 4, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (182, 'Black Friday', 421, 'French', 25, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (184, 'Summer of ''42', 835, 'Yiddish', 5, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (185, 'Attila (Attila the Hun)', 575, 'Spanish', 30, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (186, 'Workingman''s Death', 489, 'French', 5, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (187, 'Far From Home: The Adventures of Yellow Dog', 180, 'English', 11, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (188, 'Sound of My Voice', 130, 'Yiddish', 5, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (189, 'Bill Cosby, Himself', 797, 'Russian', 11, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (190, 'Josie and the Pussycats', 224, 'French', 10, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (191, 'Hellraiser: Bloodline', 660, 'Arabic', 22, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (192, 'Money for Nothing', 268, 'Hebrew', 15, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (193, 'Man Who Sued God, The', 40, 'Arabic', 1, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (194, 'Sweet Nothing', 4, 'Hebrew', 14, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (196, 'All-Star Superman', 249, 'Arabic', 27, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (197, 'Dude, Where''s My Car?', 312, 'Arabic', 1, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (198, 'Jolly Boys'' Last Stand, The', 55, 'Spanish', 1, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (199, 'Miss Representation', 151, 'Russian', 31, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (200, 'Everyone''s Hero', 251, 'Spanish', 28, 23);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (201, 'I Am a Sex Addict', 824, 'Hebrew', 27, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (202, 'Slappy and the Stinkers', 523, 'French', 28, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (203, 'Backflash (Backflash Blues)', 458, 'Russian', 29, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (204, 'Day of the Triffids, The', 239, 'French', 6, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (207, 'Addicted to Love', 713, 'Yiddish', 13, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (208, 'Extraction', 579, 'Arabic', 13, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (209, 'Locke', 548, 'Yiddish', 5, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (210, 'Carrie', 406, 'Russian', 32, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (211, 'Man Vanishes, A (Ningen Johatsu)', 713, 'Spanish', 27, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (212, 'Killing Room, The', 195, 'Spanish', 18, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (213, 'Khumba', 987, 'Yiddish', 27, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (214, 'Man in the Iron Mask, The', 396, 'Spanish', 14, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (215, 'ABCs of Death, The', 810, 'Russian', 4, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (216, 'Death at a Funeral', 986, 'Arabic', 20, 29);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (218, 'Devil, Probably, The (Diable probablement, Le)', 704, 'Yiddish', 23, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (219, 'Dr. Jekyll and Mr. Hyde', 123, 'Hebrew', 11, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (220, 'Just Cause', 845, 'Hebrew', 23, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (221, 'Lord Love a Duck', 585, 'Hebrew', 6, 17);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (222, 'Johnny 100 Pesos (Johnny cien pesos)', 641, 'Arabic', 20, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (223, 'Campfire Tales', 700, 'Hebrew', 15, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (224, 'Happy End', 547, 'French', 30, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (225, 'Journey of Natty Gann, The', 755, 'Hebrew', 19, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (226, 'New Best Friend', 258, 'Russian', 15, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (227, 'Dog Year, A', 347, 'Russian', 28, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (228, 'Animal House', 240, 'Spanish', 8, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (229, 'Pearl, The (La perla)', 643, 'Arabic', 28, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (230, 'Beverly Hills Cop III', 646, 'Yiddish', 6, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (231, 'Danika', 681, 'Arabic', 9, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (232, 'Cool World, The', 857, 'Spanish', 4, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (233, 'Still Alice', 200, 'Yiddish', 10, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (234, 'Tarzan''s New York Adventure', 841, 'Arabic', 5, 24);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (235, 'Pope Joan (Die P?pstin)', 735, 'French', 29, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (236, 'Tatsumi', 920, 'Russian', 13, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (237, 'Burnt by the Sun 2 (Utomlyonnye solntsem 2)', 885, 'Spanish', 11, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (238, 'Lost and Delirious', 768, 'Hebrew', 29, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (239, 'Farewell, The (Abschied - Brechts letzter Sommer)', 743, 'Russian', 27, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (240, 'Teenage Caveman', 177, 'Arabic', 14, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (241, 'Unlikely Weapon, An', 273, 'French', 30, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (242, 'Hellzapoppin''', 509, 'Russian', 32, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (243, 'Two Lovers', 368, 'English', 21, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (244, 'Flannel Pajamas', 276, 'French', 17, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (245, 'Jack Strong', 287, 'Spanish', 18, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (246, 'Executive Suite', 624, 'Yiddish', 4, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (248, 'Wolves', 563, 'English', 4, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (249, 'Girl on a Motorcycle, The', 675, 'English', 24, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (250, 'Lili', 696, 'Russian', 25, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (251, 'Stick', 707, 'French', 31, 13);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (252, '200 Motels', 870, 'French', 16, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (253, 'Loft', 775, 'English', 9, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (254, 'Ten Minutes Older: The Cello', 143, 'Russian', 9, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (255, 'Touch of Evil', 881, 'Arabic', 17, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (256, 'Fine Madness, A', 984, 'Hebrew', 30, 5);
commit;
prompt 400 records committed...
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (257, 'Chance Pe Dance', 393, 'Spanish', 33, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (258, 'Blood of Dracula', 601, 'Yiddish', 18, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (259, 'Red Hill', 7, 'Hebrew', 8, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (260, '9/11', 576, 'Arabic', 26, 27);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (261, 'Me Without You', 708, 'English', 3, 23);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (262, 'House on Sorority Row, The', 749, 'Arabic', 20, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (263, 'Casper''s Haunted Vacation', 329, 'Russian', 2, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (264, 'Hitchhiker''s Guide to the Galaxy, The', 171, 'Russian', 14, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (266, 'Jesse Stone: Thin Ice', 379, 'English', 3, 18);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (267, 'Debt, The', 220, 'Yiddish', 11, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (268, 'All This, and Heaven Too', 22, 'English', 28, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (269, 'Quiet Ones, The', 173, 'Russian', 19, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (270, 'Nashville', 631, 'English', 33, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (271, 'Pitk? kuuma kes?', 647, 'Hebrew', 23, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (272, 'Walk All Over Me', 626, 'Hebrew', 1, 16);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (273, 'Dukes of Hazzard, The', 779, 'Russian', 14, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (274, 'Adventures of Don Juan', 735, 'Russian', 25, 14);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (275, 'Help Me, Eros (Bang bang wo ai shen)', 305, 'English', 33, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (276, 'Hard Word, The', 907, 'Arabic', 4, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (278, 'Grotesque (Gurotesuku)', 293, 'Yiddish', 32, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (279, 'Flow', 916, 'Russian', 8, 23);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (280, 'Afstiros katallilo', 171, 'Yiddish', 23, 23);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (281, 'Dr. Jekyll and Mr. Hyde', 166, 'English', 28, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (282, 'Seopyeonje', 471, 'Hebrew', 25, 8);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (283, 'Suzanne''s Career (La carri?re de Suzanne)', 52, 'Spanish', 14, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (284, 'Easy Come, Easy Go', 112, 'Yiddish', 27, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (285, 'Lourdes', 907, 'Hebrew', 16, 31);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (286, 'Band''s Visit, The (Bikur Ha-Tizmoret)', 743, 'Arabic', 1, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (287, 'Oklahoma!', 146, 'Hebrew', 24, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (288, 'As You Like It', 163, 'English', 21, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (289, 'Perils of the Sentimental Swordsman', 786, 'Russian', 10, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (290, 'Pok?mon the Movie: Black - Victini and Reshiram', 394, 'Hebrew', 23, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (291, 'Dark Corner, The', 32, 'Yiddish', 13, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (292, 'Digimon: The Movie', 77, 'English', 32, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (293, 'Last Ride', 147, 'Arabic', 29, 1);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (294, 'Krabat', 747, 'Hebrew', 12, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (295, '20,000 Years in Sing Sing', 492, 'Yiddish', 25, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (296, 'Big Sur', 465, 'Yiddish', 20, 28);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (297, 'Milky Way, The (Voie lact?e, La)', 799, 'Russian', 30, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (298, 'Hostel: Part III ', 139, 'Hebrew', 30, 6);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (299, 'To Each His Own', 317, 'Spanish', 5, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (300, 'OH in Ohio, The', 346, 'English', 16, 23);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (301, 'Love, Marilyn', 332, 'Arabic', 24, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (302, 'Art of Flight, The', 320, 'Hebrew', 19, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (303, 'D-Day', 741, 'English', 11, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (304, 'Tales from the Crypt', 960, 'Hebrew', 7, 12);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (305, 'Rudo y Cursi (Rough and Vulgar)', 534, 'French', 20, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (306, 'Jerk Theory, The', 969, 'Russian', 23, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (307, 'Miracle at Oxford (True Blue)', 645, 'Arabic', 25, 3);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (308, 'Jim Thorpe -- All-American', 909, 'Russian', 33, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (309, 'Wayward Bus, The', 584, 'Russian', 22, 5);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (310, 'Bride of Frankenstein, The (Bride of Frankenstein)', 814, 'Russian', 27, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (311, 'Wolf', 49, 'English', 19, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (312, 'Wild Hogs', 589, 'Arabic', 21, 11);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (313, 'Kronos (a.k.a. Captain Kronos: Vampire Hunter)', 659, 'French', 27, 7);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (314, 'Prince of Pennsylvania, The', 857, 'Hebrew', 21, 4);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (315, 'Two Weeks in September', 10, 'Yiddish', 33, 20);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (316, 'Detective Story', 776, 'Arabic', 8, 26);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (317, 'Operation Mad Ball', 825, 'Hebrew', 24, 15);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (318, 'Fire Within, The (Feu follet, Le)', 505, 'Hebrew', 20, 19);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (319, 'American Mary', 748, 'Hebrew', 4, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (320, 'Gleaners & I, The (Les glaneurs et la glaneuse)', 194, 'Russian', 31, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (321, 'Love Bites', 357, 'French', 14, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (322, 'First Name: Carmen (Pr?nom Carmen)', 940, 'Yiddish', 14, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (323, 'The 39 Steps', 641, 'French', 8, 22);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (324, 'Vera Cruz', 561, 'Hebrew', 15, 30);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (325, 'Don Quixote (Don Quijote de Orson Welles)', 804, 'Spanish', 6, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (326, 'Cuenca Crime, The (Crimen de Cuenca, El)', 15, 'Hebrew', 5, 10);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (327, 'Strategic Air Command', 339, 'French', 28, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (328, 'White Fang (Zanna Bianca)', 747, 'Arabic', 19, 9);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (329, 'Happy Poet, The', 949, 'Hebrew', 33, 21);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (330, 'Fear and Trembling (Stupeur et tremblements)', 874, 'Hebrew', 11, 25);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (331, 'Heart of a Lion (Leijonasyd?n)', 214, 'English', 14, 2);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (332, 'A Follower for Emily', 90, 'Yiddish', 16, 32);
insert into BOOK (bookid, title, pages, booklanguage, categoryid, publisherid)
values (333, '2012: Supernova', 431, 'Arabic', 7, 11);
commit;
prompt 475 records loaded
prompt Loading BOOKCOPY...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (658, 1, 1999, 1, 492);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (659, 0, 1985, 4, 312);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (660, 0, 2022, 3, 279);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (661, 1, 2022, 2, 178);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (662, 1, 1991, 1, 294);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (663, 0, 2002, 3, 90);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (664, 1, 2021, 3, 215);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (665, 1, 2007, 4, 390);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (666, 1, 1983, 4, 141);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (667, 1, 2007, 3, 227);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (668, 1, 2004, 3, 435);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (669, 0, 2017, 1, 430);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (670, 1, 1993, 2, 450);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (671, 1, 2002, 3, 367);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (672, 1, 1990, 1, 179);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (673, 1, 2018, 2, 129);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (674, 0, 1992, 1, 304);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (675, 0, 2013, 1, 172);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (676, 1, 2011, 4, 147);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (677, 1, 1994, 2, 360);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (678, 1, 2024, 3, 45);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (679, 1, 1988, 3, 394);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (680, 1, 2011, 2, 102);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (681, 1, 2017, 3, 160);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (682, 1, 2018, 1, 377);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (683, 1, 2000, 4, 486);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (684, 1, 2008, 4, 463);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (685, 0, 2017, 4, 295);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (686, 1, 1991, 1, 463);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (687, 1, 2018, 1, 177);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (688, 1, 1993, 1, 395);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (689, 1, 1984, 1, 363);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (690, 1, 1993, 3, 498);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (691, 0, 2020, 1, 93);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (692, 1, 2006, 2, 413);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (693, 1, 2006, 3, 400);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (694, 1, 2005, 2, 324);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (695, 0, 1984, 1, 321);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (696, 0, 1986, 4, 456);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (697, 1, 1980, 3, 462);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (698, 0, 2009, 3, 14);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (699, 0, 2008, 2, 27);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (700, 1, 2024, 4, 3);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (701, 1, 2008, 4, 214);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (702, 0, 1980, 2, 471);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (703, 1, 2021, 4, 33);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (704, 1, 1996, 4, 151);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (705, 0, 2016, 2, 33);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (706, 1, 2004, 1, 13);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (707, 1, 2002, 1, 421);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (708, 1, 1992, 3, 219);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (709, 1, 2017, 3, 104);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (710, 1, 1992, 4, 475);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (711, 0, 2004, 1, 125);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (712, 1, 1990, 4, 326);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (713, 1, 2003, 4, 6);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (714, 1, 1986, 1, 302);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (715, 1, 2010, 2, 13);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (716, 1, 2022, 4, 11);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (717, 0, 2022, 4, 307);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (718, 0, 2005, 2, 135);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (719, 0, 2006, 2, 4);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (720, 1, 1981, 3, 305);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (721, 1, 1982, 1, 160);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (722, 0, 1989, 1, 414);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (723, 1, 2012, 3, 140);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (724, 1, 2008, 4, 324);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (725, 1, 2000, 2, 399);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (726, 0, 2010, 4, 470);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (727, 0, 1980, 3, 188);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (728, 0, 1987, 3, 382);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (729, 0, 1982, 4, 131);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (730, 1, 1986, 1, 115);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (731, 1, 2001, 1, 239);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (732, 1, 1980, 2, 69);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (733, 0, 2013, 3, 319);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (734, 1, 1982, 2, 236);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (735, 1, 1980, 2, 291);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (736, 1, 1985, 2, 339);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (737, 1, 1984, 1, 395);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (738, 1, 2017, 2, 388);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (739, 0, 1983, 1, 348);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (740, 1, 2017, 4, 130);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (741, 1, 1981, 4, 346);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (742, 1, 2007, 3, 401);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (743, 0, 1990, 1, 25);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (744, 1, 1999, 2, 424);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (745, 0, 2003, 1, 299);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (746, 1, 2016, 2, 455);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (747, 1, 1981, 3, 115);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (748, 0, 2022, 3, 373);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (749, 1, 1993, 2, 120);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (750, 0, 2021, 4, 179);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (751, 0, 2005, 4, 212);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (752, 1, 2013, 4, 369);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (753, 1, 2003, 1, 16);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (754, 1, 1986, 4, 255);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (755, 1, 1989, 4, 281);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (756, 0, 1992, 3, 147);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (757, 0, 1998, 1, 125);
commit;
prompt 100 records committed...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (758, 1, 1984, 4, 494);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (759, 1, 1991, 4, 268);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (760, 1, 2013, 3, 376);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (761, 0, 1983, 2, 95);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (762, 0, 2002, 1, 451);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (763, 1, 2012, 3, 185);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (764, 0, 2016, 2, 266);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (765, 1, 1982, 3, 200);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (766, 1, 2017, 1, 2);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (767, 0, 2019, 3, 214);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (768, 1, 1990, 2, 131);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (769, 1, 1983, 4, 420);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (770, 0, 1985, 2, 443);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (771, 1, 1983, 1, 283);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (772, 1, 2007, 3, 21);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (773, 0, 2012, 3, 39);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (774, 1, 2000, 4, 88);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (775, 1, 1995, 1, 171);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (776, 1, 1982, 2, 289);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (777, 0, 1986, 4, 237);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (778, 1, 2016, 1, 351);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (779, 1, 1983, 4, 114);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (780, 1, 2017, 2, 189);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (781, 1, 2013, 3, 180);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (782, 1, 2014, 4, 358);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (783, 1, 2018, 2, 367);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (784, 0, 1986, 4, 484);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (785, 0, 2017, 3, 133);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (786, 1, 1980, 3, 27);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (787, 1, 2020, 2, 333);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (788, 0, 2012, 1, 16);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (789, 1, 1993, 3, 23);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (790, 1, 1990, 4, 155);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (791, 0, 2023, 1, 128);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (792, 0, 2005, 3, 328);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (793, 1, 1998, 4, 56);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (794, 0, 2010, 2, 37);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (795, 1, 2023, 4, 191);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (796, 1, 2006, 4, 232);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (797, 1, 1996, 4, 306);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (798, 1, 2018, 1, 36);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (799, 1, 2006, 4, 374);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (800, 1, 1996, 4, 410);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (801, 0, 1982, 4, 303);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (802, 0, 1995, 2, 188);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (803, 1, 1984, 4, 41);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (804, 1, 2015, 1, 29);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (805, 1, 2014, 3, 130);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (806, 1, 1991, 4, 293);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (807, 1, 2021, 1, 141);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (808, 0, 2013, 2, 299);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (809, 1, 2014, 4, 19);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (810, 0, 1986, 3, 5);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (811, 0, 1999, 3, 333);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (812, 1, 2016, 1, 92);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (813, 1, 1985, 4, 441);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (814, 1, 2005, 4, 437);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (815, 0, 2003, 4, 55);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (816, 0, 2023, 3, 29);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (817, 1, 1994, 2, 207);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (818, 1, 2016, 1, 245);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (819, 1, 1997, 2, 128);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (820, 1, 1989, 2, 74);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (821, 1, 2022, 2, 44);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (822, 0, 2005, 3, 219);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (823, 0, 1989, 4, 347);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (824, 0, 1994, 3, 122);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (825, 0, 1997, 3, 213);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (826, 0, 2008, 3, 383);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (827, 1, 2015, 4, 82);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (828, 1, 2005, 1, 102);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (829, 0, 2003, 3, 85);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (830, 1, 2006, 3, 98);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (831, 0, 1990, 3, 352);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (832, 0, 1992, 4, 71);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (833, 0, 1998, 4, 242);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (834, 0, 2000, 4, 134);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (835, 1, 2012, 3, 450);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (836, 0, 2007, 2, 291);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (837, 1, 2023, 4, 70);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (838, 0, 2002, 2, 279);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (839, 1, 1984, 1, 6);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (840, 1, 1991, 1, 343);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (841, 1, 2010, 3, 346);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (842, 1, 2013, 2, 424);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (843, 0, 2008, 2, 99);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (844, 1, 1984, 1, 220);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (845, 0, 1991, 2, 349);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (846, 1, 2016, 4, 173);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (847, 1, 2009, 3, 342);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (848, 1, 2019, 3, 392);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (849, 0, 1995, 4, 435);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (850, 0, 2002, 4, 419);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (851, 1, 1992, 2, 487);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (852, 0, 2021, 2, 448);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (853, 0, 1988, 2, 137);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (854, 0, 2006, 4, 440);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (855, 1, 1983, 4, 1);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (856, 1, 2014, 4, 142);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (857, 0, 1995, 4, 263);
commit;
prompt 200 records committed...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (858, 1, 1995, 3, 4);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (859, 0, 2015, 2, 177);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (860, 1, 2023, 4, 18);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (861, 1, 1995, 1, 486);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (862, 1, 2000, 4, 450);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (863, 0, 2020, 2, 222);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (864, 0, 2008, 4, 490);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (865, 0, 1999, 4, 436);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (866, 1, 2000, 4, 293);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (867, 1, 2003, 1, 337);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (868, 0, 1991, 2, 439);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (869, 0, 1988, 2, 305);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (870, 1, 2008, 2, 305);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (871, 0, 2022, 1, 340);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (872, 1, 1993, 1, 313);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (873, 0, 1991, 1, 419);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (874, 1, 2005, 3, 124);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (875, 1, 1993, 2, 235);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (876, 1, 2021, 2, 208);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (877, 0, 2024, 1, 354);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (878, 0, 2021, 3, 332);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (879, 0, 1996, 4, 307);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (880, 1, 2008, 1, 466);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (881, 1, 1989, 1, 21);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (882, 0, 1982, 1, 65);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (883, 1, 1987, 1, 234);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (884, 1, 1983, 1, 284);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (885, 0, 2018, 3, 254);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (886, 0, 2011, 4, 89);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (887, 1, 2010, 4, 160);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (888, 1, 2006, 2, 281);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (889, 0, 2007, 4, 405);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (890, 1, 2015, 2, 407);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (891, 1, 2003, 3, 307);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (892, 0, 2024, 2, 113);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (893, 0, 2011, 3, 457);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (894, 0, 2021, 2, 352);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (895, 1, 2010, 2, 50);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (896, 1, 1988, 2, 61);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (897, 1, 2002, 1, 89);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (898, 1, 1992, 4, 173);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (899, 0, 1985, 1, 26);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (900, 1, 2023, 1, 117);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (901, 0, 1991, 3, 288);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (902, 1, 1985, 1, 137);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (903, 0, 2003, 3, 222);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (904, 0, 2005, 3, 91);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (905, 1, 2016, 3, 433);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (906, 0, 2006, 3, 112);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (907, 1, 1980, 2, 63);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (908, 1, 2000, 3, 191);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (909, 1, 1987, 1, 406);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (910, 0, 1997, 1, 171);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (911, 0, 2012, 2, 20);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (912, 0, 2021, 1, 132);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (913, 1, 1993, 4, 162);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (914, 0, 1997, 2, 189);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (915, 1, 2006, 2, 192);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (916, 1, 2019, 4, 212);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (917, 1, 2015, 4, 338);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (918, 1, 1998, 4, 420);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (919, 1, 1981, 4, 400);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (920, 1, 2001, 1, 418);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (921, 1, 2003, 3, 342);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (922, 1, 2019, 2, 109);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (923, 0, 2006, 2, 293);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (924, 0, 2017, 3, 25);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (925, 1, 1997, 1, 450);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (926, 0, 2001, 2, 72);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (927, 0, 2008, 2, 415);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (928, 1, 2008, 3, 165);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (929, 1, 2021, 3, 394);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (930, 1, 2019, 1, 296);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (931, 0, 1982, 1, 336);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (932, 1, 2022, 4, 456);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (933, 1, 1980, 2, 465);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (934, 1, 1998, 1, 35);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (935, 0, 2023, 2, 219);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (936, 0, 2015, 3, 65);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (937, 1, 2010, 2, 93);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (938, 0, 2014, 3, 399);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (939, 1, 1995, 2, 408);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (940, 1, 2021, 2, 313);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (941, 1, 2006, 1, 454);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (942, 1, 2009, 3, 455);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (943, 1, 2016, 1, 59);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (944, 1, 2000, 3, 279);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (945, 1, 2020, 2, 61);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (946, 0, 2002, 3, 307);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (947, 0, 1988, 2, 188);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (948, 0, 2005, 2, 370);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (949, 0, 2017, 4, 345);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (950, 0, 1987, 1, 200);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (951, 1, 1993, 1, 299);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (952, 0, 1988, 1, 448);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (953, 1, 1999, 3, 273);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (954, 0, 2007, 3, 117);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (955, 1, 2007, 3, 456);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (956, 1, 2012, 3, 387);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (957, 1, 1991, 4, 413);
commit;
prompt 300 records committed...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (958, 1, 2005, 1, 360);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (959, 0, 2019, 2, 393);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (960, 1, 2010, 3, 197);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (961, 1, 1981, 4, 57);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (962, 0, 1990, 1, 162);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (963, 0, 2022, 2, 98);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (964, 1, 1997, 2, 97);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (965, 1, 1993, 2, 289);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (966, 0, 2024, 2, 262);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (967, 1, 1994, 2, 405);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (968, 1, 2009, 2, 121);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (969, 0, 1989, 2, 93);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (970, 1, 1982, 2, 5);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (971, 1, 2021, 2, 99);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (972, 0, 2004, 1, 207);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (973, 1, 1985, 4, 446);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (974, 1, 1987, 2, 444);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (975, 0, 2012, 1, 495);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (976, 0, 2022, 4, 290);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (977, 1, 1996, 3, 409);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (978, 0, 1995, 3, 427);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (979, 1, 2003, 4, 46);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (980, 0, 1994, 4, 398);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (981, 0, 2015, 4, 224);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (982, 1, 1999, 4, 188);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (983, 1, 2003, 4, 423);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (984, 1, 1998, 3, 254);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (985, 1, 2010, 2, 391);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (986, 1, 2022, 1, 443);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (987, 1, 1984, 1, 127);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (988, 0, 2019, 3, 341);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (989, 1, 1987, 4, 298);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (990, 1, 2009, 4, 491);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (991, 1, 2001, 1, 58);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (992, 1, 1982, 4, 37);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (993, 0, 1987, 3, 273);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (994, 1, 1993, 3, 293);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (995, 0, 1996, 1, 133);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (996, 0, 2002, 1, 171);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (997, 1, 2021, 2, 207);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (998, 1, 1993, 3, 78);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (999, 1, 2010, 2, 360);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (1000, 0, 2020, 3, 145);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (1, 0, 1990, 4, 36);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (2, 1, 2016, 4, 38);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (3, 1, 1996, 3, 182);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (4, 1, 1996, 3, 235);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (5, 0, 1999, 3, 293);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (6, 1, 2022, 3, 16);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (7, 1, 2015, 2, 125);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (8, 1, 1988, 1, 252);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (9, 1, 2016, 4, 393);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (10, 1, 2005, 2, 270);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (11, 0, 1993, 1, 26);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (12, 1, 2019, 2, 446);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (13, 1, 2001, 3, 299);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (14, 0, 1992, 1, 196);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (15, 1, 2000, 3, 429);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (16, 0, 2007, 4, 355);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (17, 1, 2016, 2, 38);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (18, 0, 2019, 1, 496);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (19, 1, 2008, 1, 16);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (20, 0, 1989, 4, 113);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (21, 1, 2015, 2, 329);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (22, 0, 1983, 2, 256);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (23, 1, 2007, 3, 187);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (24, 1, 2013, 3, 33);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (25, 1, 2012, 1, 158);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (26, 1, 1988, 3, 45);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (27, 1, 1995, 4, 161);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (28, 1, 1989, 4, 211);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (29, 1, 2018, 3, 377);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (30, 0, 2017, 4, 7);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (31, 0, 2008, 2, 74);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (32, 1, 1990, 4, 116);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (33, 0, 1988, 2, 304);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (34, 0, 2006, 3, 463);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (35, 0, 2013, 2, 61);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (36, 1, 2013, 1, 187);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (37, 0, 1980, 2, 297);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (38, 1, 2010, 2, 493);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (39, 0, 1990, 4, 363);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (40, 1, 2011, 2, 421);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (41, 1, 2011, 2, 368);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (42, 0, 2011, 4, 33);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (43, 1, 2001, 1, 417);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (44, 1, 2014, 4, 473);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (45, 1, 1997, 3, 279);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (46, 0, 1991, 1, 474);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (47, 0, 2000, 4, 441);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (48, 1, 2022, 2, 244);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (49, 1, 2005, 2, 107);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (50, 0, 2011, 3, 257);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (51, 1, 2000, 1, 41);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (52, 1, 1995, 3, 473);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (53, 1, 2022, 4, 372);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (54, 1, 2016, 2, 448);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (55, 1, 2010, 3, 290);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (56, 0, 2015, 1, 344);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (57, 1, 2022, 3, 115);
commit;
prompt 400 records committed...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (58, 0, 1999, 2, 360);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (59, 0, 2024, 1, 333);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (60, 1, 2006, 1, 69);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (61, 1, 2002, 1, 486);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (62, 1, 1988, 3, 131);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (63, 1, 2005, 4, 486);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (64, 1, 1985, 4, 472);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (65, 0, 2014, 3, 346);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (66, 1, 1989, 4, 310);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (67, 0, 2010, 4, 309);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (68, 1, 2010, 1, 113);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (69, 0, 2011, 1, 366);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (70, 1, 2015, 2, 468);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (71, 0, 1988, 4, 221);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (72, 0, 2023, 4, 347);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (73, 1, 2018, 3, 108);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (74, 1, 1981, 3, 285);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (75, 0, 2000, 4, 76);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (76, 0, 2021, 2, 443);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (77, 0, 2024, 3, 124);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (78, 1, 2006, 4, 133);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (79, 1, 2019, 1, 276);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (80, 1, 1995, 3, 166);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (81, 0, 2016, 2, 51);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (82, 0, 1996, 3, 191);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (83, 0, 2007, 3, 344);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (84, 0, 2009, 3, 372);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (85, 1, 2008, 1, 210);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (86, 1, 1987, 2, 23);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (87, 0, 1993, 2, 41);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (88, 0, 1999, 3, 106);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (89, 0, 1983, 4, 184);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (90, 0, 1995, 2, 170);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (91, 0, 2012, 3, 431);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (92, 0, 1993, 3, 186);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (93, 0, 2014, 4, 431);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (94, 0, 2008, 4, 264);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (95, 1, 2001, 4, 6);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (96, 0, 2000, 4, 312);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (97, 1, 2023, 3, 366);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (98, 0, 2009, 1, 89);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (99, 1, 2012, 3, 254);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (100, 1, 1997, 3, 146);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (101, 1, 1995, 4, 453);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (102, 0, 2012, 2, 207);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (103, 1, 2014, 3, 263);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (104, 1, 2010, 2, 414);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (105, 1, 2005, 4, 309);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (106, 1, 2003, 2, 31);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (107, 1, 2018, 3, 321);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (108, 1, 2003, 2, 496);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (109, 1, 1985, 2, 286);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (110, 1, 2013, 4, 428);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (111, 1, 2015, 3, 1);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (112, 0, 2002, 3, 16);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (113, 0, 2017, 2, 72);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (114, 0, 2016, 2, 315);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (115, 1, 2010, 2, 259);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (116, 1, 1994, 1, 450);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (117, 1, 2010, 3, 286);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (118, 1, 2005, 4, 239);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (119, 0, 2005, 1, 18);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (120, 1, 1997, 4, 200);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (121, 0, 2001, 3, 67);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (122, 1, 2021, 4, 485);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (123, 1, 1986, 3, 284);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (124, 1, 2006, 3, 203);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (125, 1, 2001, 2, 169);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (126, 1, 2008, 1, 163);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (127, 1, 1999, 4, 210);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (128, 0, 2019, 3, 20);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (129, 0, 1986, 3, 62);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (130, 1, 2018, 2, 310);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (131, 1, 2001, 3, 216);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (132, 1, 1984, 3, 424);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (133, 1, 2014, 4, 6);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (134, 1, 2023, 1, 466);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (135, 0, 1980, 4, 70);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (136, 1, 2005, 1, 9);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (137, 0, 1990, 1, 170);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (138, 0, 1987, 3, 288);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (139, 1, 1989, 1, 480);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (140, 1, 2015, 3, 264);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (141, 0, 2007, 2, 212);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (142, 1, 1988, 2, 128);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (143, 0, 1993, 4, 197);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (144, 1, 1986, 1, 178);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (145, 0, 2024, 3, 363);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (146, 0, 1980, 1, 138);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (147, 0, 1992, 3, 101);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (148, 1, 2007, 1, 339);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (149, 1, 2022, 3, 51);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (150, 1, 2001, 1, 357);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (151, 1, 2006, 2, 297);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (152, 0, 1997, 1, 15);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (153, 1, 2001, 3, 460);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (154, 0, 1984, 3, 313);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (155, 1, 2018, 3, 207);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (156, 0, 2008, 1, 257);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (157, 1, 2002, 2, 147);
commit;
prompt 500 records committed...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (158, 1, 2008, 2, 99);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (159, 1, 2003, 2, 165);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (160, 1, 1986, 2, 483);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (161, 1, 2007, 3, 130);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (162, 1, 2014, 1, 488);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (163, 0, 2003, 1, 20);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (164, 1, 1980, 1, 87);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (165, 1, 2016, 2, 473);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (166, 1, 2022, 3, 11);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (167, 1, 1982, 3, 213);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (168, 1, 1994, 1, 18);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (169, 0, 1986, 4, 393);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (170, 1, 2019, 2, 65);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (171, 1, 1986, 1, 373);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (172, 0, 2021, 3, 384);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (173, 1, 1994, 3, 349);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (174, 1, 1996, 3, 488);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (175, 1, 2001, 2, 435);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (176, 1, 2023, 2, 41);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (177, 0, 2006, 2, 132);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (178, 1, 2020, 2, 170);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (179, 1, 2022, 4, 200);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (180, 1, 2011, 4, 180);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (181, 1, 1991, 4, 455);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (182, 1, 1997, 1, 144);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (183, 0, 1998, 2, 448);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (184, 1, 1985, 3, 439);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (185, 0, 1997, 4, 65);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (186, 1, 2018, 1, 165);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (187, 0, 1998, 3, 29);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (188, 0, 2010, 4, 480);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (189, 0, 2007, 3, 314);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (190, 1, 1984, 1, 326);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (191, 1, 2016, 4, 454);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (192, 1, 2022, 2, 88);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (193, 0, 2012, 4, 272);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (194, 1, 1997, 3, 131);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (195, 0, 2000, 4, 494);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (196, 0, 1994, 1, 267);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (197, 0, 1994, 3, 304);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (198, 1, 1986, 1, 103);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (199, 0, 2022, 2, 267);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (200, 0, 2011, 2, 328);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (201, 1, 2008, 1, 178);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (202, 0, 2009, 3, 372);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (203, 0, 1990, 4, 331);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (204, 1, 1987, 4, 496);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (205, 1, 1983, 3, 154);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (206, 1, 2013, 4, 274);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (207, 0, 1998, 2, 294);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (208, 1, 2010, 4, 487);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (209, 1, 1980, 2, 73);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (210, 1, 2000, 4, 427);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (211, 1, 1992, 3, 377);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (212, 0, 2015, 2, 109);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (213, 0, 1998, 1, 448);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (214, 0, 2013, 3, 356);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (215, 1, 1986, 1, 49);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (216, 1, 1992, 3, 356);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (217, 1, 2005, 2, 79);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (218, 0, 1986, 2, 59);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (219, 0, 1999, 4, 76);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (220, 1, 2020, 2, 12);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (221, 0, 2011, 4, 119);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (222, 1, 2002, 3, 110);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (223, 1, 1998, 3, 147);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (224, 1, 2024, 1, 223);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (225, 1, 2015, 2, 184);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (226, 1, 2008, 1, 255);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (227, 0, 2018, 3, 459);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (228, 1, 1991, 4, 100);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (229, 1, 1985, 2, 446);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (230, 1, 1980, 2, 3);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (231, 1, 2015, 4, 306);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (232, 1, 1996, 4, 327);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (233, 1, 1983, 2, 225);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (234, 0, 1999, 1, 229);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (235, 0, 1983, 1, 172);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (236, 0, 2010, 1, 236);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (237, 1, 2012, 2, 73);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (238, 1, 2015, 3, 245);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (239, 0, 1988, 3, 339);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (240, 0, 2024, 3, 402);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (241, 1, 2006, 3, 382);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (242, 1, 2009, 4, 419);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (243, 1, 2019, 2, 462);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (244, 1, 1985, 2, 260);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (245, 0, 1993, 1, 479);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (246, 0, 2024, 3, 261);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (247, 1, 2018, 2, 169);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (248, 0, 2007, 2, 157);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (249, 0, 1995, 3, 202);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (250, 0, 2021, 2, 2);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (251, 0, 2001, 1, 167);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (252, 1, 2004, 2, 492);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (253, 1, 2006, 2, 9);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (254, 1, 1993, 1, 211);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (255, 1, 1997, 2, 318);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (256, 1, 1980, 1, 272);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (257, 1, 1987, 4, 70);
commit;
prompt 600 records committed...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (258, 1, 2002, 4, 366);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (259, 1, 1994, 3, 241);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (260, 1, 1981, 3, 228);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (261, 1, 1982, 2, 350);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (262, 0, 1980, 1, 473);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (263, 1, 2009, 2, 402);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (264, 1, 1981, 1, 398);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (265, 1, 2014, 1, 228);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (266, 1, 1989, 2, 137);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (267, 0, 1989, 3, 227);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (268, 1, 2012, 2, 238);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (269, 1, 1982, 4, 50);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (270, 0, 2023, 1, 162);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (271, 1, 2020, 1, 153);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (272, 1, 2008, 3, 180);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (273, 1, 2007, 2, 268);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (274, 1, 1999, 4, 157);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (275, 0, 1995, 2, 274);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (276, 1, 2019, 1, 272);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (277, 1, 2013, 1, 497);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (278, 0, 2007, 3, 114);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (279, 1, 2009, 4, 389);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (280, 1, 2017, 4, 228);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (281, 0, 1981, 3, 134);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (282, 1, 1986, 3, 6);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (283, 0, 1986, 1, 134);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (284, 0, 2015, 4, 52);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (285, 1, 1984, 2, 436);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (286, 0, 2023, 1, 387);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (287, 0, 2018, 1, 43);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (288, 0, 2011, 2, 123);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (289, 1, 1988, 3, 125);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (290, 1, 2021, 3, 483);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (291, 1, 1998, 3, 161);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (292, 0, 2017, 4, 284);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (293, 1, 2023, 2, 468);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (294, 1, 2007, 4, 278);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (295, 1, 2009, 2, 138);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (296, 1, 2000, 2, 433);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (297, 1, 1983, 2, 386);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (298, 0, 2020, 2, 114);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (299, 0, 1992, 4, 311);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (300, 1, 2002, 4, 139);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (301, 1, 2022, 2, 39);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (302, 1, 2012, 2, 294);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (303, 0, 2007, 3, 307);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (304, 0, 1993, 3, 204);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (305, 1, 2000, 3, 419);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (306, 1, 2013, 3, 153);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (307, 0, 1990, 1, 136);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (308, 1, 1993, 4, 281);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (309, 1, 2005, 2, 449);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (310, 1, 1982, 3, 179);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (311, 1, 2008, 4, 283);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (312, 0, 2007, 4, 448);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (313, 1, 1980, 1, 75);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (314, 1, 2015, 4, 85);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (315, 1, 1980, 1, 296);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (316, 1, 2018, 2, 330);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (317, 1, 1983, 1, 349);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (318, 0, 2021, 3, 407);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (319, 0, 2018, 2, 392);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (320, 0, 2014, 4, 162);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (321, 0, 1988, 4, 51);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (322, 1, 2020, 1, 112);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (323, 1, 2012, 3, 48);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (324, 1, 2020, 1, 400);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (325, 1, 2009, 3, 246);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (326, 0, 1991, 1, 170);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (327, 0, 2018, 1, 80);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (328, 1, 1992, 2, 317);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (329, 1, 1993, 2, 404);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (330, 0, 2001, 4, 169);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (331, 1, 2018, 1, 255);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (332, 1, 1988, 3, 80);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (333, 0, 1990, 1, 490);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (334, 0, 2003, 1, 391);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (335, 0, 2000, 3, 373);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (336, 0, 2011, 3, 357);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (337, 1, 2000, 4, 43);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (338, 1, 2006, 4, 419);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (339, 1, 1985, 4, 374);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (340, 1, 2005, 2, 419);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (341, 1, 2006, 1, 289);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (342, 1, 2015, 2, 223);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (343, 1, 2017, 1, 416);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (344, 0, 2010, 4, 214);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (345, 0, 2006, 2, 222);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (346, 1, 2016, 1, 249);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (347, 1, 2009, 4, 476);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (348, 1, 2023, 2, 464);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (349, 0, 1996, 3, 199);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (350, 0, 2010, 1, 30);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (351, 1, 2003, 4, 446);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (352, 1, 2022, 3, 281);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (353, 1, 2003, 4, 46);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (354, 0, 1995, 1, 269);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (355, 1, 2018, 2, 224);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (356, 0, 1999, 1, 227);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (357, 0, 2024, 3, 133);
commit;
prompt 700 records committed...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (358, 1, 1999, 1, 421);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (359, 1, 1995, 1, 304);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (360, 0, 1992, 4, 433);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (361, 1, 2016, 2, 480);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (362, 0, 2021, 4, 318);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (363, 1, 2002, 3, 377);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (364, 1, 1980, 3, 192);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (365, 0, 2012, 3, 347);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (366, 0, 2017, 3, 228);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (367, 1, 2000, 1, 429);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (368, 1, 2005, 2, 33);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (369, 0, 2021, 4, 334);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (370, 1, 2020, 3, 467);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (371, 0, 2008, 3, 316);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (372, 0, 2020, 4, 332);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (373, 0, 2011, 2, 460);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (374, 1, 1991, 4, 497);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (375, 1, 1997, 4, 370);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (376, 1, 2014, 3, 404);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (377, 0, 1985, 2, 274);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (378, 1, 1987, 1, 7);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (379, 0, 2011, 2, 2);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (380, 1, 1995, 2, 92);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (381, 0, 2015, 1, 430);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (382, 1, 2010, 4, 15);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (383, 1, 2021, 3, 275);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (384, 1, 2021, 4, 355);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (385, 1, 2001, 3, 309);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (386, 0, 1991, 2, 459);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (387, 1, 1997, 1, 9);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (388, 1, 2008, 2, 385);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (389, 0, 2016, 1, 79);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (390, 1, 2006, 4, 292);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (391, 1, 1989, 4, 382);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (392, 1, 1985, 1, 172);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (393, 1, 2021, 3, 311);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (394, 1, 1988, 1, 70);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (395, 1, 2016, 3, 11);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (396, 1, 1989, 4, 116);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (397, 1, 1993, 2, 67);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (398, 1, 1985, 4, 55);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (399, 0, 2013, 4, 49);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (400, 0, 2006, 4, 113);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (401, 0, 1989, 2, 494);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (402, 1, 2008, 3, 308);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (403, 0, 1995, 4, 283);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (404, 1, 2003, 1, 152);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (405, 0, 2010, 3, 416);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (406, 0, 2022, 2, 273);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (407, 0, 1995, 3, 223);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (408, 0, 2005, 2, 412);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (409, 1, 2021, 1, 429);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (410, 1, 2017, 4, 374);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (411, 1, 2010, 2, 197);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (412, 1, 1987, 1, 345);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (413, 1, 1988, 1, 498);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (414, 0, 1995, 2, 128);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (415, 0, 1985, 3, 451);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (416, 1, 1998, 2, 287);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (417, 0, 1999, 2, 41);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (418, 1, 2005, 4, 200);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (419, 1, 2020, 2, 236);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (420, 1, 2012, 2, 25);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (421, 1, 2021, 3, 32);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (422, 0, 1987, 1, 37);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (423, 1, 2004, 3, 392);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (424, 1, 2004, 4, 419);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (425, 1, 2024, 4, 96);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (426, 1, 1990, 1, 431);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (427, 1, 1997, 2, 473);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (428, 1, 2023, 4, 488);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (429, 1, 2013, 1, 93);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (430, 1, 2016, 2, 140);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (431, 0, 1997, 2, 305);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (432, 1, 2001, 4, 486);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (433, 1, 2009, 4, 223);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (434, 1, 2014, 4, 452);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (435, 0, 2016, 1, 96);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (436, 1, 2008, 3, 16);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (437, 1, 1997, 3, 106);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (438, 1, 1993, 2, 306);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (439, 1, 2016, 3, 38);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (440, 1, 2015, 4, 122);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (441, 1, 1994, 2, 391);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (442, 0, 2013, 4, 364);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (443, 0, 1990, 1, 382);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (444, 1, 2009, 4, 366);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (445, 0, 1998, 1, 345);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (446, 0, 1988, 3, 127);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (447, 0, 1990, 3, 53);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (448, 1, 1985, 2, 448);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (449, 0, 2011, 2, 437);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (450, 0, 1991, 2, 2);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (451, 1, 2024, 3, 222);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (452, 1, 2021, 3, 274);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (453, 1, 1988, 1, 442);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (454, 0, 2009, 4, 422);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (455, 1, 1998, 1, 409);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (456, 1, 1990, 3, 63);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (457, 0, 1995, 4, 35);
commit;
prompt 800 records committed...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (458, 1, 1980, 1, 423);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (459, 1, 2015, 2, 92);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (460, 1, 2002, 4, 441);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (461, 0, 2021, 4, 374);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (462, 1, 1998, 2, 244);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (463, 1, 2002, 4, 272);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (464, 0, 2022, 3, 36);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (465, 1, 2007, 1, 216);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (466, 1, 1991, 3, 414);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (467, 0, 2009, 4, 85);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (468, 1, 2000, 2, 62);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (469, 0, 2009, 4, 475);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (470, 0, 2015, 1, 358);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (471, 0, 2019, 2, 395);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (472, 1, 1986, 3, 417);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (473, 0, 2011, 3, 357);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (474, 1, 2019, 1, 487);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (475, 0, 2020, 1, 386);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (476, 0, 1980, 3, 292);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (477, 1, 1992, 4, 425);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (478, 1, 2009, 4, 275);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (479, 0, 1994, 3, 152);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (480, 1, 2015, 4, 236);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (481, 0, 2008, 4, 201);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (482, 1, 1992, 2, 375);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (483, 0, 1990, 1, 293);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (484, 1, 1998, 4, 273);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (485, 1, 1999, 4, 262);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (486, 1, 2002, 2, 213);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (487, 0, 2022, 3, 5);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (488, 0, 2021, 4, 487);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (489, 1, 1993, 1, 327);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (490, 0, 2001, 2, 53);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (491, 0, 2008, 1, 188);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (492, 1, 1980, 3, 119);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (493, 1, 2010, 3, 364);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (494, 0, 1996, 2, 127);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (495, 0, 1985, 4, 23);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (496, 1, 2012, 2, 153);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (497, 1, 1996, 4, 172);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (498, 0, 1982, 2, 204);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (499, 0, 1999, 1, 72);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (500, 1, 1988, 4, 421);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (501, 1, 1995, 2, 478);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (502, 1, 2019, 4, 198);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (503, 1, 2007, 2, 370);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (504, 1, 1995, 2, 190);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (505, 1, 1995, 3, 29);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (506, 0, 1988, 1, 252);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (507, 1, 1993, 4, 33);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (508, 0, 2001, 2, 255);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (509, 0, 2007, 2, 187);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (510, 1, 1989, 4, 332);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (511, 1, 2002, 4, 324);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (512, 0, 1983, 1, 30);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (513, 0, 2005, 2, 31);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (514, 1, 2006, 1, 335);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (515, 1, 1989, 2, 274);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (516, 1, 1999, 1, 155);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (517, 1, 2002, 1, 433);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (518, 1, 1988, 1, 163);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (519, 0, 1987, 3, 255);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (520, 1, 1994, 1, 80);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (521, 1, 1989, 4, 171);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (522, 1, 2007, 2, 331);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (523, 1, 2001, 4, 89);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (524, 1, 2012, 1, 151);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (525, 0, 2016, 4, 10);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (526, 1, 1985, 2, 52);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (527, 1, 1996, 4, 133);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (528, 0, 2001, 4, 225);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (529, 1, 1992, 4, 299);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (530, 0, 1986, 2, 334);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (531, 1, 2014, 1, 376);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (532, 1, 1982, 4, 239);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (533, 1, 1991, 2, 62);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (534, 1, 2024, 1, 82);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (535, 1, 1985, 1, 37);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (536, 0, 1984, 1, 324);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (537, 0, 2007, 1, 99);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (538, 0, 2008, 1, 170);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (539, 0, 1980, 4, 144);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (540, 1, 1991, 2, 390);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (541, 1, 1992, 4, 80);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (542, 1, 1993, 3, 65);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (543, 1, 2017, 3, 143);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (544, 1, 2013, 3, 223);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (545, 0, 2017, 1, 125);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (546, 0, 1987, 1, 389);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (547, 0, 2003, 1, 489);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (548, 1, 1988, 4, 63);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (549, 1, 1989, 4, 412);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (550, 0, 1985, 2, 43);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (551, 1, 1989, 2, 232);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (552, 1, 1985, 1, 228);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (553, 0, 1998, 1, 272);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (554, 1, 1997, 2, 273);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (555, 0, 2022, 3, 116);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (556, 1, 2017, 4, 178);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (557, 1, 1989, 2, 262);
commit;
prompt 900 records committed...
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (558, 1, 1987, 3, 282);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (559, 0, 1993, 1, 177);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (560, 1, 2023, 2, 133);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (561, 1, 2011, 3, 287);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (562, 1, 2000, 3, 317);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (563, 1, 1989, 2, 331);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (564, 1, 1991, 1, 145);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (565, 0, 1990, 1, 171);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (566, 1, 2008, 4, 271);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (567, 1, 2001, 3, 467);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (568, 1, 1985, 1, 209);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (569, 0, 2017, 3, 274);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (570, 1, 1988, 3, 260);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (571, 0, 2007, 1, 45);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (572, 0, 2003, 2, 341);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (573, 1, 1983, 2, 51);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (574, 0, 1997, 2, 232);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (575, 1, 1998, 2, 182);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (576, 1, 2002, 2, 194);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (577, 1, 2013, 3, 181);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (578, 1, 2023, 2, 53);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (579, 1, 2013, 1, 263);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (580, 0, 2019, 4, 129);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (581, 1, 1998, 2, 146);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (582, 1, 2017, 3, 108);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (583, 1, 1986, 2, 8);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (584, 0, 1982, 1, 316);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (585, 1, 1991, 4, 318);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (586, 0, 2012, 2, 383);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (587, 0, 2005, 4, 95);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (588, 1, 2006, 3, 336);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (589, 0, 2009, 4, 66);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (590, 0, 2021, 4, 75);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (591, 0, 1981, 1, 232);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (592, 1, 2019, 3, 269);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (593, 0, 2023, 3, 336);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (594, 1, 2023, 4, 161);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (595, 0, 1995, 4, 257);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (596, 1, 2024, 3, 281);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (597, 1, 1985, 4, 266);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (598, 1, 1991, 3, 27);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (599, 0, 2014, 4, 238);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (600, 1, 1985, 2, 227);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (601, 1, 1995, 4, 246);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (602, 0, 2016, 3, 26);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (603, 0, 2010, 2, 58);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (604, 1, 2003, 2, 243);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (605, 1, 2020, 1, 50);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (606, 1, 2022, 2, 93);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (607, 0, 1994, 3, 16);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (608, 1, 1980, 2, 337);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (609, 1, 2010, 2, 400);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (610, 1, 2022, 3, 334);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (611, 1, 2001, 3, 417);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (612, 1, 2012, 1, 490);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (613, 1, 2022, 4, 83);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (614, 1, 2012, 3, 123);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (615, 0, 1983, 1, 161);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (616, 0, 2016, 1, 235);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (617, 1, 1981, 3, 16);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (618, 1, 2007, 1, 181);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (619, 1, 2024, 4, 349);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (620, 0, 1986, 4, 263);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (621, 1, 1981, 1, 371);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (622, 1, 2020, 1, 193);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (623, 1, 2009, 2, 364);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (624, 1, 2022, 1, 15);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (625, 1, 1997, 1, 151);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (626, 0, 2008, 1, 382);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (627, 0, 2015, 4, 474);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (628, 1, 2001, 2, 279);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (629, 0, 2013, 2, 285);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (630, 1, 1993, 2, 114);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (631, 1, 1983, 1, 418);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (632, 0, 2017, 4, 267);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (633, 1, 2002, 4, 221);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (634, 1, 2000, 3, 483);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (635, 1, 2016, 1, 10);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (636, 0, 2001, 4, 229);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (637, 0, 2003, 2, 28);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (638, 0, 1999, 2, 410);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (639, 1, 2009, 4, 223);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (640, 0, 1980, 2, 38);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (641, 1, 2021, 1, 485);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (642, 0, 1982, 3, 249);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (643, 0, 1992, 2, 282);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (644, 0, 2021, 4, 286);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (645, 0, 2008, 2, 170);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (646, 1, 1993, 2, 346);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (647, 0, 1982, 1, 269);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (648, 1, 1985, 2, 366);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (649, 1, 1985, 2, 65);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (650, 0, 2024, 2, 176);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (651, 0, 2013, 3, 207);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (652, 0, 2014, 4, 93);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (653, 0, 1986, 2, 133);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (654, 1, 2003, 4, 401);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (655, 1, 1990, 1, 156);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (656, 1, 2017, 2, 264);
insert into BOOKCOPY (copyid, available, yearpublished, edition, bookid)
values (657, 0, 1994, 2, 426);
commit;
prompt 1000 records loaded
prompt Loading PERSON...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('791744157', 'Trace', 'Sewell', '052-6349077', 'tsewell@americanpan.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('257457253', 'Ted', 'Loggia', '054-3555108', 'ted@intraspheretechnologies.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('127843079', 'Spencer', 'Blanchett', '051-9596067', 'spencer.blanchett@ibfh.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('537555106', 'Benjamin', 'Sampson', '057-5555640', 'benjamin.sampson@eastmankodak.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('880670146', 'Charlie', 'Delta', '054-5246973', 'charlie.delta@credopetroleum.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('137842810', 'Dennis', 'Lane', '057-5292707', 'dennis.l@dell.tr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('747016733', 'Michelle', 'Pearce', '059-8511289', 'michelle.pearce@walmartstores.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('182694587', 'Laurence', 'Child', '054-8246381', 'laurence@qls.hu');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('162991219', 'Kathy', 'Raitt', '054-2494726', 'kathy.raitt@stm.hk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('295160825', 'Sinead', 'Summer', '057-9682536', 'sinead.summer@pharmafab.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('236059370', 'Emmylou', 'Hunter', '051-7785909', 'ehunter@multimedialive.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('327179287', 'Mickey', 'Law', '057-7384235', 'mickey.law@bestbuy.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('571326720', 'Wade', 'Miles', '056-2462057', 'w.miles@ris.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('130969218', 'Ani', 'Orbit', '056-6332294', 'ani.orbit@ubp.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('017605424', 'Lauren', 'Sevigny', '050-8200917', 'lsevigny@healthscribe.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('484632351', 'Reese', 'Aykroyd', '059-4684717', 'reesea@magnet.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('915923130', 'Ty', 'Walker', '052-9191367', 'ty41@sci.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('063528944', 'Loretta', 'Breslin', '051-1308312', 'l.breslin@ubp.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('403239539', 'Jill', 'Bale', '059-9696084', 'jbale@hencie.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('701862029', 'Woody', 'Witherspoon', '056-1510351', 'wwitherspoon@fordmotor.pt');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('794279431', 'Renee', 'Conroy', '050-9692232', 'rconroy@ibm.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('210464341', 'Jake', 'Worrell', '054-4695151', 'jake.worrell@cascadebancorp.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('790283405', 'Jim', 'Nugent', '050-5575176', 'jim@linksys.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('332533380', 'Eric', 'Levine', '051-9937891', 'elevine@teamstudio.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('260188692', 'Tamala', 'Irons', '055-4917175', 'tamalai@sbc.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('949649669', 'Anita', 'MacIsaac', '056-8262586', 'anitam@priorityleasing.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('367706464', 'Azucar', 'Cassidy', '051-4738649', 'azucar.cassidy@scriptsave.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('958525594', 'Alex', 'Dourif', '058-6572683', 'alex.dourif@paisley.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('356010317', 'Clea', 'Balk', '052-8490875', 'clea@extremepizza.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('029695329', 'Josh', 'Dutton', '057-6581428', 'josh@yashtechnologies.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('420727447', 'Rob', 'Thurman', '056-6438259', 'rob@aci.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('310017470', 'Chazz', 'Santa Rosa', '056-1215509', 'chazz@elmco.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('838686751', 'Brooke', 'Logue', '058-8158668', 'brookel@lms.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('938101191', 'Lloyd', 'Lovitz', '059-1822999', 'lloyd@paintedword.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('078588875', 'Renee', 'Phillips', '055-7878387', 'renee.phillips@cascadebancorp.mx');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('129327899', 'Melanie', 'Davis', '058-4183276', 'm.davis@kitba.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('555047971', 'Maria', 'Gosdin', '058-2647043', 'm.gosdin@curagroup.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('055299244', 'Judi', 'Sevenfold', '053-3472631', 'judi.sevenfold@parker.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('680606541', 'Meryl', 'Cross', '057-6947138', 'meryl.cross@dataprise.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('257564020', 'Stephanie', 'Gugino', '057-3410903', 'stephanie.gugino@dell.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('348648244', 'Lila', 'Gray', '053-4857852', 'lgray@credopetroleum.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('341208936', 'Robby', 'Bogguss', '051-5704985', 'rbogguss@banfeproducts.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('244652438', 'Nickel', 'Davidtz', '055-6609282', 'nickel.davidtz@cyberthink.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('290488254', 'Coley', 'Pearce', '054-7173314', 'coley.pearce@solutionbuilders.pl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('263852543', 'Kasey', 'Nicholson', '051-8168391', 'kaseyn@universalsolutions.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('905167354', 'Murray', 'Lee', '058-7610145', 'murray.lee@accurateautobody.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('180966239', 'Gord', 'Spader', '054-4425299', 'gspader@conquest.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('614782689', 'Harrison', 'Carrack', '056-7773376', 'harrison.carrack@ceb.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('700106864', 'Mark', 'Postlethwaite', '058-8612161', 'mark.postlethwaite@marathonheater.mx');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('432090220', 'Ving', 'Roberts', '056-5910388', 'vroberts@gcd.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('577720618', 'Maureen', 'Nelson', '058-9430319', 'm.nelson@irissoftware.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('290571145', 'Arturo', 'Rush', '052-4171082', 'arturo.r@mwh.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('358425150', 'Todd', 'Holliday', '057-5147506', 'todd.holliday@horizonorganic.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('069849743', 'Wes', 'Barry', '057-8719912', 'wes.barry@educationaldevelopment.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('914751680', 'Harris', 'Chapman', '054-8155275', 'harrisc@royalgold.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('922607270', 'Grace', 'Summer', '052-4845639', 'graces@alternativetechnology.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('909087863', 'Anne', 'Heatherly', '056-3362965', 'anneh@newtoninteractive.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('342956097', 'Mandy', 'Solido', '057-1929806', 'mandy.solido@oneidafinancial.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('088693106', 'Christian', 'Dunaway', '058-8225344', 'christian.d@at.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('819662032', 'Roscoe', 'Carrington', '058-7886392', 'roscoe.carrington@inzone.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('668933071', 'Bernard', 'Orbit', '051-9249135', 'bernardo@inzone.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('753507424', 'Jeffrey', 'Penn', '056-3278921', 'jeffrey.penn@ataservices.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('312108840', 'Tyrone', 'Davidtz', '054-2202355', 'tyrone.davidtz@y2marketing.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('688569966', 'Merillee', 'Levine', '050-6948776', 'merillee@shufflemaster.in');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('485100893', 'Carlos', 'Cleese', '052-1830968', 'carlos.cleese@als.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('322295223', 'Jude', 'Strong', '059-1498833', 'jude.strong@mms.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('355658237', 'Steve', 'Watson', '054-1178930', 'steve@fiberlink.il');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('012173330', 'Ned', 'Imbruglia', '058-3147592', 'ned@pinnaclestaffing.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('150193733', 'Trini', 'Eldard', '055-4178492', 'trini.eldard@campbellsoup.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('751828242', 'Howard', 'Lowe', '057-6944209', 'howard@north.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('617184197', 'Sally', 'Sevenfold', '057-7897342', 'sally.sevenfold@tilsonlandscape.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('943003903', 'Parker', 'Fierstein', '059-2839292', 'parker.fierstein@cardinalcartridge.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('337103549', 'Angela', 'Holeman', '057-3459995', 'a.holeman@loreal.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('998214636', 'Tea', 'Tobolowsky', '054-5691360', 'tea.tobolowsky@studiobproductions.be');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('830293594', 'Merle', 'Love', '050-8833401', 'merle.love@sony.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('980594838', 'Will', 'Tempest', '053-3368159', 'will@genextechnologies.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('235169601', 'Fats', 'Ruiz', '053-9889933', 'fats.ruiz@capstone.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('860441514', 'Doug', 'Lunch', '052-7620703', 'doug@vspan.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('855053927', 'Ernie', 'Ellis', '052-8700058', 'ernie.ellis@travizon.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('961457858', 'Arturo', 'Llewelyn', '057-1969129', 'allewelyn@appriss.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('025815914', 'Louise', 'Wine', '057-2404847', 'louisew@jma.ar');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('050769190', 'Betty', 'Hewett', '050-5216020', 'betty.hewett@nrae.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('903508975', 'Noah', 'Weiland', '056-5407992', 'n.weiland@daimlerchrysler.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('245272383', 'Tia', 'Viterelli', '052-1218946', 'tia@johnkeeler.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('421224696', 'Jackie', 'May', '050-2731934', 'jackie.may@usdairyproducers.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('352937150', 'Jesse', 'Ricci', '059-7973696', 'jesse.ricci@printtech.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('348723377', 'Lloyd', 'Tempest', '056-4245091', 'lloyd.t@alternativetechnology.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('195198779', 'Cole', 'Schiavelli', '058-7769776', 'cole@directdata.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('614784421', 'Karen', 'Forrest', '056-6750915', 'karen.forrest@accessus.hk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('566478959', 'Irene', 'Plowright', '056-5639963', 'i.plowright@ezecastlesoftware.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('933040014', 'Quentin', 'Kristofferson', '051-1174786', 'quentin@gcd.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('560110054', 'April', 'Hersh', '054-2845873', 'april.hersh@drinkmorewater.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('805127954', 'Pierce', 'McElhone', '056-4529978', 'pierce.mcelhone@trm.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('632874948', 'Meryl', 'Steagall', '054-9978208', 'msteagall@apexsystems.th');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('099046451', 'Jane', 'Rhodes', '054-2972679', 'jane.rhodes@scriptsave.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('140829165', 'Shannon', 'Reed', '051-1810711', 'shannon.reed@simplycertificates.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('639941357', 'Ceili', 'Ledger', '057-5366899', 'ceili.ledger@vesta.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('731223212', 'Ali', 'Roth', '056-4493405', 'alir@hotmail.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('343639938', 'Blair', 'Harris', '050-3145482', 'blair.harris@dsp.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('322161930', 'Joely', 'Rossellini', '056-7283473', 'joely.r@ibm.uk');
commit;
prompt 100 records committed...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('418345089', 'Lenny', 'Bancroft', '053-3511073', 'lenny.bancroft@pragmatechsoftware.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('377017130', 'Mae', 'DeVito', '051-2553180', 'mae.devito@csi.pk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('687142530', 'Arnold', 'McPherson', '055-8189352', 'arnoldm@emt.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('287375665', 'Natalie', 'Mars', '058-2614905', 'natalie.mars@evergreenresources.gr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('837965281', 'Dave', 'Hunter', '054-3874834', 'dave@linacsystems.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('336576783', 'Morgan', 'Avalon', '058-3768785', 'mavalon@ibm.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('891562139', 'Mika', 'Archer', '056-2982652', 'mika.archer@typhoon.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('019362397', 'Debra', 'Beatty', '051-2992499', 'debra.beatty@gdi.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('442298493', 'Forest', 'Addy', '057-6422069', 'faddy@palmbeachtan.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('976727582', 'Oro', 'Crowe', '056-1275085', 'oro.c@avs.nz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('077412256', 'Pablo', 'Griffith', '055-2913691', 'pablo.griffith@bayer.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('555806585', 'Scott', 'Zevon', '057-3508392', 'scott.zevon@tastefullysimple.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('745672175', 'Roddy', 'Leoni', '054-6762530', 'roddy.leoni@tarragonrealty.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('945335349', 'Micky', 'Seagal', '057-6366319', 'micky.seagal@genghisgrill.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('093818015', 'Brent', 'Goodman', '056-2610452', 'brent.goodman@dataprise.hk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('318671760', 'Zooey', 'Rhymes', '056-3357228', 'z.rhymes@gcd.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('703728916', 'Ray', 'Tyson', '059-9457316', 'rayt@escalade.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('934564949', 'Brenda', 'Crudup', '051-2392239', 'brenda@cynergydata.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('774444469', 'Marc', 'Broadbent', '052-9627639', 'marc@spotfireholdings.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('847487113', 'Lee', 'Soul', '059-5864049', 'lee.soul@vitacostcom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('090048723', 'Derek', 'Shelton', '055-8967378', 'derek.shelton@cima.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('511449615', 'Gloria', 'Myles', '059-8120033', 'gloria.myles@curagroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('811048828', 'Rutger', 'Weston', '051-9740959', 'rutger.weston@accuship.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('029466664', 'Cevin', 'Kirkwood', '056-5163114', 'cevin.kirkwood@inspirationsoftware.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('893824664', 'Loreena', 'Dafoe', '054-3407525', 'loreena.dafoe@team.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('708212180', 'Rade', 'Mortensen', '053-9124245', 'rade@nestle.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('253491087', 'Night', 'Carradine', '050-7231702', 'night.carradine@stonetechprofessional.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('477813934', 'Sally', 'Wahlberg', '052-6809481', 'sally.wahlberg@teamstudio.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('420027444', 'Radney', 'Neil', '050-4760842', 'radney.neil@parker.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('175188743', 'Vonda', 'Hamilton', '054-8599757', 'vonda.hamilton@generalmotors.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('773131967', 'Mena', 'Colman', '055-7910111', 'mena@extremepizza.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('500236463', 'Kylie', 'Rooker', '052-9453602', 'kylie.r@team.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('140122154', 'Ewan', 'Gertner', '057-9841574', 'ewan.gertner@hatworld.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('129460463', 'Randall', 'Duvall', '058-3639447', 'r.duvall@fpf.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('141462578', 'Jesus', 'Oldman', '059-8770698', 'joldman@curagroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('048553423', 'Mindy', 'Moraz', '057-5546168', 'mindym@elitemedical.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('723375847', 'Natalie', 'Davidson', '050-1355138', 'natalie.davidson@data.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('664682936', 'Shannyn', 'Coburn', '059-2446918', 'shannyn@vfs.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('266091930', 'Rose', 'Dysart', '052-5962464', 'rose.dysart@alternativetechnology.my');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('783918714', 'Stewart', 'Lynne', '051-8417718', 'stewart.lynne@trafficmanagement.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('878867388', 'Rachael', 'de Lancie', '056-8679369', 'rachael.delancie@capitalautomotive.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('187429687', 'Goran', 'Loggins', '055-4767498', 'gloggins@kimberlyclark.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('220633642', 'Juliet', 'Blades', '052-4950964', 'juliet.blades@commworks.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('935992565', 'Denise', 'Connery', '058-6920827', 'dconnery@ufs.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('301483688', 'Cornell', 'Pastore', '053-1992941', 'cornell.pastore@eastmankodak.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('230944652', 'Chuck', 'Rippy', '059-8859221', 'chuckr@printcafesoftware.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('487953943', 'Donna', 'Spader', '058-3422889', 'donna@wav.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('611574934', 'Bobby', 'Shaye', '052-1245503', 'bobby@trusecure.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('090459574', 'Rik', 'Calle', '051-4362991', 'rik.calle@elmco.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('291655867', 'Oliver', 'Cartlidge', '059-9883487', 'oliver.c@worldcom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('310254787', 'Patty', 'Cruise', '052-6345278', 'patty.cruise@directdata.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('275457970', 'Joaquim', 'McDiarmid', '052-2669317', 'joaquim.mcdiarmid@mai.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('508594301', 'Yaphet', 'Walsh', '054-8180959', 'ywalsh@marathonheater.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('362194928', 'Antonio', 'Eat World', '052-2487226', 'antonio.eatworld@ris.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('353108066', 'Illeana', 'Bacharach', '053-2349218', 'illeana.bacharach@ceo.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('169627765', 'Carolyn', 'Sweeney', '055-5383167', 'carolyn.sweeney@mls.no');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('220597440', 'Mary Beth', 'Biggs', '051-4821298', 'marybeth.b@digitalmotorworks.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('115243063', 'Joaquim', 'Zahn', '054-3674336', 'joaquim@httprint.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('543044858', 'Rosario', 'Danger', '059-8816314', 'rosario.danger@als.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('608394597', 'Anita', 'Farrell', '058-4938302', 'anita.farrell@marsinc.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('250712526', 'Mickey', 'Sossamon', '052-3223070', 'mickey.sossamon@ungertechnologies.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('655586968', 'Rick', 'Iglesias', '051-7447108', 'rick.iglesias@ositissoftware.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('322854435', 'Xander', 'Pierce', '054-6193669', 'x.pierce@americanexpress.no');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('187515796', 'Michael', 'Crimson', '050-6769727', 'michael.crimson@priorityexpress.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('025274453', 'Anjelica', 'Prowse', '055-2396648', 'anjelica@verizon.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('962595219', 'Jann', 'Fraser', '057-9271650', 'jann.fraser@americanmegacom.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('249308151', 'Shannyn', 'Lineback', '057-9737912', 'shannyn.lineback@speakeasy.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('170713739', 'Pelvic', 'Matarazzo', '059-4130402', 'pelvic.matarazzo@lydiantrust.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('063300220', 'Nigel', 'Neeson', '055-6210346', 'nneeson@meritagetechnologies.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('953627847', 'Rawlins', 'Stanley', '058-1983372', 'rawlinss@newmedia.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('161677298', 'Courtney', 'Sledge', '052-4984716', 'courtney.sledge@ptg.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('544729905', 'Hilary', 'Hatchet', '055-6822263', 'hilary.h@solipsys.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('120938383', 'Joely', 'Sweeney', '057-4181814', 'joely.s@fds.nc');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('445199398', 'Rachid', 'Kenoly', '059-3111905', 'rachid.kenoly@sfgo.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('805665451', 'Kathy', 'Bracco', '055-5942145', 'kathy.bracco@usenergyservices.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('329948220', 'Lisa', 'Donovan', '057-1690518', 'l.donovan@educationaldevelopment.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('011679094', 'Philip', 'Maguire', '056-8252441', 'pmaguire@aco.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('584514179', 'Pelvic', 'Boothe', '050-5415947', 'p.boothe@cocacola.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('490240700', 'Christopher', 'Potter', '058-3774824', 'christopher.potter@harrison.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('971707537', 'Jose', 'Lyonne', '053-7898287', 'jose.lyonne@mastercardinternational.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('821726553', 'Charlton', 'Deejay', '059-1764092', 'charlton.deejay@freedommedical.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('886474743', 'Fisher', 'Sossamon', '056-3664958', 'fisher.sossamon@usdairyproducers.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('089210852', 'Denzel', 'Goldblum', '057-9349232', 'denzel.g@esteelauder.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('311514630', 'Jack', 'Irving', '055-6661383', 'jack.irving@ceom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('908324121', 'Juliet', 'Sheen', '052-4335872', 'juliet.sheen@chipssolutions.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('806703766', 'Ronny', 'Popper', '055-6519656', 'ronny.popper@angieslist.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('619874595', 'Kevn', 'Marley', '052-8328125', 'kevn.m@bps.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('632046362', 'Jesus', 'Reiner', '058-5862072', 'jesus.reiner@target.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('119362966', 'Rueben', 'Singh', '051-4240031', 'rueben.singh@target.lt');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('211388196', 'Wesley', 'Parm', '059-4890169', 'wesley.parm@morganresearch.pl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('770383764', 'Joan', 'O''Neill', '059-3364493', 'joneill@integramedamerica.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('624567221', 'Cornell', 'Candy', '052-2770094', 'cornell.candy@base.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('555398022', 'Timothy', 'Ledger', '058-2805942', 'timothy.ledger@hewlettpackard.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('163506853', 'Kirsten', 'Child', '058-9780727', 'kirsten.child@integratelecom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('801792400', 'Kristin', 'Chaykin', '058-9321130', 'kristin.chaykin@cws.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('034808493', 'Carlene', 'Wariner', '058-4455445', 'carlene.wariner@accuship.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('669445546', 'Lizzy', 'Moody', '050-1847002', 'lizzy.m@cws.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('302857054', 'Ruth', 'Baldwin', '059-8562063', 'ruth.baldwin@fmi.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('840162098', 'Aimee', 'Lennix', '058-7450512', 'aimee.lennix@y2marketing.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('029124580', 'Ernie', 'Broadbent', '057-6843669', 'ernie.broadbent@pepsico.it');
commit;
prompt 200 records committed...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('305084973', 'Wayne', 'Graham', '053-8446048', 'wayne.graham@infinity.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('053078260', 'Leon', 'Crouse', '056-7663695', 'leon.crouse@bradleypharmaceuticals.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('940582151', 'Lindsey', 'Hunter', '052-9153243', 'lindsey.hunter@atlanticnet.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('666153997', 'Nicholas', 'Hedaya', '058-8453305', 'nicholas@tripwire.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('573551196', 'Kenny', 'Mathis', '052-6827632', 'kenny@servicelink.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('659027064', 'Saul', 'Akins', '057-1320396', 'saul.akins@americanland.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('783055575', 'Josh', 'Gore', '059-3721060', 'jgore@allstar.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('665487506', 'Annette', 'Dupree', '051-6335611', 'annette.dupree@escalade.ie');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('086121419', 'Rawlins', 'Wiest', '058-8202384', 'rawlins.wiest@pharmafab.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('599540856', 'Pete', 'Burton', '052-8543361', 'p.burton@credopetroleum.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('327375753', 'Michael', 'Watson', '058-5733736', 'm.watson@blueoceansoftware.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('361560323', 'Jerry', 'Tobolowsky', '052-8736864', 'jerryt@waltdisney.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('093283555', 'Curtis', 'Carlton', '056-1339880', 'curtis.carlton@bestever.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('805550992', 'Sarah', 'Rhodes', '051-6268382', 'sarah.rhodes@ghrsystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('012259052', 'Renee', 'Cross', '052-3130914', 'renee.c@gcd.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('000020688', 'Pierce', 'McGowan', '050-4338500', 'pierce@coldstonecreamery.in');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('932959604', 'Keith', 'Ricci', '059-9458582', 'keith.r@tilsonlandscape.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('928095860', 'Frankie', 'Michael', '051-7899769', 'frankie.michael@progressivedesigns.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('744130580', 'Nicholas', 'Caldwell', '050-4723468', 'nicholas.caldwell@newhorizons.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('697531067', 'Shirley', 'Forrest', '059-1717662', 'sforrest@mse.be');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('360641780', 'Jonny', 'Jeter', '059-4684520', 'jonny@cws.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('693208088', 'Sharon', 'Browne', '050-1492924', 'sharon.browne@outsourcegroup.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('264847178', 'Michael', 'Neil', '058-4239798', 'michael.neil@democracydata.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('172290645', 'Stewart', 'Holy', '055-3945244', 'stewart.h@tama.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('771463068', 'Jerry', 'Duchovny', '054-4132355', 'jerry.duchovny@hatworld.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('087859207', 'Norm', 'Turner', '053-4600898', 'norm.turner@accurateautobody.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('077055177', 'Garry', 'Ribisi', '058-4434212', 'garryr@generalmills.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('386768609', 'Campbell', 'Ryder', '058-6514828', 'campbell.ryder@dis.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('348007353', 'Luis', 'Thomson', '058-6449714', 'luis.thomson@monitronicsinternational.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('631487255', 'Goldie', 'Kinnear', '053-8433955', 'gkinnear@techrx.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('602220915', 'Chazz', 'Venora', '051-7546484', 'chazz.venora@dcgroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('026793656', 'Frederic', 'Sharp', '051-2263164', 'frederic.sharp@officedepot.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('086419816', 'Kevn', 'Mahoney', '050-3593915', 'kevn.mahoney@cendant.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('019226343', 'Tilda', 'Prinze', '051-9169174', 't.prinze@younginnovations.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('684212539', 'Harry', 'Choice', '054-1498338', 'harry.c@northhighland.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('424102835', 'Liev', 'Pride', '055-7363283', 'liev.pride@dancor.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('141519886', 'Harry', 'Palminteri', '051-8733208', 'harry.palminteri@emt.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('992996173', 'Bret', 'Monk', '057-9303198', 'b.monk@dbprofessionals.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('100009511', 'Ronnie', 'Gilliam', '056-1689273', 'ronnie@mls.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('386723173', 'Crispin', 'Frost', '057-5470536', 'c.frost@bioanalytical.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('456794713', 'Kurtwood', 'Hunter', '059-9284210', 'kurtwood@ipsadvisory.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('677905366', 'Spike', 'Shandling', '050-9379154', 'sshandling@aristotle.nz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('908811401', 'Nicolas', 'Buscemi', '056-8544317', 'nicolasb@canterburypark.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('050815903', 'Rhett', 'Harry', '056-9854901', 'rhett@pra.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('221505949', 'Steven', 'Garr', '058-9173510', 's.garr@onstaff.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('013427448', 'Pierce', 'Lewis', '057-5931197', 'pierce.lewis@teamstudio.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('186328775', 'Freda', 'Wopat', '053-7895385', 'fredaw@comnetinternational.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('055509419', 'Kenneth', 'Hubbard', '054-6805598', 'kenneth.hubbard@hondamotor.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('375532599', 'Gwyneth', 'Shue', '056-8204286', 'gwyneths@gtp.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('240775340', 'First', 'Curtis-Hall', '051-4842471', 'first.c@bioreference.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('791299463', 'Lance', 'Walken', '059-2314723', 'lance@networkdisplay.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('809394842', 'Brendan', 'Colton', '059-9511299', 'brendan.c@connected.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('518249933', 'Doug', 'Gough', '054-2195542', 'd.gough@pepsico.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('602669135', 'Brenda', 'Mars', '055-4129538', 'brenda.mars@topicsentertainment.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('280673575', 'Queen', 'Hawkins', '059-9573492', 'q.hawkins@avr.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('735540984', 'Rosario', 'Freeman', '058-7168753', 'rosario.f@verizon.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('982566913', 'Nancy', 'Lineback', '055-2448449', 'nancyl@at.mo');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('712791245', 'Ani', 'McKennitt', '058-6153363', 'ani.mckennitt@trx.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('016015645', 'Curtis', 'Grant', '057-6161824', 'curtis.grant@sis.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('917752036', 'Carl', 'Cobbs', '058-4802924', 'carl@sfgo.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('751891760', 'Josh', 'Raitt', '059-4132825', 'josh.raitt@newhorizons.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('677097969', 'Saul', 'Steiger', '053-7392455', 'saul@viacom.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('740708570', 'Ed', 'Guest', '052-3225861', 'ed.guest@kiamotors.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('890128244', 'Leo', 'Spears', '053-8736662', 'leo.spears@gra.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('519806856', 'Geraldine', 'Goldblum', '051-8337040', 'geraldine.goldblum@trc.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('414182170', 'Betty', 'Scaggs', '052-6948371', 'bscaggs@pds.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('703815502', 'Holly', 'Isaacs', '055-5750873', 'holly.isaacs@pib.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('835941547', 'Jerry', 'Rispoli', '055-5966292', 'jerry.rispoli@scjohnson.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('660975076', 'Dan', 'Chesnutt', '055-9647010', 'dan.chesnutt@ibfh.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('037185185', 'Saul', 'Rock', '058-8306262', 'saul.rock@microtek.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('981531119', 'Leonardo', 'Favreau', '057-2571384', 'leonardo.favreau@softworld.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('198370408', 'Taryn', 'Gagnon', '051-5599018', 'taryn.g@ivorysystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('766196804', 'Benicio', 'Davison', '058-9400047', 'benicio.d@alternativetechnology.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('708027100', 'Gin', 'Chao', '052-6203838', 'gin.chao@mai.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('483206140', 'Joaquin', 'Supernaw', '052-7246031', 'joaquin.supernaw@quicksilverresources.za');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('551736818', 'Rawlins', 'Noseworthy', '054-9153484', 'rawlins.noseworthy@mitsubishimotors.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('058725396', 'Natalie', 'Hannah', '053-2739394', 'natalie@fab.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('279175065', 'Natascha', 'Alexander', '055-9534923', 'natascha@capitalbank.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('155490931', 'Chuck', 'Fonda', '056-3538390', 'chuck@deutschetelekom.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('690535760', 'Sara', 'Donelly', '050-6998889', 'sara.donelly@nestle.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('953469588', 'Elvis', 'Sartain', '053-7236111', 'elvis.sartain@pharmacia.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('600498312', 'Angie', 'Cattrall', '052-1273506', 'angie.cattrall@hiltonhotels.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('526716833', 'Dabney', 'Del Toro', '052-4160539', 'dabneyd@sfmai.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('143520341', 'Rowan', 'Alston', '055-3928608', 'rowana@quakercitybancorp.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('750846684', 'Martha', 'Peet', '052-9804130', 'martha.peet@hospitalsolutions.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('398373857', 'Gin', 'Negbaur', '058-6290411', 'gin.negbaur@ads.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('309732749', 'Larnelle', 'Forrest', '058-8594035', 'larnelle.forrest@directdata.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('414999012', 'Martin', 'Stampley', '059-2275698', 'martin.stampley@pepsico.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('900649914', 'Kirk', 'Spears', '058-9725931', 'kirk@stonebrewing.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('490830032', 'Joan', 'Roundtree', '055-2549928', 'joan.roundtree@lfg.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('107093007', 'Tramaine', 'Matheson', '053-2490604', 'tramaine@yumbrands.is');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('396904603', 'Dionne', 'Lawrence', '058-9756099', 'dionne.lawrence@nissanmotor.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('873355323', 'Franz', 'Palminteri', '051-4265528', 'franz@operationaltechnologies.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('345093461', 'CeCe', 'Zeta-Jones', '058-3380000', 'cece.zetajones@infinity.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('446920114', 'Terence', 'Daniels', '053-9367377', 'terence@medamicus.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('986715923', 'Ed', 'Travers', '055-5842566', 'ed.travers@advertisingventures.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('136473730', 'Todd', 'Ramis', '059-8823344', 'todd.ramis@keymark.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('996681695', 'Gwyneth', 'Lerner', '051-1150261', 'gwyneth@scriptsave.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('034711067', 'Harrison', 'Lennix', '052-2101855', 'harrison.lennix@marriottinternational.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('407702741', 'Trey', 'Lemmon', '056-1363974', 'trey@fiberlink.de');
commit;
prompt 300 records committed...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('735902946', 'Angela', 'Cale', '051-9412236', 'acale@lloydgroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('989570315', 'Elisabeth', 'King', '055-2913381', 'elisabeth.king@nestle.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('725276037', 'Moe', 'Lithgow', '055-1159191', 'moel@swi.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('992585529', 'Nick', 'Loggia', '059-4927782', 'nick@floorgraphics.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('525091839', 'Sydney', 'Purefoy', '053-8873326', 'sydney.purefoy@bristolmyers.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('545636009', 'April', 'Aniston', '054-2543735', 'april@base.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('886020450', 'Belinda', 'Kramer', '059-4954478', 'belinda.kramer@dillards.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('530118953', 'Cornell', 'Cagle', '053-7693869', 'cornell.cagle@abatix.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('374339845', 'Thomas', 'Zahn', '052-6250131', 'thomas.zahn@ams.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('945150294', 'Garland', 'Greenwood', '055-2984891', 'ggreenwood@tilsonhr.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('681877198', 'Demi', 'Weisberg', '056-1675670', 'demi.weisberg@eagleone.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('625324658', 'Omar', 'Rucker', '058-8506502', 'omar.rucker@grs.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('155248136', 'Dwight', 'Eastwood', '051-7515285', 'dwight.eastwood@virbac.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('596690563', 'Pelvic', 'Stone', '054-8800189', 'pelvic.stone@sweetproductions.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('455567704', 'Antonio', 'Yorn', '059-3706928', 'antonio.yorn@consultants.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('028592641', 'Millie', 'Mifune', '052-8613960', 'm.mifune@ssci.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('177382748', 'Horace', 'Hatchet', '058-9823980', 'horace.hatchet@americanvanguard.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('942242894', 'Samantha', 'Newton', '059-4222907', 'samantha.newton@kwraf.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('840998924', 'Gabriel', 'Renfro', '054-5754732', 'gabriel@dearbornbancorp.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('964121065', 'James', 'Idol', '051-6876902', 'james.i@oriservices.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('507745420', 'Tori', 'Palminteri', '050-4513364', 'tori.palminteri@intraspheretechnologies.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('528150024', 'Junior', 'Irons', '058-2935866', 'junior.irons@pharmacia.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('500068415', 'Judy', 'Perez', '056-3375601', 'j.perez@thinktanksystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('798632254', 'Faye', 'Summer', '059-2772830', 'faye.summer@gha.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('520422787', 'Udo', 'Church', '058-9469015', 'udo.church@mai.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('784609914', 'Joan', 'Wong', '056-1761401', 'joan.wong@socketinternet.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('386518366', 'Stanley', 'Union', '054-1692117', 's.union@onstaff.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('261535229', 'Rhea', 'Overstreet', '053-1337484', 'rhea.overstreet@colgatepalmolive.nz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('078062073', 'Cameron', 'Cox', '056-6935001', 'cameron.cox@unicru.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('436366104', 'Kate', 'Donovan', '051-3823018', 'kate.donovan@spinnakerexploration.be');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('391486802', 'Malcolm', 'Bancroft', '055-4207022', 'malcolm@priorityexpress.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('058491365', 'Barbara', 'Garber', '051-1402907', 'barbara.garber@mastercardinternational.gr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('701919398', 'Roddy', 'Bello', '051-9266586', 'roddy.bello@emt.lk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('770600157', 'Dabney', 'Irons', '059-7798989', 'd.irons@logisticare.nz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('175978110', 'Sona', 'Beatty', '053-5570203', 'sona.beatty@alogent.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('191792029', 'Rade', 'Larter', '056-3981035', 'rade@asa.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('054015391', 'Harriet', 'Washington', '051-3733032', 'harriet.washington@pulaskifinancial.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('737657037', 'Johnette', 'Rickles', '058-6361190', 'johnette.rickles@clubone.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('315680603', 'Kathleen', 'Marsden', '058-4395628', 'kathleen.marsden@componentgraphics.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('847250676', 'Wang', 'Sampson', '052-7169390', 'wsampson@iss.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('709267131', 'Rawlins', 'Hall', '053-6754537', 'rawlins.hall@hardwoodwholesalers.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('061215635', 'First', 'Maxwell', '056-4495779', 'fmaxwell@manhattanassociates.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('594588133', 'Eugene', 'Raye', '051-3512966', 'eraye@astute.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('659562823', 'Boyd', 'Blige', '056-8900428', 'bblige@wrgservices.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('423509159', 'Trini', 'Flack', '050-9277388', 'trini.flack@iss.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('214713146', 'Pablo', 'McGoohan', '053-1186458', 'pablo@cocacola.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('113439011', 'Carol', 'Colton', '052-7157830', 'c.colton@3tsystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('983955201', 'Randall', 'Saxon', '056-1193184', 'randall@cima.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('742980962', 'Balthazar', 'Bratt', '056-2473817', 'balthazar.bratt@authoria.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('605647155', 'Andrae', 'Gordon', '056-2967295', 'andrae.g@dbprofessionals.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('920423257', 'Gord', 'Tilly', '058-6133544', 'gtilly@totalentertainment.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('176288723', 'Gabrielle', 'Pleasure', '052-6747640', 'gabrielle@bmm.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('803660894', 'Rhett', 'Trejo', '055-4329953', 'r.trejo@trainersoft.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('230613965', 'Johnny', 'Playboys', '052-5397504', 'jplayboys@captechventures.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('136019878', 'Lydia', 'Colton', '054-3287037', 'lydia.colton@portosan.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('537520439', 'Owen', 'Crewson', '054-9340256', 'owen.crewson@parker.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('001852633', 'Angela', 'Hoskins', '053-1937277', 'angela.hoskins@staffforce.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('022601726', 'Jimmie', 'Orlando', '058-7525013', 'jimmie@fmt.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('915701674', 'Lynette', 'Eldard', '057-2982046', 'lynette.eldard@powerlight.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('584118594', 'Cyndi', 'Richards', '055-8355094', 'crichards@unica.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('516240456', 'Tia', 'Freeman', '054-5957696', 'tia.freeman@ris.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('638414377', 'Anna', 'Klein', '053-1586843', 'anna@dillards.cn');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('418350339', 'Temuera', 'Rawls', '059-3964125', 'temuera.r@democracydata.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('783546244', 'Joshua', 'Leigh', '058-9968453', 'j.leigh@fab.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('272137266', 'Stewart', 'Holbrook', '057-7190004', 'stewart.holbrook@monarchcasino.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('853596678', 'Jill', 'Stigers', '054-6775277', 'jills@sweetproductions.nz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('880659583', 'Night', 'Hynde', '054-5200575', 'night@teoco.no');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('917208879', 'Rhona', 'Anderson', '055-1867431', 'rhona.anderson@solutionbuilders.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('797864475', 'Lance', 'Woodard', '053-1579155', 'lance.woodard@spd.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('050573245', 'Goran', 'Day-Lewis', '058-1223005', 'gdaylewis@navigatorsystems.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('391830753', 'Tori', 'Ticotin', '052-5491968', 'tori@actechnologies.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('017131401', 'Dabney', 'Colin Young', '057-4614871', 'dabney.c@mss.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('288271621', 'Ricardo', 'Bailey', '059-9470976', 'ricardo.b@drinkmorewater.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('213468984', 'Merillee', 'Balk', '055-7169665', 'merillee@cyberthink.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('542150072', 'Deborah', 'Tah', '053-8822725', 'd.tah@bioanalytical.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('701389269', 'Casey', 'Twilley', '050-4518607', 'c.twilley@sfmai.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('202818990', 'Nastassja', 'Craig', '059-2680185', 'nastassja.craig@marketbased.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('649531134', 'Shawn', 'Preston', '050-6462846', 'shawn.preston@logisticare.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('493045396', 'Jose', 'Whitley', '059-3675369', 'jwhitley@egroup.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('178095346', 'Bob', 'Perez', '059-2461961', 'bob.perez@gtp.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('086072867', 'Ozzy', 'Huston', '053-7297199', 'ozzy.huston@priorityleasing.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('118249250', 'Olympia', 'Hong', '056-3459385', 'olympia.hong@dis.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('550309378', 'Kasey', 'Adams', '055-3296301', 'kasey.adams@harrison.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('771526024', 'LeVar', 'Azaria', '055-3994061', 'levar.azaria@quicksilverresources.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('398898388', 'Ernie', 'Schock', '053-9191332', 'e.schock@diamondgroup.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('265897934', 'Edwin', 'Chapman', '056-4645890', 'edwin@elitemedical.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('935950665', 'France', 'Rea', '056-2374828', 'france.rea@portosan.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('370469772', 'Freddie', 'McCracken', '050-5308726', 'freddie.mccracken@nike.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('585575998', 'Emmylou', 'Streep', '056-9940426', 'emmylou.streep@pscinfogroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('315275105', 'Jared', 'Spacey', '055-3763186', 'jared.spacey@nmr.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('929248322', 'Dave', 'Swank', '053-7430240', 'dave.swank@wlt.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('274585073', 'Wang', 'Rains', '058-7627184', 'wang.rains@marlabs.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('491469817', 'Julie', 'Margulies', '057-9956155', 'j.margulies@aristotle.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('776528409', 'Kim', 'Sevenfold', '056-4513725', 'kims@staffforce.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('958886144', 'Eileen', 'McFadden', '053-7653623', 'e.mcfadden@computersource.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('410246295', 'Matthew', 'Gallagher', '059-7888486', 'matthew.gallagher@actechnologies.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('758867042', 'Lara', 'Idol', '050-5796341', 'lara.idol@marathonheater.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('684705736', 'Rupert', 'Hurt', '054-3769755', 'rupert.hurt@diamondgroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('025673847', 'Alana', 'Atkins', '059-4148026', 'aatkins@pragmatechsoftware.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('357558771', 'Grace', 'Arden', '051-9923999', 'grace@bigdoughcom.lk');
commit;
prompt 400 records committed...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('462343871', 'Hugo', 'Witherspoon', '058-5911838', 'hwitherspoon@tilia.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('864337815', 'Fats', 'Addy', '059-3888111', 'fats.addy@kroger.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('703567359', 'Betty', 'Stuart', '058-6175365', 'bettys@news.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('583622232', 'Art', 'Winger', '058-6749580', 'art.w@grs.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('499584708', 'Carol', 'Lewis', '055-3689254', 'carol.lewis@career.za');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('467928419', 'Luis', 'Gough', '058-4433260', 'luis.gough@socketinternet.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('577957192', 'Brent', 'Beckinsale', '058-7370307', 'brentb@volkswagen.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('837162122', 'Gilberto', 'Conroy', '053-7298743', 'gilberto.c@extremepizza.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('044973672', 'Juliana', 'Holbrook', '056-2539081', 'juliana.holbrook@cima.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('919166928', 'Gilbert', 'Palin', '057-6494799', 'gilbert.palin@studiobproductions.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('666467223', 'Rosco', 'Carmen', '059-2750998', 'rosco.carmen@medamicus.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('819819701', 'Geena', 'Paige', '057-8484916', 'geena.p@accurateautobody.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('824236874', 'Frankie', 'Palmer', '056-9658601', 'frankie@consultants.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('675892635', 'Burton', 'Stanley', '059-8165614', 'burton.stanley@paisley.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('350227847', 'Kathleen', 'Botti', '057-5257322', 'kathleen.botti@otbd.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('612429225', 'Merrilee', 'Jeter', '054-1891165', 'merrilee.jeter@tigris.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('377113286', 'Daryle', 'Gagnon', '053-7735918', 'daryle.gagnon@trafficmanagement.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('640564776', 'Nils', 'Ellis', '058-2166767', 'nilse@dsp.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('325564832', 'Vonda', 'Sizemore', '059-8943495', 'vonda@voicelog.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('391352233', 'Halle', 'Horton', '055-1403204', 'halle.h@onesourceprinting.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('232611240', 'Denise', 'McCormack', '059-7258337', 'denise.m@news.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('031067483', 'Kris', 'Brando', '058-5628939', 'krisb@pragmatechsoftware.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('888279161', 'Charlie', 'Polito', '057-6654225', 'charliep@generalelectric.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('395212095', 'Hope', 'Conners', '054-9569823', 'hope.c@bmm.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('574465011', 'Kurt', 'Elizabeth', '051-3256194', 'kurt.e@mwh.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('453914186', 'Etta', 'Horton', '054-3154985', 'etta.horton@ahl.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('044221919', 'Jeff', 'Jovovich', '055-8186424', 'jeff.jovovich@kingston.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('000000373', 'Zooey', 'Holeman', '059-4200364', 'zooey.holeman@fmt.no');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('820807804', 'Charlie', 'Loveless', '053-3737177', 'charlie.loveless@yes.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('136074808', 'Darius', 'Lightfoot', '059-7554785', 'darius.lightfoot@sms.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('107455196', 'Lou', 'Carr', '059-2275328', 'lou.carr@fmt.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('520822644', 'Stockard', 'Condition', '051-7629984', 'stockardc@httprint.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('275681892', 'Whoopi', 'Carter', '053-3702851', 'whoopi.carter@techbooks.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('766927859', 'Bob', 'Green', '059-2491450', 'bgreen@spotfireholdings.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('917027351', 'Adina', 'McCracken', '054-1532627', 'adina.mccracken@bristolmyers.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('874481938', 'Blair', 'Ryder', '054-6369118', 'blairr@connected.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('338766535', 'Nelly', 'Stuermer', '057-4751743', 'n.stuermer@dearbornbancorp.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('974383847', 'Geena', 'Hornsby', '055-1362209', 'geena.h@data.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('871507308', 'Louise', 'Gracie', '057-7451504', 'louise.gracie@priorityexpress.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('889590325', 'Aimee', 'Mueller-Stahl', '056-5235370', 'aimee.muellerstahl@asa.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('751666263', 'Armin', 'Rock', '052-4314953', 'armin.r@staffforce.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('517024610', 'Val', 'Diaz', '056-7687824', 'v.diaz@pinnaclestaffing.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('332935578', 'Steven', 'Polley', '058-8722932', 'steven.polley@ubp.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('419340592', 'Judd', 'Weaving', '051-2574895', 'judd.weaving@viacom.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('259058467', 'Wallace', 'Harrelson', '051-6190642', 'wallace.harrelson@bowman.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('319029281', 'Alana', 'Wells', '059-5849921', 'alana.wells@trafficmanagement.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('299064885', 'Oliver', 'Dushku', '055-8456511', 'oliver.dushku@stm.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('739670228', 'Emmylou', 'Moreno', '057-1464867', 'emmyloum@avr.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('915372180', 'Dennis', 'MacDowell', '052-9695564', 'dennis@limitedbrands.fi');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('173956351', 'Gordon', 'McCoy', '055-4281973', 'gordon.mccoy@ghrsystems.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('309357389', 'Boz', 'Magnuson', '056-5251836', 'boz.magnuson@lindin.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('515315680', 'Ming-Na', 'Hauser', '053-2121164', 'mingna.hauser@nrae.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('542900586', 'Tim', 'Van Der Beek', '054-8406166', 'tim.vanderbeek@columbiabancorp.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('659523446', 'Deborah', 'Brolin', '056-4458706', 'deborah.brolin@netnumina.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('464050791', 'Chuck', 'Kingsley', '056-3177142', 'c.kingsley@caliber.sg');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('320343973', 'Nigel', 'Channing', '054-3335576', 'nigel.channing@glmt.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('735041444', 'Nile', 'Griffiths', '054-8349539', 'ngriffiths@mai.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('238684624', 'Neil', 'Campbell', '050-7807787', 'neil.campbell@savela.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('047443186', 'Taylor', 'McConaughey', '054-6160886', 'taylor.mcconaughey@visionarysystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('019138380', 'Josh', 'McPherson', '055-3723253', 'joshm@telepoint.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('345211820', 'Donna', 'Baker', '058-7863808', 'donna.baker@usenergyservices.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('367775460', 'Whoopi', 'Clinton', '057-9989910', 'whoopi@ivorysystems.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('600730948', 'Carlos', 'Bragg', '054-4429966', 'carlos.bragg@glaxosmithkline.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('033035228', 'Nickel', 'Parsons', '055-5598958', 'nickelp@actechnologies.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('425514673', 'Candice', 'Dern', '054-9928943', 'cdern@isd.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('826605920', 'Davey', 'Rhys-Davies', '058-4801808', 'drhysdavies@gagwear.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('353506388', 'Parker', 'Marx', '058-6735160', 'parker.marx@oriservices.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('655467575', 'Graham', 'Stampley', '051-4174724', 'graham.stampley@typhoon.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('559859523', 'Richie', 'Murphy', '052-6890246', 'richiem@fetchlogistics.cn');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('191188653', 'Lesley', 'Amos', '052-6937409', 'l.amos@elite.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('247748869', 'Sinead', 'Warden', '053-1214491', 'sinead.warden@bioanalytical.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('438188432', 'Randy', 'Avital', '057-7238484', 'randy.avital@trekequipment.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('799425752', 'Clea', 'Oldman', '059-8763644', 'clea.oldman@diageo.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('605478786', 'Steven', 'Simpson', '056-6116413', 'steven.s@nobrainerblindscom.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('488486840', 'Swoosie', 'Van Helden', '058-5593376', 'swoosie.vanhelden@gentrasystems.ec');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('246071605', 'Armand', 'Tennison', '054-5709195', 'armand@trekequipment.pk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('188284365', 'Raymond', 'Chao', '054-8465407', 'raymond.chao@newhorizons.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('047336806', 'Ed', 'Spall', '051-2770171', 'ed34@aldensystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('469016250', 'Ernest', 'Kennedy', '058-5552853', 'ernest.kennedy@mse.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('257532494', 'Nils', 'Mraz', '050-7156281', 'n.mraz@adeasolutions.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('658307215', 'Jean', 'Garfunkel', '057-9932673', 'jeang@grs.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('420330006', 'Sinead', 'Gilley', '052-5726657', 'sinead.g@ultimus.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('711123768', 'Neneh', 'Jenkins', '051-8208610', 'neneh@yes.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('831042091', 'Stephen', 'Crewson', '053-3373969', 'stephen.crewson@larkinenterprises.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('345435091', 'Hikaru', 'Torres', '056-6974449', 'h.torres@wci.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('342761949', 'Cloris', 'Eastwood', '050-3164270', 'cloris.eastwood@smartdrawcom.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('712011708', 'Jet', 'Leoni', '058-6563924', 'jet.l@iss.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('989981369', 'Mandy', 'Arden', '050-7444075', 'mandy.arden@airmethods.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('066613546', 'Fisher', 'Deejay', '058-8563459', 'f.deejay@coldstonecreamery.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('806629624', 'Gina', 'Westerberg', '059-5563337', 'ginaw@gha.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('257490434', 'Miles', 'Harrelson', '056-8171165', 'm.harrelson@fflcbancorp.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('848802333', 'Cornell', 'McGregor', '058-2607231', 'cornell.mcgregor@sandyspringbancorp.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('894862066', 'Neneh', 'Daniels', '051-1721396', 'ndaniels@usgovernment.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('897822661', 'Corey', 'Palmer', '054-2744616', 'corey.palmer@mattel.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('616691834', 'Leon', 'Tisdale', '053-6585863', 'leont@wav.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('269524383', 'Ronny', 'Utada', '053-1869333', 'ronny@nha.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('191839343', 'Jann', 'Turturro', '056-3669035', 'jann.turturro@ssi.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('390905524', 'Ricardo', 'Yorn', '051-7964218', 'ricardo.yorn@generalmills.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('682014481', 'Pam', 'Gallagher', '057-3275090', 'pam.gallagher@asapstaffing.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('572329361', 'Hope', 'Paige', '057-7696940', 'hope.paige@infovision.com');
commit;
prompt 500 records committed...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('408430230', 'Minnie', 'Thomas', '057-6713969', 'minnie.thomas@gha.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('691197193', 'Colm', 'McGriff', '059-8176667', 'colm.mcgriff@technica.no');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('142861817', 'Moe', 'Benoit', '050-2298761', 'moe.benoit@mindiq.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('527971188', 'Sean', 'Imbruglia', '057-9673050', 'sean.imbruglia@viacell.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('226545801', 'Kasey', 'Underwood', '052-4805530', 'kasey.underwood@aquascapedesigns.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('165906299', 'Cameron', 'Marin', '051-8538683', 'cameron.marin@gna.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('448707100', 'Sona', 'Meyer', '059-9803348', 'smeyer@abatix.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('053166731', 'Glenn', 'Peterson', '055-5640740', 'glenn.peterson@infinity.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('487301584', 'Lionel', 'Ledger', '051-7854180', 'lledger@tmt.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('498371690', 'Jet', 'Young', '054-8714549', 'jet.young@credopetroleum.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('499064100', 'Teena', 'Greenwood', '055-7598029', 'tgreenwood@tigris.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('145366143', 'Ramsey', 'Supernaw', '053-5379937', 'ramsey.s@inzone.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('413667913', 'Billy', 'Guest', '056-6493276', 'billy@career.za');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('898194084', 'Kenny', 'Clark', '052-2849093', 'kenny.clark@dis.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('441785402', 'Loreena', 'Firth', '050-3851816', 'loreena.firth@lemproducts.pk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('311894913', 'Mindy', 'Cruise', '051-9846083', 'mindy.cruise@northhighland.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('631512677', 'Gaby', 'Rain', '053-2828776', 'gaby.rain@ssci.nz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('154465176', 'Edie', 'Thorton', '050-8161179', 'edie.thorton@httprint.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('706196502', 'Naomi', 'Murray', '057-7418537', 'naomi.murray@nrae.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('000227973', 'Julia', 'Hanks', '056-6551278', 'j.hanks@visionarysystems.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('691006719', 'Patti', 'Reilly', '057-4390230', 'patti.reilly@timevision.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('085170682', 'Kelly', 'Ammons', '056-5441692', 'kellya@sensortechnologies.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('633954768', 'Jet', 'Noseworthy', '054-8884462', 'jet.n@marketfirst.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('049618908', 'Bruce', 'Osment', '050-5998551', 'bruce.osment@generalmills.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('239960682', 'Jimmie', 'Bale', '054-7889864', 'jimmie@stonebrewing.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('229940397', 'Tamala', 'Levin', '051-4798707', 'tamala.levin@commworks.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('271730213', 'Heath', 'Vaughan', '058-5220442', 'heath.vaughan@procurementcentre.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('078881161', 'Xander', 'Waite', '059-1184961', 'xander@sfmai.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('058608539', 'Kirk', 'Gray', '053-4348461', 'kirk.gray@nestle.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('039153067', 'Karen', 'O''Neal', '055-5375805', 'karen.oneal@solipsys.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('281102853', 'Carole', 'Smurfit', '055-4619216', 'carole.smurfit@marathonheater.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('006032305', 'ChantÃ©', 'Tolkan', '057-9926036', 'chant.tolkan@bioanalytical.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('021781827', 'Cary', 'Pesci', '055-9426440', 'cary.pesci@ppr.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('638353369', 'Micky', 'MacDowell', '059-9433903', 'micky.macdowell@marketbased.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('262516172', 'Gordie', 'Hiatt', '059-2318687', 'gordie@capitalautomotive.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('560046205', 'Mika', 'Botti', '053-6877496', 'mika.b@avs.pl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('801462183', 'Milla', 'Sledge', '050-9550958', 'milla.sledge@idlabel.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('782812737', 'Walter', 'Wariner', '052-1102849', 'walter.wariner@signalperfection.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('424018298', 'Melba', 'Prowse', '054-6973277', 'melbap@marlabs.ar');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('043939492', 'Rutger', 'McCain', '056-5272238', 'rutger@lfg.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('299723849', 'Daryle', 'Eldard', '056-7638711', 'daryle.eldard@diamondtechnologies.gr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('957911531', 'Wally', 'Spacey', '057-2412344', 'wally.spacey@fordmotor.be');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('667461962', 'Carla', 'Beckham', '055-1341607', 'carla.beckham@north.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('409480749', 'Harvey', 'Garfunkel', '052-1228070', 'hgarfunkel@timevision.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('795230625', 'Will', 'Hewitt', '055-3430657', 'will.hewitt@walmartstores.li');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('035510904', 'Jim', 'Ontiveros', '051-1400777', 'jim.ontiveros@bradleypharmaceuticals.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('874752399', 'Ani', 'Cotton', '051-3333906', 'ani.c@seafoxboat.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('276172223', 'Leo', 'Forrest', '054-1989298', 'leo.forrest@supplycorecom.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('085479466', 'Sharon', 'Russell', '053-1555000', 'sharon@ungertechnologies.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('418527819', 'Nathan', 'Todd', '052-7618238', 'nathan.todd@microsoft.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('736410796', 'Patti', 'Stewart', '058-2574618', 'patti.stewart@hatworld.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('647813072', 'Sammy', 'Nicholson', '058-8679717', 'sammy@ufs.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('134735294', 'Reese', 'Ball', '057-3365235', 'reese@denaliventures.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('968200663', 'Rhona', 'Garber', '052-4344404', 'rhona.garber@mastercardinternational.tw');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('853948884', 'Mykelti', 'Cube', '057-5425421', 'm.cube@servicesource.cy');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('266678933', 'Sean', 'Patton', '051-8144241', 'sean.patton@staffforce.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('602505536', 'Busta', 'Nelson', '052-4107436', 'busta@lindin.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('124207649', 'Marley', 'Baldwin', '058-4417163', 'marley.baldwin@grs.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('524896676', 'Frank', 'Woodward', '054-7519927', 'fwoodward@vfs.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('942709715', 'Pierce', 'Carnes', '055-2131430', 'pierce@safeway.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('082415344', 'Jason', 'Bale', '053-2381798', 'jason@pioneermortgage.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('851278188', 'Loreena', 'Hatfield', '050-9993004', 'loreena.hatfield@innovativelighting.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('765668671', 'Harrison', 'Oakenfold', '050-1159196', 'harrison.oakenfold@at.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('157451231', 'Vondie', 'Karyo', '059-3702843', 'vondie.karyo@apexsystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('024965933', 'Gordon', 'Hall', '053-9863532', 'gordon.hall@linacsystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('636976970', 'Brenda', 'Sevenfold', '051-9390464', 'brenda.sevenfold@younginnovations.fi');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('313589600', 'CeCe', 'Sizemore', '059-6353232', 'cece.sizemore@mls.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('279593900', 'Famke', 'Reynolds', '055-5765295', 'freynolds@prahs.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('267137605', 'Tcheky', 'Chinlund', '051-4768055', 'tcheky@outsourcegroup.ee');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('569056506', 'Robin', 'Kotto', '055-1943602', 'robin.kotto@perfectorder.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('407435967', 'Joaquin', 'Stanton', '059-9864173', 'joaquins@ceom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('526829293', 'Campbell', 'Lucien', '054-3801506', 'campbell.lucien@coldstonecreamery.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('675987499', 'Curtis', 'Hoffman', '054-1451477', 'curtish@sysconmedia.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('748956828', 'Mandy', 'Gleeson', '053-6186777', 'mandy@cooktek.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('276069105', 'Terri', 'Snipes', '054-5379255', 'terri@glmt.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('526390671', 'Gord', 'DiFranco', '051-9780680', 'gdifranco@tilia.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('561307053', 'Shannyn', 'Keaton', '056-2252557', 'shannyn.k@fra.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('122728860', 'Sonny', 'Tillis', '057-3839615', 'sonny.tillis@staffone.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('499600585', 'Wally', 'Carnes', '050-6691715', 'wally.carnes@marriottinternational.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('083529961', 'Chrissie', 'Roundtree', '052-4981242', 'chrissie.roundtree@diversitech.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('990106578', 'Elias', 'Coltrane', '051-4578464', 'elias.coltrane@marriottinternational.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('195785327', 'Dustin', 'Orbit', '056-3619466', 'dustin.orbit@capstone.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('328510722', 'Nastassja', 'Dillon', '059-5290135', 'nastassja.d@cardinalcartridge.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('402909496', 'Junior', 'Chandler', '053-1577281', 'junior.chandler@mls.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('545498579', 'Vickie', 'Randal', '057-9264651', 'vickie.randal@qas.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('268281389', 'Rickie', 'Hampton', '053-1549590', 'rickie.hampton@envisiontelephony.mx');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('812794163', 'Howard', 'Austin', '055-2462327', 'howard@ach.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('047164055', 'Lupe', 'De Almeida', '051-1923624', 'lupe.dealmeida@bis.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('070289159', 'Kiefer', 'Lauper', '051-6597889', 'kiefer@capstone.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('465132803', 'Boz', 'Loring', '057-5476160', 'boz.loring@inzone.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('701763678', 'Tyrone', 'Paymer', '051-4952260', 'tyrone@sht.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('485283160', 'Vin', 'Place', '057-4200150', 'vin.place@prometheuslaboratories.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('399115145', 'Devon', 'Hurt', '055-7790046', 'devon.hurt@calence.tr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('931249937', 'Mitchell', 'Buffalo', '058-8164248', 'mitchell@ssci.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('451097488', 'Rufus', 'Solido', '058-8282495', 'rufus.solido@gdatechnologies.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('432425942', 'Yaphet', 'Pacino', '050-4974720', 'yaphet.pacino@ciwservices.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('770572515', 'Eileen', 'Cooper', '055-4590994', 'eileen.cooper@simplycertificates.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('843052995', 'Rhea', 'Charles', '055-6283090', 'rhea.charles@nha.za');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('130330261', 'Bo', 'Sweet', '053-4628894', 'bo55@savela.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('652120441', 'Danni', 'Fox', '050-5493586', 'danni@sunstream.com');
commit;
prompt 600 records committed...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('113036851', 'Terry', 'Charles', '055-3747152', 'terryc@north.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('749084891', 'Taye', 'Supernaw', '059-5893855', 'tsupernaw@colgatepalmolive.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('703934746', 'Lindsey', 'Khan', '058-7580755', 'lindsey@mathis.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('028369330', 'Etta', 'Loggia', '051-8602770', 'etta.l@bashen.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('644249525', 'Larry', 'Barkin', '056-4955396', 'larry.barkin@invisioncom.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('664089285', 'Nanci', 'Leachman', '053-9482218', 'nanci.leachman@fds.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('240939313', 'Keith', 'Kleinenberg', '051-2380972', 'k.kleinenberg@knightsbridge.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('676285276', 'Bradley', 'Bracco', '056-1254327', 'bradley.bracco@carteretmortgage.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('336762195', 'Arturo', 'Trejo', '058-2224745', 'arturo.trejo@marathonheater.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('251808841', 'Jonny Lee', 'Diaz', '058-9120988', 'jonnylee.diaz@bis.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('430085688', 'Jimmy', 'Stigers', '056-8740217', 'jstigers@accucode.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('786139051', 'Trini', 'Buscemi', '053-9467550', 'trini.buscemi@cima.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('914006622', 'Bridgette', 'Beals', '055-4236770', 'bridgette@grt.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('274453753', 'Ty', 'Chaplin', '055-4710163', 'ty38@saltgroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('217722887', 'Daryle', 'Hynde', '051-2765329', 'daryle.hynde@totalentertainment.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('696182052', 'Jeremy', 'Bullock', '055-5941172', 'jeremy.b@timevision.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('064598882', 'Michelle', 'Guzman', '058-5677495', 'michelle@bioanalytical.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('392793365', 'Tal', 'Van Shelton', '056-8804298', 'tvanshelton@investorstitle.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('432884692', 'Tori', 'Patton', '058-8828868', 'tori.patton@nhhc.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('379348654', 'Neneh', 'Darren', '059-1154023', 'neneh.darren@nlx.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('192482567', 'Buffy', 'Pleasence', '058-7225028', 'buffy.pleasence@ssci.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('110778805', 'Joy', 'Alexander', '053-5788364', 'joya@dcgroup.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('129715075', 'Stewart', 'Carrere', '054-2508146', 'stewart.carrere@gapinc.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('826540393', 'Jamie', 'Dawson', '051-1394914', 'jamie.dawson@jlphor.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('420306834', 'Mos', 'Farrow', '058-4958994', 'm.farrow@outsourcegroup.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('158408708', 'Oded', 'Garofalo', '053-7240210', 'o.garofalo@freedommedical.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('468380581', 'Mary', 'Moody', '055-7986757', 'mary.moody@gna.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('297377031', 'Tia', 'Ribisi', '055-7905102', 'tribisi@amerisourcefunding.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('266684771', 'Courtney', 'Winwood', '055-8860486', 'courtney.winwood@parker.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('000677810', 'Mili', 'Dawson', '053-3294498', 'm.dawson@astute.no');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('011793529', 'Chubby', 'Merchant', '056-7846325', 'chubby.merchant@powerlight.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('273888222', 'Treat', 'Briscoe', '051-4852638', 'treat.briscoe@portageenvironmental.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('507560616', 'Maria', 'Nicholas', '056-7312902', 'maria.nicholas@lemproducts.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('789947168', 'Tracy', 'Ingram', '053-5972054', 'tracy@unilever.no');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('045601319', 'Gino', 'Willis', '052-7357538', 'gino.willis@catamount.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('901820276', 'Rosanna', 'Richards', '058-1377865', 'rosanna@angieslist.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('917553275', 'Rachael', 'Eastwood', '050-1230033', 'rachael@ungertechnologies.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('440899723', 'Kurtwood', 'Stevenson', '054-3551061', 'kstevenson@powerlight.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('694117241', 'Stanley', 'Sainte-Marie', '052-9623292', 'stanley.saintemarie@newhorizons.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('235761739', 'Aaron', 'Esposito', '052-1255155', 'aaron.esposito@ogiointernational.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('423593942', 'Mary', 'Preston', '058-5841666', 'mary@trekequipment.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('216475555', 'Ben', 'Kapanka', '050-7834502', 'ben@team.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('963083303', 'Cyndi', 'Pepper', '054-2128231', 'cyndi.pepper@efcbancorp.hk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('843169084', 'Wes', 'Hutton', '054-1965540', 'wes.hutton@usphysicaltherapy.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('766598824', 'Molly', 'Shaye', '057-9968135', 'molly.shaye@max.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('562094648', 'Bradley', 'Reid', '052-5872116', 'b.reid@cooktek.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('528625739', 'Eliza', 'Brolin', '053-7501145', 'eliza.brolin@tastefullysimple.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('129199289', 'Annette', 'Byrd', '058-1512266', 'a.byrd@reckittbenckiser.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('196176567', 'Emma', 'Kramer', '053-4599137', 'emma.kramer@diamondgroup.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('915567582', 'Rufus', 'Starr', '055-9575583', 'rufus.starr@prp.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('464019730', 'Lorraine', 'Davidtz', '056-9325940', 'lorraine.davidtz@americanland.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('694825764', 'Jon', 'Li', '051-4829386', 'jon.li@heritagemicrofilm.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('949755377', 'Liam', 'Loggins', '051-2725698', 'liam.loggins@epiqsystems.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('014082919', 'Nils', 'Bandy', '052-4480681', 'nils@its.id');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('927176671', 'Joely', 'McKennitt', '058-5490480', 'joely@hardwoodwholesalers.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('297681984', 'Ceili', 'Weaver', '054-8870941', 'ceili.weaver@atxforms.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('909474381', 'Suzy', 'Williams', '053-6151751', 'suzy.w@dell.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('235099187', 'Willie', 'Yorn', '058-8735689', 'willie.yorn@myricom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('218117404', 'Rosie', 'Hornsby', '055-7443818', 'rosie.hornsby@dillards.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('453202055', 'Delbert', 'Marley', '055-3448822', 'd.marley@tastefullysimple.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('697846160', 'Alana', 'Stiers', '050-5806232', 'alana.stiers@usgovernment.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('171756391', 'Jose', 'Richter', '054-6336122', 'jose.richter@walmartstores.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('494302245', 'Nathan', 'Yulin', '059-4229502', 'nathany@sweetproductions.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('973642055', 'Clive', 'Visnjic', '055-4208134', 'c.visnjic@saltgroup.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('965000417', 'Kathleen', 'Wopat', '052-5699696', 'kathleen.wopat@parksite.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('168438555', 'Mos', 'Krumholtz', '052-6800572', 'mos.krumholtz@scriptsave.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('545327628', 'Charles', 'Lapointe', '052-8595636', 'charles.lapointe@bis.mx');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('141964984', 'Sigourney', 'Duvall', '052-9702314', 'sigourney.d@keymark.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('446332100', 'Victor', 'Bugnon', '051-1837684', 'vbugnon@mission.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('528053223', 'Claire', 'Cash', '052-3528483', 'ccash@learningvoyage.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('498766701', 'Garth', 'Jones', '057-3709465', 'garth.j@meritagetechnologies.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('549134893', 'Leo', 'McCain', '051-3702974', 'lmccain@mosaic.li');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('662443577', 'Ann', 'Guilfoyle', '058-8150357', 'aguilfoyle@caliber.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('105362227', 'Vin', 'Hampton', '052-5430132', 'vin.hampton@trinityhomecare.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('273149266', 'Jimmy', 'Singh', '059-3584610', 'jimmy.singh@oriservices.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('647332571', 'Kimberly', 'Porter', '056-4108145', 'kimberly@bioreference.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('169511260', 'Shelby', 'Northam', '055-9253256', 'shelby.northam@aco.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('158263429', 'Aaron', 'Quinones', '057-7501731', 'aaron@johnson.pk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('896401490', 'Ike', 'Thewlis', '051-1624320', 'ike.thewlis@aco.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('350849342', 'First', 'Miller', '058-2494234', 'fmiller@larkinenterprises.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('116286471', 'Xander', 'McBride', '054-3606955', 'xander.mcbride@kmart.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('830383231', 'Milla', 'Gatlin', '057-6923034', 'milla.gatlin@capitalautomotive.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('978514891', 'Mindy', 'Affleck', '056-9519499', 'mindy.affleck@allegiantbancorp.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('310404144', 'Ron', 'Robbins', '058-5136535', 'ron@scooterstore.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('457965167', 'Morgan', 'Shandling', '058-1440838', 'mshandling@ositissoftware.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('035748677', 'Peter', 'Wilder', '058-5227500', 'peter.wilder@slt.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('032258252', 'Marianne', 'Candy', '054-3432540', 'marianne@mindiq.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('809030912', 'Geena', 'Furay', '055-4314946', 'geena.furay@bat.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('799881575', 'Illeana', 'Bullock', '054-2700238', 'illeana.bullock@staffone.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('865749202', 'Angela', 'Giannini', '055-5535779', 'angela.giannini@gcd.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('141166296', 'Rip', 'Carter', '059-9760488', 'r.carter@lfg.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('811052060', 'Hank', 'Loring', '056-6831794', 'hloring@accuship.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('591957858', 'Malcolm', 'urban', '055-1720328', 'malcolm.urban@mre.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('975869804', 'Victor', 'Renfro', '059-7841790', 'victor.r@grayhawksystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('255474214', 'Madeleine', 'Niven', '055-8878549', 'madeleine.niven@tilsonlandscape.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('056513237', 'Jean-Luc', 'Stigers', '053-6300076', 'jeanlucs@mai.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('137607044', 'Terry', 'Borden', '055-1645582', 'terryb@allegiantbancorp.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('046657439', 'Wally', 'Franklin', '054-8131391', 'wallyf@hondamotor.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('664042086', 'Petula', 'Sedaka', '050-4390799', 'psedaka@gagwear.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('523070923', 'Oliver', 'Van Damme', '053-1868857', 'oliver.vandamme@atg.com');
commit;
prompt 700 records committed...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('096353906', 'Fats', 'Hayek', '053-7894299', 'fats.hayek@sht.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('584982157', 'Owen', 'Liu', '050-6588930', 'owen.liu@uem.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('414863719', 'Don', 'Soul', '050-3974583', 'don.soul@timevision.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('613155757', 'Busta', 'Brody', '054-3566347', 'busta.brody@ois.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('541078774', 'Bobby', 'Torres', '054-4852412', 'bobby.t@virbac.il');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('708927780', 'Natasha', 'Mortensen', '058-1516029', 'natasha@contract.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('530838321', 'Vern', 'Keith', '056-2506481', 'vkeith@technica.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('424762764', 'Thin', 'Simpson', '052-4248423', 'thin.simpson@veritekinternational.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('729801502', 'Mandy', 'Lawrence', '057-5330155', 'mandy.lawrence@mag.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('233208157', 'Rutger', 'Depp', '056-4391344', 'rutger@balchem.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('983492574', 'Stockard', 'Shocked', '053-2602033', 'sshocked@advancedneuromodulation.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('141376208', 'Jeffery', 'Clooney', '050-3338892', 'jeffery.clooney@spd.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('160685460', 'Davy', 'Mahoney', '051-7522391', 'davy.m@worldcom.is');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('725710319', 'Goran', 'Hanley', '052-1276363', 'goran.hanley@asapstaffing.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('294428713', 'Elle', 'Esposito', '052-8159287', 'e.esposito@americanmegacom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('938990393', 'Nicky', 'Lofgren', '055-8222004', 'nicky.lofgren@mainstreetbanks.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('418542865', 'Janeane', 'Hawke', '054-5680698', 'janeaneh@hencie.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('175375438', 'Harris', 'Whitford', '053-7248767', 'harrisw@sunstream.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('771314895', 'LeVar', 'Mattea', '053-5668822', 'levar.m@techrx.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('737691770', 'Pete', 'Neeson', '054-1553987', 'pete.neeson@diageo.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('054248733', 'Suzy', 'Lightfoot', '057-6513114', 'suzy.lightfoot@entelligence.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('376247399', 'Jennifer', 'Levine', '052-4352914', 'jennifer.levine@shirtfactory.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('189152630', 'Charlize', 'Snow', '051-4697737', 'charlize.snow@sht.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('844554382', 'Frederic', 'Fiennes', '052-8811084', 'frederic.f@walmartstores.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('001709568', 'Jodie', 'Moraz', '053-5417525', 'jodie.moraz@sds.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('776831477', 'Beth', 'Chesnutt', '057-9520774', 'beth.c@novartis.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('180191326', 'Chi', 'Farrell', '057-5825984', 'chi.farrell@tilia.ge');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('250647449', 'Nikki', 'Baldwin', '058-9647338', 'nikki.baldwin@astute.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('219278525', 'Collin', 'Meyer', '053-3518678', 'collin.meyer@datawarehouse.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('878919173', 'Rik', 'Kinney', '050-9795830', 'rik@ris.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('316852675', 'Armin', 'Torres', '055-8372039', 'armin.torres@bradleypharmaceuticals.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('711309756', 'Darren', 'Wills', '058-5379687', 'darren.wills@ceb.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('625529602', 'Neil', 'Farrow', '050-4930079', 'neil@pharmafab.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('886314861', 'France', 'Bracco', '050-2502281', 'france.bracco@carboceramics.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('075665329', 'Lonnie', 'Tarantino', '058-7131442', 'lonnie.tarantino@mse.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('668963614', 'Chrissie', 'Robbins', '058-2405034', 'chrissie.robbins@spinnakerexploration.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('523453408', 'Gerald', 'Pressly', '053-4851833', 'gerald.pressly@valleyoaksystems.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('081383228', 'Kelli', 'Krieger', '050-1855959', 'k.krieger@air.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('745504002', 'Clay', 'Tilly', '051-2995718', 'clay.tilly@oneidafinancial.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('659345030', 'Bonnie', 'Capshaw', '051-6289524', 'bonnie@bashen.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('819874679', 'Gord', 'Irving', '051-9905765', 'gordi@sears.nz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('270873479', 'Chad', 'Ojeda', '050-4426197', 'chad.ojeda@cendant.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('031510193', 'Renee', 'Idol', '052-9609044', 'renee.idol@marlabs.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('025953504', 'Jonny', 'Sevenfold', '056-6333798', 'jonny.sevenfold@granitesystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('846104984', 'Lisa', 'Harrelson', '055-9687547', 'lisa.harrelson@shar.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('126770208', 'Daryl', 'Richardson', '052-4177876', 'daryl.richardson@kimberlyclark.nc');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('578516249', 'Isaiah', 'Palminteri', '052-5559205', 'isaiah.palminteri@avs.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('515228364', 'Fats', 'Wainwright', '059-7955656', 'fats@lydiantrust.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('159620386', 'Jane', 'Daniels', '055-1636968', 'jane.daniels@esteelauder.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('171523839', 'Vincent', 'Elizondo', '052-7399188', 'vincent.elizondo@nbs.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('887892305', 'Angela', 'Krabbe', '056-1399387', 'angela@floorgraphics.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('055249826', 'Neve', 'Skerritt', '059-1468484', 'n.skerritt@digitalmotorworks.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('214335504', 'Orlando', 'Channing', '056-8968951', 'orlando.channing@trinityhomecare.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('165713379', 'Remy', 'Llewelyn', '050-5768420', 'remy.llewelyn@ctg.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('622978701', 'Malcolm', 'Warburton', '056-7570457', 'malcolm.warburton@mwh.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('943319539', 'Ricky', 'McClinton', '050-4720611', 'rickym@team.nz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('271175180', 'Bridgette', 'Shannon', '050-9895900', 'bridgette.shannon@curagroup.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('352848576', 'Thora', 'Silverman', '054-3566166', 'tsilverman@ubp.lk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('685213103', 'Terence', 'Rawls', '053-5111157', 'terence.rawls@aquickdelivery.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('868932233', 'Rolando', 'Richards', '057-4561472', 'rolando.richards@kwraf.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('034411863', 'Merrilee', 'Guinness', '058-5730261', 'merrilee.g@biosite.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('448095428', 'Fred', 'Cantrell', '053-9338644', 'fred@ptg.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('967478251', 'Graham', 'Cara', '050-9246433', 'grahamc@commworks.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('992475501', 'Harrison', 'Pryce', '051-9652569', 'harrisonp@bradleypharmaceuticals.il');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('479610161', 'Edwin', 'Holiday', '052-1447823', 'edwin.holiday@navigatorsystems.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('412171831', 'Dabney', 'Chambers', '051-2646858', 'dabney.chambers@nat.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('430047829', 'Todd', 'Badalucco', '054-6269604', 'tbadalucco@adolph.nz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('978612834', 'Marisa', 'Janney', '055-2308545', 'm.janney@nobrainerblindscom.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('376926882', 'Alessandro', 'Byrd', '055-7918013', 'abyrd@surmodics.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('334283784', 'Annie', 'Goodall', '055-3737119', 'annie.g@unilever.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('164868085', 'Jared', 'Salt', '050-8464074', 'jared.salt@horizon.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('610867226', 'Gordie', 'Rawls', '056-3891224', 'gordie.rawls@circuitcitystores.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('553241085', 'Freddy', 'Page', '050-8882906', 'fpage@cardtronics.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('128447737', 'Aimee', 'Nolte', '051-6452095', 'aimee.nolte@manhattanassociates.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('937829536', 'Benicio', 'Myers', '050-4586824', 'benicio.myers@processplus.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('671495319', 'Jamie', 'Donovan', '057-5354419', 'j.donovan@younginnovations.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('567000152', 'Cathy', 'Allen', '050-4756230', 'c.allen@cardinalcartridge.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('713944647', 'Carrie-Anne', 'Esposito', '057-6542659', 'carrieanne.esposito@progressivemedical.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('161807813', 'Dwight', 'Boorem', '051-1285091', 'dwight.boorem@parker.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('097482024', 'Ned', 'Thewlis', '051-5663908', 'ned@chipssolutions.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('521506362', 'Red', 'Van Damme', '056-5591741', 'red.vandamme@envisiontelephony.pk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('356235416', 'Jonathan', 'Gryner', '050-6378914', 'jonathan@gapinc.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('251574841', 'Thelma', 'Feore', '055-4843866', 'thelma.f@ubp.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('054807164', 'Tea', 'Keen', '051-7148092', 'tea.keen@insurmark.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('094482935', 'Carrie', 'Zevon', '055-9884155', 'c.zevon@visionarysystems.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('360811323', 'Roberta', 'Landau', '053-5125008', 'roberta.landau@capstone.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('756952320', 'Hilary', 'Todd', '057-3544845', 'h.todd@innovateecommerce.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('700299055', 'Joe', 'O''Hara', '057-4585405', 'joe.ohara@generalmills.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('747387759', 'Gene', 'Bragg', '055-8641904', 'g.bragg@ceom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('268532341', 'Pablo', 'Beckinsale', '058-8390108', 'pablob@manhattanassociates.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('342249641', 'Fred', 'Evanswood', '057-2334894', 'fred.evanswood@philipmorris.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('149245218', 'Dabney', 'Perlman', '053-2572072', 'dabney.p@sprint.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('781417795', 'Danny', 'Marley', '050-1639938', 'dmarley@teoco.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('392278651', 'Thomas', 'Duschel', '059-6208075', 'thomas.duschel@balchem.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('911142000', 'Gene', 'Fehr', '054-6942593', 'gfehr@onstaff.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('464871486', 'Howard', 'Tinsley', '053-1901293', 'howard@ssci.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('918067269', 'Edwin', 'Forrest', '051-5313034', 'e.forrest@stmaryland.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('531109735', 'Stephen', 'Heron', '057-3302820', 'stephen.h@outsourcegroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('780840485', 'Sylvester', 'Silverman', '059-3672436', 'ssilverman@neogen.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('066516192', 'Boyd', 'Lillard', '056-3831699', 'b.lillard@allegiantbancorp.uk');
commit;
prompt 800 records committed...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('983815148', 'Guy', 'Crouse', '056-4587507', 'guy.crouse@innovativelighting.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('035149160', 'Aidan', 'Peterson', '054-1414840', 'aidan.peterson@capstone.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('617082575', 'Alana', 'Wine', '056-2197833', 'alana.w@newhorizons.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('561919139', 'Hector', 'Willis', '052-2501043', 'hector.willis@usdairyproducers.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('810869456', 'Donal', 'Duncan', '058-8765926', 'donal.duncan@hotmail.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('931597295', 'Franz', 'Ellis', '056-9393126', 'franz@gillani.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('669562483', 'Edie', 'Steiger', '052-3827960', 'e.steiger@monitronicsinternational.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('367985568', 'Mira', 'Isaacs', '055-5175571', 'mira@tlsservicebureau.ar');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('628942053', 'Hector', 'Miles', '053-5821770', 'hector.miles@bis.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('963595336', 'Jarvis', 'Trejo', '053-2518459', 'j.trejo@esteelauder.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('315098238', 'Taylor', 'Thorton', '055-2659937', 'taylor.t@alogent.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('348877136', 'Denny', 'O''Connor', '055-9607400', 'denny.oconnor@ach.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('938313995', 'Charles', 'Sledge', '056-1571311', 'csledge@naturescure.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('645106048', 'Mindy', 'Lorenz', '056-7470951', 'mindy.lorenz@invisioncom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('651528067', 'Bryan', 'O''Neal', '050-6265573', 'b.oneal@shot.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('391006246', 'Crystal', 'Marin', '051-2112626', 'crystal.m@whitewave.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('265747418', 'Greg', 'Harary', '059-8253601', 'greg.h@simplycertificates.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('951365336', 'Lari', 'Reid', '058-1934928', 'lari@tmt.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('275004714', 'Doug', 'McCabe', '050-2378919', 'doug.mccabe@clorox.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('498584448', 'Oded', 'Dzundza', '053-9423540', 'o.dzundza@biosite.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('609595932', 'Rodney', 'Zevon', '057-3120409', 'rzevon@mcdonalds.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('090094931', 'Norm', 'Peterson', '059-3574991', 'norm.peterson@horizonorganic.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('488229246', 'Stephen', 'Swayze', '055-1597543', 'stephens@dis.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('800071003', 'Temuera', 'McBride', '059-9422944', 'temuera.mcbride@ait.fi');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('295743432', 'Lesley', 'Rippy', '055-3391095', 'lesley.r@fetchlogistics.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('984268974', 'Giovanni', 'McConaughey', '054-3838503', 'gmcconaughey@saltgroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('746109991', 'Amy', 'Loeb', '056-4638766', 'amyl@meghasystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('971662190', 'Jimmie', 'Reeve', '058-1821851', 'jimmie.r@tracertechnologies.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('301487527', 'Tia', 'Griffiths', '059-8787651', 'tia.griffiths@allstar.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('513366861', 'Scott', 'Wright', '059-2731208', 'scott@trusecure.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('851304587', 'Rhea', 'Mitra', '052-2897150', 'rheam@staffforce.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('531653197', 'Manu', 'Weaving', '057-7684300', 'mweaving@mls.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('966420873', 'Carrie', 'Loeb', '055-1176329', 'carrie.loeb@teoco.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('963454489', 'Thin', 'Flatts', '057-6489332', 'thinf@career.za');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('092438204', 'Robin', 'Thornton', '051-2146016', 'robin.thornton@anheuserbusch.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('682871823', 'Steve', 'Coe', '059-8503296', 'scoe@kimberlyclark.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('932205429', 'Mia', 'Jessee', '058-8508816', 'm.jessee@dearbornbancorp.fi');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('177902350', 'Vanessa', 'Bugnon', '053-5108425', 'vanessa.bugnon@marsinc.si');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('381832555', 'Olga', 'Gayle', '050-5977605', 'olga.gayle@spd.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('688337870', 'Jena', 'Wiest', '050-7158630', 'jena.w@sensortechnologies.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('336288257', 'Belinda', 'Armatrading', '056-9606826', 'belinda.a@msdw.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('913835482', 'Jared', 'Palminteri', '052-7692963', 'jared.p@tlsservicebureau.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('657588520', 'Danny', 'Emmett', '052-7768935', 'danny.emmett@flavorx.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('681103413', 'Maggie', 'Moraz', '057-2975886', 'maggie@berkshirehathaway.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('615071390', 'Julie', 'Fox', '058-1761195', 'julie.fox@jollyenterprises.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('751858214', 'Miko', 'McDonald', '052-1884830', 'miko@datawarehouse.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('101017572', 'Gailard', 'Ranger', '059-9804393', 'gailardr@solipsys.za');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('699698977', 'Sophie', 'Goldwyn', '050-8550876', 'sophie.goldwyn@diamondtechnologies.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('709693209', 'Trick', 'Hutch', '055-6663392', 'trick.hutch@millersystems.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('972588444', 'Scarlett', 'Davidtz', '054-6318658', 'scarlett@bis.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('653774196', 'Clive', 'Carrere', '052-6875704', 'clive.carrere@kingston.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('480612577', 'Naomi', 'Mathis', '052-7343015', 'n.mathis@usgovernment.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('127097395', 'Desmond', 'Bridges', '052-4881017', 'desmond.bridges@eastmankodak.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('612825720', 'Charlton', 'Monk', '050-1561410', 'charlton.monk@staffone.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('932303014', 'Percy', 'Bailey', '052-6305250', 'percy.b@dynacqinternational.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('565714643', 'Brad', 'Uggams', '056-1871759', 'brad.uggams@nsd.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('680540698', 'Vienna', 'Wells', '052-1570898', 'viennaw@asapstaffing.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('795316567', 'Marty', 'Paige', '052-4197087', 'marty.paige@heartlab.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('077468421', 'Carrie-Anne', 'McCann', '058-4409180', 'carrieannem@fsffinancial.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('441162660', 'Bruce', 'Hawke', '056-4250431', 'bruce.hawke@north.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('254321097', 'Nathan', 'Wopat', '053-8320588', 'nathan.w@lemproducts.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('908341581', 'Dorry', 'Webb', '055-3177756', 'd.webb@sunstream.is');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('206148591', 'Noah', 'Browne', '051-6755558', 'noah.browne@verizon.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('176375614', 'Veruca', 'Woodward', '059-8503164', 'veruca.w@nlx.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('257484513', 'Jeffery', 'Brolin', '052-7350388', 'jeffery.brolin@banfeproducts.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('287066393', 'Maura', 'Cook', '052-4322814', 'mcook@ahl.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('674828556', 'Joanna', 'Perlman', '050-1610835', 'joanna@democracydata.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('800130878', 'Rosanna', 'Arkin', '055-1962081', 'r.arkin@nobrainerblindscom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('406827918', 'Blair', 'Cash', '052-8115389', 'blair.cash@ach.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('584978130', 'Julie', 'Heston', '057-5521179', 'jheston@ssi.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('335765816', 'Latin', 'Chao', '053-3523027', 'lchao@kellogg.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('301595276', 'Diane', 'Cruz', '052-2928687', 'diane.cruz@epiqsystems.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('638174593', 'Rufus', 'Osborne', '050-4509696', 'rufus@signalperfection.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('288606298', 'Maria', 'Beatty', '056-5829316', 'maria.beatty@virbac.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('718788104', 'Patti', 'Cartlidge', '050-6444302', 'patti.cartlidge@banfeproducts.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('393777727', 'Kim', 'Seagal', '058-9706786', 'kims@allegiantbancorp.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('477705419', 'Gina', 'Bloch', '057-7592259', 'ginab@knightsbridge.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('121923546', 'Wade', 'Dunaway', '055-1686683', 'wade@hospitalsolutions.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('241206486', 'Hookah', 'Holiday', '057-2640858', 'h.holiday@cmi.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('555151314', 'Merrill', 'Morse', '059-4778893', 'm.morse@newtoninteractive.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('494129418', 'Sheena', 'Day-Lewis', '052-8920879', 'sheena.daylewis@cmi.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('260510850', 'Davey', 'Isaacs', '052-1658343', 'davey.isaacs@mattel.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('472938570', 'Debbie', 'Kattan', '052-3600971', 'debbie.kattan@mindiq.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('066163526', 'Jody', 'Dunst', '051-7204208', 'jody.dunst@veritekinternational.si');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('950424090', 'Maxine', 'Cervine', '058-6347904', 'maxine.cervine@taycorfinancial.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('433092689', 'Tilda', 'Smith', '052-8686587', 'tilda.smith@americanland.ar');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('849628298', 'Carrie-Anne', 'Rhymes', '058-1782385', 'crhymes@glaxosmithkline.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('771616343', 'Dianne', 'Langella', '050-8491415', 'dianne.langella@northhighland.za');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('178689926', 'Steve', 'Vance', '052-1495742', 'steve.vance@kingland.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('188258885', 'Chad', 'Gallagher', '050-8688312', 'chad.gallagher@sandyspringbancorp.ht');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('916257408', 'Ali', 'Addy', '059-2929445', 'ali.addy@wyeth.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('402100119', 'Lindsey', 'Rickles', '050-3194508', 'lindsey@nlx.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('347276119', 'Bonnie', 'Stone', '058-5106192', 'bonnie.stone@cynergydata.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('990016787', 'Saul', 'Tempest', '058-6323288', 'saul.tempest@saksinc.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('468178034', 'Val', 'Feliciano', '051-5153525', 'val.feliciano@benecongroup.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('090465425', 'Mos', 'Chilton', '054-4521456', 'mos.chilton@proclarity.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('798705531', 'Chloe', 'Beckham', '055-5166177', 'chloe@sds.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('645919226', 'Wang', 'Langella', '059-8238492', 'wang.langella@prosum.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('185553927', 'Rhett', 'Rippy', '058-7559449', 'rhett.rippy@kellogg.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('285703464', 'Renee', 'Jones', '058-9258687', 'reneej@ciwservices.com');
commit;
prompt 900 records committed...
insert into PERSON (personid, firstname, lastname, phone, email)
values ('940005155', 'Mekhi', 'Uggams', '054-3294200', 'mekhi@gbas.in');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('631569671', 'Jeroen', 'Lemmon', '057-9883901', 'jeroenl@inzone.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('317113862', 'Debi', 'Fonda', '053-7507620', 'debi.fonda@dell.cz');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('417953406', 'Sam', 'Moriarty', '059-1638487', 'sam.m@aci.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('072820783', 'Nina', 'Woods', '056-3522846', 'ninaw@hiltonhotels.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('217140305', 'Brittany', 'Spacek', '051-1229710', 'brittanys@taycorfinancial.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('720106083', 'Edward', 'Curtis', '055-2689756', 'edward.curtis@sbc.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('398339044', 'Laurence', 'Wolf', '052-7154949', 'laurence@ipsadvisory.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('566197144', 'Celia', 'Sweeney', '057-5638571', 'c.sweeney@smartdrawcom.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('043493500', 'Denis', 'Costa', '057-9384231', 'denis.c@angieslist.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('651655951', 'Colin', 'Fogerty', '057-2609160', 'colin.fogerty@kitba.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('682262028', 'Pete', 'Hoskins', '058-2275558', 'pete.hoskins@ptg.no');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('754857377', 'Rebeka', 'Wakeling', '051-8358809', 'r.wakeling@staffforce.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('911294712', 'Anne', 'Stevenson', '052-5716525', 'anne.stevenson@accessus.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('850334182', 'Matt', 'McDowall', '051-9936600', 'matt.mcdowall@pioneermortgage.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('252004653', 'Willie', 'Mohr', '051-8880020', 'wmohr@kimberlyclark.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('077454375', 'Morgan', 'Oldman', '054-9406576', 'morgan@computersource.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('738373379', 'Rick', 'Spall', '050-7725389', 'rick@surmodics.hu');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('131671047', 'Henry', 'Brooks', '051-5153631', 'henry.brooks@sfb.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('385867106', 'Spike', 'Idle', '059-4751168', 'spike.idle@marlabs.ar');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('913647996', 'Jerry', 'Reid', '052-8413139', 'jreid@lfg.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('127352453', 'Vertical', 'Holeman', '052-9789170', 'v.holeman@yashtechnologies.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('582783692', 'Rade', 'Mahoney', '053-7364624', 'rade.mahoney@newmedia.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('920761389', 'Quentin', 'Finn', '056-2984039', 'q.finn@faef.ar');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('942977640', 'Mitchell', 'Giannini', '056-7858477', 'mitchell.giannini@bayer.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('392317062', 'Mykelti', 'LaSalle', '050-4195304', 'mykelti.lasalle@baesch.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('223308022', 'Dustin', 'DiFranco', '050-7495057', 'dustind@hewlettpackard.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('913760353', 'Joshua', 'Phoenix', '059-1479057', 'joshua.p@usgovernment.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('555012645', 'Angela', 'Wainwright', '055-2378962', 'a.wainwright@spinnakerexploration.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('808040986', 'Celia', 'Blades', '053-1107377', 'celia.b@mls.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('683755588', 'Christian', 'Dushku', '053-2599482', 'christian@adeasolutions.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('619112383', 'Charlton', 'Kinski', '052-4362870', 'c.kinski@ams.es');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('186164668', 'Brendan', 'Chappelle', '055-7115612', 'brendan.chappelle@americanvanguard.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('497982843', 'Suzy', 'Wiest', '058-2923555', 'suzy@angieslist.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('259019811', 'Paula', 'Phoenix', '052-4353313', 'paula.phoenix@epamsystems.cr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('231489537', 'Tea', 'Gore', '054-1512845', 'tea.gore@trc.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('311246059', 'Robin', 'Esposito', '053-5250292', 'robin@coridiantechnologies.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('526540050', 'Garry', 'Channing', '053-9388498', 'garry@quicksilverresources.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('091897843', 'Nina', 'Winans', '051-5428357', 'nina.winans@ataservices.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('682734747', 'Chad', 'Secada', '058-4788804', 'c.secada@stonebrewing.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('769478376', 'Vondie', 'Eder', '054-3839117', 'vondie@aoltimewarner.no');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('149350162', 'Garland', 'Crimson', '053-3506188', 'gcrimson@nike.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('939973048', 'Lois', 'Aglukark', '056-3394851', 'lois.aglukark@glaxosmithkline.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('126047774', 'Kathy', 'Dafoe', '056-2459898', 'kathy.d@operationaltechnologies.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('106927049', 'Sona', 'Reiner', '059-6110302', 'sonar@dynacqinternational.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('696456011', 'Loren', 'Curfman', '050-9544354', 'loren.curfman@ogi.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('960313673', 'Michelle', 'Bridges', '054-1331571', 'michelle.b@egroup.dk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('194467431', 'Isaiah', 'Rippy', '056-3612628', 'isaiah.r@jollyenterprises.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('880198841', 'Peter', 'Bachman', '054-1267965', 'peter.bachman@mastercardinternational.nl');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('622332281', 'Curtis', 'Gleeson', '051-9555443', 'curtis.gleeson@wlt.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('356674765', 'Kyra', 'Penn', '056-8674506', 'kyra.penn@kingland.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('866701211', 'Tia', 'Woodard', '059-4785425', 'tia@its.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('856216050', 'Javon', 'Arthur', '051-7559358', 'javon.arthur@socketinternet.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('007903191', 'Renee', 'Kudrow', '056-6367184', 'reneek@astute.br');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('847593760', 'Devon', 'Rossellini', '054-3506658', 'devon.rossellini@johnkeeler.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('772907524', 'Scott', 'Cole', '059-2389669', 'scott.cole@totalentertainment.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('346411238', 'Lari', 'Coyote', '058-5623514', 'lari.c@dynacqinternational.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('483905679', 'Jeff', 'Kingsley', '051-3857722', 'jeff.kingsley@aventis.ch');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('141796209', 'Maxine', 'Paige', '054-6829654', 'maxine.paige@mse.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('524440107', 'Quentin', 'Benet', '051-2689140', 'quentinb@mss.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('499876095', 'Wallace', 'Dzundza', '057-1701321', 'wallace@ecopy.uk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('245422235', 'Clay', 'Pleasure', '057-1417894', 'clay@processplus.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('604788032', 'Judi', 'Oakenfold', '056-1895521', 'judi.o@signalperfection.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('416657553', 'Marlon', 'Gyllenhaal', '051-5539465', 'marlon.gyllenhaal@hotmail.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('146137062', 'Coley', 'Craven', '059-8734332', 'ccraven@bigyanksports.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('705853043', 'Carla', 'Rossellini', '055-7559404', 'carla.rossellini@pepsico.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('348351561', 'Paula', 'Van Shelton', '054-8862453', 'paula@bps.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('864371528', 'Paula', 'McGinley', '052-9179138', 'paula.mcginley@usenergyservices.jp');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('828869477', 'Sona', 'Cruise', '055-5670717', 'sona.cruise@activeservices.lk');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('413075709', 'Claude', 'LaSalle', '059-6605240', 'claude.lasalle@wav.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('226935711', 'Jim', 'DeVita', '054-6618601', 'jim.devita@ris.be');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('853341811', 'Rodney', 'Dushku', '053-1505824', 'r.dushku@totalentertainment.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('774597047', 'Albert', 'Stamp', '055-2489115', 'albert.stamp@ipsadvisory.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('789950829', 'Geoffrey', 'Rhames', '059-2213075', 'geoffrey@smg.tw');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('311690756', 'Ricky', 'Visnjic', '050-5129655', 'ricky.v@kelmooreinvestment.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('304620961', 'Jodie', 'Bates', '056-4796739', 'jodie.bates@news.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('283210310', 'Ray', 'Evanswood', '055-3403365', 'revanswood@mindiq.fr');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('454626264', 'Breckin', 'Hunter', '051-8593057', 'breckin@trm.it');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('833822576', 'Shawn', 'Mahoney', '059-3565970', 'shawnm@pra.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('120287546', 'Will', 'McCormack', '052-5563086', 'will.mccormack@unica.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('793092711', 'Percy', 'Mellencamp', '059-5135474', 'percym@eagleone.se');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('899786232', 'France', 'Cantrell', '055-1156653', 'france.cantrell@sht.ca');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('059968768', 'Kelli', 'Spine', '054-4753419', 'kellis@yes.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('519792429', 'Christopher', 'Hersh', '050-3730745', 'christopherh@fns.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('332572816', 'Julianna', 'Levin', '059-2884614', 'julianna.levin@dcgroup.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('056357044', 'Bill', 'Diaz', '057-1584734', 'bill.diaz@jewettcameron.at');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('032555609', 'Tori', 'Suvari', '058-1919050', 'tori.s@refinery.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('218594766', 'Sean', 'Holm', '051-7424453', 's.holm@pis.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('650889844', 'Julie', 'Fierstein', '052-1899457', 'julie.fierstein@bioanalytical.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('748558840', 'First', 'Foster', '057-1939137', 'first@stonebrewing.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('192192535', 'Patty', 'Carradine', '053-7591481', 'patty.carradine@philipmorris.tw');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('688973370', 'Dom', 'Duchovny', '055-4587119', 'dom.d@mag.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('323335851', 'Miles', 'Latifah', '051-8839184', 'miles.latifah@faef.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('563934878', 'Fionnula', 'Reid', '051-5796837', 'fionnula.reid@americanhealthways.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('619459411', 'Franz', 'Lauper', '054-9224339', 'franz.lauper@timevision.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('461518573', 'Vonda', 'Cox', '055-1910897', 'vonda.cox@gagwear.za');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('798274104', 'Keith', 'Day', '052-3200601', 'keith.day@ogiointernational.au');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('928264310', 'Rose', 'Pullman', '053-3828820', 'rose.pullman@americanpan.de');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('621314773', 'Bernie', 'Pepper', '058-2551369', 'bernie.pepper@privatebancorp.com');
insert into PERSON (personid, firstname, lastname, phone, email)
values ('541714008', 'Marisa', 'Smith', '053-5143599', 'marisa.smith@kellogg.com');
commit;
prompt 1000 records loaded
prompt Loading CLIENT...
insert into CLIENT (clientid, active, maxbooks)
values ('828869477', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('418542865', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('391486802', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('487301584', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('653774196', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('963083303', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('905167354', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('888279161', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('188284365', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('129715075', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('191792029', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('740708570', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('526829293', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('367985568', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('878919173', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('978514891', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('871507308', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('499600585', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('353506388', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('604788032', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('520422787', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('266091930', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('414863719', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('169511260', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('569056506', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('939973048', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('418527819', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('682014481', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('887892305', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('247748869', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('582783692', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('273149266', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('886314861', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('468178034', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('602220915', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('162991219', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('327179287', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('128447737', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('680606541', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('664042086', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('141519886', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('831042091', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('029695329', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('137607044', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('563934878', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('874752399', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('398339044', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('244652438', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('922607270', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('448707100', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('984268974', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('830383231', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('574465011', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('731223212', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('625324658', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('494302245', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('983815148', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('585575998', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('240939313', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('851304587', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('754857377', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('261535229', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('070289159', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('180191326', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('453202055', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('137842810', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('265747418', 1, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('255474214', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('441162660', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('968200663', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('622978701', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('367706464', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('334283784', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('812794163', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('555012645', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('464050791', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('935992565', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('221505949', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('012259052', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('376247399', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('239960682', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('350849342', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('915923130', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('680540698', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('480612577', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('974383847', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('374339845', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('313589600', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('545636009', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('310404144', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('846104984', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('659562823', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('789950829', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('093818015', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('054807164', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('614784421', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('348877136', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('901820276', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('644249525', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('688337870', 0, 11);
commit;
prompt 100 records committed...
insert into CLIENT (clientid, active, maxbooks)
values ('069849743', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('636976970', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('039153067', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('332572816', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('418350339', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('097482024', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('735902946', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('185553927', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('511449615', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('659345030', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('136473730', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('983955201', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('559859523', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('684705736', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('454626264', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('766927859', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('770572515', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('782812737', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('241206486', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('826540393', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('711123768', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('765668671', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('668963614', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('677905366', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('915372180', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('647332571', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('160685460', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('784609914', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('438188432', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('170713739', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('294428713', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('645106048', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('897822661', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('063528944', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('957911531', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('446920114', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('617082575', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('617184197', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('847250676', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('271730213', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('077468421', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('113036851', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('675892635', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('436366104', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('402909496', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('356235416', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('783918714', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('560046205', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('638353369', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('737691770', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('235099187', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('571326720', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('494129418', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('094482935', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('811048828', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('958525594', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('022601726', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('214713146', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('141796209', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('542900586', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('914006622', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('849628298', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('507745420', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('078588875', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('304620961', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('913647996', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('911294712', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('001709568', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('531653197', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('301487527', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('267137605', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('327375753', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('423593942', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('613155757', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('666467223', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('688569966', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('567000152', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('322295223', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('126770208', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('176375614', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('530118953', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('699698977', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('800071003', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('801792400', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('745504002', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('917553275', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('518249933', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('409480749', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('566478959', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('738373379', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('776528409', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('718788104', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('527971188', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('398898388', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('274585073', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('050573245', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('342956097', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('309357389', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('915701674', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('127097395', 1, 9);
commit;
prompt 200 records committed...
insert into CLIENT (clientid, active, maxbooks)
values ('708027100', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('805127954', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('917208879', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('195785327', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('651528067', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('676285276', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('305084973', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('898194084', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('860441514', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('250712526', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('136074808', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('086072867', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('749084891', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('806629624', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('562094648', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('669562483', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('329948220', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('034411863', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('053078260', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('226545801', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('029124580', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('498584448', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('081383228', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('218117404', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('697531067', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('961457858', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('130330261', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('488229246', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('456794713', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('801462183', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('175188743', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('386518366', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('723375847', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('783055575', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('783546244', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('272137266', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('287375665', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('639941357', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('989981369', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('682262028', 1, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('029466664', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('175978110', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('918067269', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('240775340', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('085170682', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('455567704', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('973642055', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('350227847', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('413075709', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('141376208', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('938313995', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('499064100', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('090465425', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('524440107', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('031510193', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('087859207', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('432425942', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('725276037', 1, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('000020688', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('520822644', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('919166928', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('758867042', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('553241085', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('187429687', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('851278188', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('432090220', 1, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('054248733', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('809030912', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('230944652', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('696456011', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('013427448', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('164868085', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('577720618', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('515228364', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('989570315', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('028369330', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('035748677', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('149245218', 1, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('920761389', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('061215635', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('821726553', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('819874679', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('896401490', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('396904603', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('214335504', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('826605920', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('046657439', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('159620386', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('066516192', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('391006246', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('751666263', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('958886144', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('140122154', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('115243063', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('811052060', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('555398022', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('523453408', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('275681892', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('803660894', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('348351561', 0, 5);
commit;
prompt 300 records committed...
insert into CLIENT (clientid, active, maxbooks)
values ('519792429', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('645919226', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('681877198', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('266684771', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('485100893', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('843169084', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('697846160', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('311514630', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('992475501', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('186328775', 1, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('342761949', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('064598882', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('107455196', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('932959604', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('379348654', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('664089285', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('490830032', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('938101191', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('602505536', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('873355323', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('797864475', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('591957858', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('847593760', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('163506853', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('142861817', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('025953504', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('238684624', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('338766535', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('766598824', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('874481938', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('377017130', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('066613546', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('007903191', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('913760353', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('322854435', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('793092711', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('855053927', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('043939492', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('528625739', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('033035228', 1, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('311690756', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('856216050', 1, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('145366143', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('000677810', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('493045396', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('107093007', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('260510850', 0, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('290488254', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('043493500', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('116286471', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('949755377', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('934564949', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('082415344', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('161677298', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('998214636', 1, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('972588444', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('092438204', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('735540984', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('252004653', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('432884692', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('055249826', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('158263429', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('840998924', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('878867388', 0, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('053166731', 0, 9);
insert into CLIENT (clientid, active, maxbooks)
values ('526716833', 1, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('264847178', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('420027444', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('045601319', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('891562139', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('820807804', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('216475555', 1, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('121923546', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('978612834', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('464019730', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('652120441', 1, 7);
insert into CLIENT (clientid, active, maxbooks)
values ('155490931', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('332533380', 0, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('417953406', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('280673575', 0, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('391352233', 0, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('136019878', 1, 4);
insert into CLIENT (clientid, active, maxbooks)
values ('739670228', 1, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('770600157', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('696182052', 1, 6);
insert into CLIENT (clientid, active, maxbooks)
values ('688973370', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('078062073', 1, 1);
insert into CLIENT (clientid, active, maxbooks)
values ('446332100', 0, 11);
insert into CLIENT (clientid, active, maxbooks)
values ('701389269', 0, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('441785402', 0, 3);
insert into CLIENT (clientid, active, maxbooks)
values ('141166296', 0, 10);
insert into CLIENT (clientid, active, maxbooks)
values ('180966239', 0, 5);
insert into CLIENT (clientid, active, maxbooks)
values ('485283160', 0, 12);
insert into CLIENT (clientid, active, maxbooks)
values ('594588133', 1, 2);
insert into CLIENT (clientid, active, maxbooks)
values ('035510904', 1, 8);
insert into CLIENT (clientid, active, maxbooks)
values ('275457970', 1, 11);
commit;
prompt 396 records loaded
prompt Loading LIBRARIAN...
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('087859207', to_date('30-07-2009', 'dd-mm-yyyy'), 'Denis328', '1NHW78EWSj');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('127352453', to_date('09-06-2008', 'dd-mm-yyyy'), 'Eddie663', '3aKWgNSZ4l');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('106927049', to_date('12-03-2000', 'dd-mm-yyyy'), 'Wesley787', '44lqhd0jAV');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('666153997', to_date('28-03-2007', 'dd-mm-yyyy'), 'Ethan112', 'oi4rZi7ZC8');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('086419816', to_date('23-12-2012', 'dd-mm-yyyy'), 'Dorry998', 'yQfc2EjT1m');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('323335851', to_date('10-03-2021', 'dd-mm-yyyy'), 'Raymond782', 'G0WVlHAs7s');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('507560616', to_date('12-04-2018', 'dd-mm-yyyy'), 'Natascha516', 'cSQl18mVg8');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('376926882', to_date('28-07-2011', 'dd-mm-yyyy'), 'Jonathan857', 'RHOfqB4MNy');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('120938383', to_date('16-07-2015', 'dd-mm-yyyy'), 'Tramaine483', 'ktFRX8lEbr');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('596690563', to_date('10-05-2008', 'dd-mm-yyyy'), 'Rich595', '9LxcG5HEpY');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('274453753', to_date('05-12-2014', 'dd-mm-yyyy'), 'Linda747', 'ekUTw3QSVR');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('044973672', to_date('06-02-2004', 'dd-mm-yyyy'), 'Lupe578', 'kk65h4u9b9');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('113439011', to_date('02-08-2001', 'dd-mm-yyyy'), 'Amy112', '5yeysKBhuT');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('315680603', to_date('23-05-2013', 'dd-mm-yyyy'), 'Elle321', 'pXIeuCtMUL');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('938101191', to_date('08-08-2015', 'dd-mm-yyyy'), 'Lydia491', '1k7IGRUFzU');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('684705736', to_date('14-10-2019', 'dd-mm-yyyy'), 'Lance982', '0H4MuH57za');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('680540698', to_date('02-06-2017', 'dd-mm-yyyy'), 'Lee192', 'X04FBlBsaL');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('367775460', to_date('14-04-2021', 'dd-mm-yyyy'), 'Bruce855', '27kgGM0PKt');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('299064885', to_date('21-11-2002', 'dd-mm-yyyy'), 'Olga853', 'ZR4nNKWvfb');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('054248733', to_date('21-04-2000', 'dd-mm-yyyy'), 'Lydia536', 'guXUDApzn7');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('312108840', to_date('04-02-2023', 'dd-mm-yyyy'), 'Angie665', 'OGqR329zO4');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('236059370', to_date('09-08-2009', 'dd-mm-yyyy'), 'Victoria635', 'aKf7RhuWh0');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('632046362', to_date('24-01-2000', 'dd-mm-yyyy'), 'Robbie999', 'EOvpdUyIxo');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('914751680', to_date('26-12-2008', 'dd-mm-yyyy'), 'Oded424', '4C1JqpGrpO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('894862066', to_date('20-01-2001', 'dd-mm-yyyy'), 'Olympia324', 'A6a3HBntax');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('691006719', to_date('13-05-2015', 'dd-mm-yyyy'), 'Lisa657', 'vcyjCNI7gV');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('553241085', to_date('21-08-2015', 'dd-mm-yyyy'), 'Nancy189', 'jdd2shvde9');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('266091930', to_date('26-09-2008', 'dd-mm-yyyy'), 'Matt543', 'caJSIH7Ynz');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('500068415', to_date('08-03-2014', 'dd-mm-yyyy'), 'Lucy712', 'HpQlDMpbii');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('469016250', to_date('26-11-2007', 'dd-mm-yyyy'), 'Ricky641', 'MtzrfRTrlg');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('703815502', to_date('03-11-2013', 'dd-mm-yyyy'), 'Miko787', 'H8JIFMBE3Z');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('280673575', to_date('11-10-2007', 'dd-mm-yyyy'), 'Tanya597', 'XbcofNtSdW');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('141519886', to_date('12-03-2011', 'dd-mm-yyyy'), 'Jeffery792', 'wqKs6DfTw9');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('625529602', to_date('04-08-2008', 'dd-mm-yyyy'), 'Dick241', 'plcvQeKQdC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('186328775', to_date('02-04-2007', 'dd-mm-yyyy'), 'Richie691', 'TaSBZ60YJQ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('891562139', to_date('23-02-2015', 'dd-mm-yyyy'), 'Alessandro335', 'NSVJ22DtsK');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('631487255', to_date('24-05-2010', 'dd-mm-yyyy'), 'Ben866', 'qhzbYfb6GM');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('137607044', to_date('26-10-2010', 'dd-mm-yyyy'), 'Chet542', '9KmJku8GmW');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('283210310', to_date('15-02-2009', 'dd-mm-yyyy'), 'Celia469', 'x4IZFAsvIg');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('819819701', to_date('29-04-2000', 'dd-mm-yyyy'), 'Derek234', 'NQZYM2zoai');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('285703464', to_date('17-06-2016', 'dd-mm-yyyy'), 'Dabney285', 'M7udcNhpCx');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('560046205', to_date('02-03-2023', 'dd-mm-yyyy'), 'Chazz965', '9d5G5vQJlz');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('346411238', to_date('21-05-2009', 'dd-mm-yyyy'), 'Wayman773', 'nFDkqSthLt');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('288606298', to_date('05-02-2004', 'dd-mm-yyyy'), 'Rory312', 'YLfrRzwDyP');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('177902350', to_date('21-01-2020', 'dd-mm-yyyy'), 'Jody277', 'KY7XGxVY14');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('141376208', to_date('06-11-2021', 'dd-mm-yyyy'), 'Richie893', '5uNa4MZYiT');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('170713739', to_date('15-08-2015', 'dd-mm-yyyy'), 'Dylan326', 'N6MOL44wUR');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('740708570', to_date('16-11-2019', 'dd-mm-yyyy'), 'Merrilee435', 'mvOZglc0pT');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('900649914', to_date('08-09-2011', 'dd-mm-yyyy'), 'Beth324', 'UhHdT4rXSv');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('837162122', to_date('06-12-2015', 'dd-mm-yyyy'), 'Kirk862', 'lySA3gkV43');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('776528409', to_date('31-10-2010', 'dd-mm-yyyy'), 'Neil465', 'IMTaGB99wa');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('310404144', to_date('21-03-2019', 'dd-mm-yyyy'), 'Jesse346', 'wCa3K8Xi6Y');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('711309756', to_date('03-08-2003', 'dd-mm-yyyy'), 'Devon421', '6lkzKAq5zV');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('578516249', to_date('21-01-2007', 'dd-mm-yyyy'), 'Carlos133', '76mqNW502m');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('805127954', to_date('24-10-2008', 'dd-mm-yyyy'), 'Fionnula565', 'LUuXgzIluK');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('272137266', to_date('04-04-2012', 'dd-mm-yyyy'), 'Tilda186', 'sgtIbAZZlb');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('154465176', to_date('26-12-2011', 'dd-mm-yyyy'), 'Jerry897', 'j6zV9AdUaK');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('694117241', to_date('05-05-2009', 'dd-mm-yyyy'), 'Rawlins487', 'drmHeVcrVA');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('402100119', to_date('28-03-2001', 'dd-mm-yyyy'), 'Bette597', 'LXctE1h8vW');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('851278188', to_date('16-09-2021', 'dd-mm-yyyy'), 'Lynette971', 'rhoOr5k35x');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('455567704', to_date('07-01-2001', 'dd-mm-yyyy'), 'Allison144', 'jyjGM3vyZN');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('077055177', to_date('14-05-2009', 'dd-mm-yyyy'), 'Max338', 'K2ELcnBJAl');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('275004714', to_date('05-05-2014', 'dd-mm-yyyy'), 'Bobby142', 'rYWuPr8Jnt');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('610867226', to_date('21-12-2000', 'dd-mm-yyyy'), 'Deborah447', 'JLWqaW9tUu');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('659345030', to_date('16-11-2016', 'dd-mm-yyyy'), 'Chris578', '3QHIY7hAeq');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('432090220', to_date('29-09-2022', 'dd-mm-yyyy'), 'Mindy853', 'JYfgyHlABY');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('165906299', to_date('08-02-2004', 'dd-mm-yyyy'), 'Harvey639', 'CYQ17wuJXC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('420027444', to_date('12-04-2016', 'dd-mm-yyyy'), 'Elias775', 'qLbwDk3qIQ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('901820276', to_date('14-05-2017', 'dd-mm-yyyy'), 'Seann425', 'bC7QMEQiI2');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('701389269', to_date('21-05-2002', 'dd-mm-yyyy'), 'Norm891', '9GqilPkpBd');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('290571145', to_date('25-10-2002', 'dd-mm-yyyy'), 'Daryle561', 'tKeb12k750');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('983815148', to_date('05-04-2020', 'dd-mm-yyyy'), 'Phoebe611', 'CWsmvLTmLa');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('751858214', to_date('28-11-2023', 'dd-mm-yyyy'), 'Armand492', 'wtMrwdK703');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('175375438', to_date('03-11-2022', 'dd-mm-yyyy'), 'Ramsey573', 'I3qjrzLg7U');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('066516192', to_date('06-10-2003', 'dd-mm-yyyy'), 'Patti173', '59e0uFYTxW');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('811052060', to_date('26-01-2016', 'dd-mm-yyyy'), 'Lorraine471', 'kHI30RiBis');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('911294712', to_date('21-07-2023', 'dd-mm-yyyy'), 'Juan561', '2UY7PZONTj');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('682014481', to_date('08-09-2015', 'dd-mm-yyyy'), 'Sheryl486', 'ebvEHwxaLU');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('790283405', to_date('16-10-2006', 'dd-mm-yyyy'), 'Jann997', 'W803ZAQwI5');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('086072867', to_date('18-04-2014', 'dd-mm-yyyy'), 'Liev428', 'dMibKvGBWG');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('107093007', to_date('29-09-2007', 'dd-mm-yyyy'), 'Mindy873', 'Uy3HMcvlOF');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('696456011', to_date('25-08-2014', 'dd-mm-yyyy'), 'Gena671', 'CRgPEV43ws');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('172290645', to_date('15-11-2005', 'dd-mm-yyyy'), 'Kenneth157', 'lQOVL0DcUp');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('840162098', to_date('01-02-2007', 'dd-mm-yyyy'), 'Bret464', 'isMxqFw01o');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('168438555', to_date('22-09-2002', 'dd-mm-yyyy'), 'Karen971', 'mjmEx3qxp0');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('191188653', to_date('23-08-2019', 'dd-mm-yyyy'), 'Ryan261', '4rZAFjKzfy');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('171756391', to_date('11-01-2014', 'dd-mm-yyyy'), 'Lenny468', 'sqNbFLCIxC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('485283160', to_date('29-03-2004', 'dd-mm-yyyy'), 'Sandra377', 'pVDl4z3pyI');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('348723377', to_date('24-04-2001', 'dd-mm-yyyy'), 'Delbert815', 'P59nVHRkPe');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('687142530', to_date('27-09-2000', 'dd-mm-yyyy'), 'Jodie163', '9Fu3EjxWIs');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('347276119', to_date('08-11-2012', 'dd-mm-yyyy'), 'Philip821', '38xKtHBld2');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('682262028', to_date('25-02-2012', 'dd-mm-yyyy'), 'Rose617', 'HlBBGs3evI');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('685213103', to_date('28-06-2022', 'dd-mm-yyyy'), 'Rosanne572', 'AyTX7ksnJs');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('745504002', to_date('29-09-2003', 'dd-mm-yyyy'), 'Parker569', 'NRtTp3OiCE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('316852675', to_date('27-05-2016', 'dd-mm-yyyy'), 'Bobbi799', '3P9Qu09xc3');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('130969218', to_date('14-10-2003', 'dd-mm-yyyy'), 'Neneh266', 'sFnFSfvMSY');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('799881575', to_date('11-12-2020', 'dd-mm-yyyy'), 'Geraldine295', 'WM0EdFU2S9');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('424102835', to_date('07-03-2004', 'dd-mm-yyyy'), 'Alicia395', 'DZDPTQx2yf');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('336288257', to_date('03-03-2006', 'dd-mm-yyyy'), 'Walter439', 'P87z78S9N8');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('860441514', to_date('10-06-2013', 'dd-mm-yyyy'), 'Harrison517', 'SyBYYTeWt8');
commit;
prompt 100 records committed...
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('086121419', to_date('16-11-2002', 'dd-mm-yyyy'), 'Shannyn384', 'qmG43uQ8Tq');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('526829293', to_date('26-02-2023', 'dd-mm-yyyy'), 'Jack271', '3aZHYR4JGP');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('217140305', to_date('09-07-2019', 'dd-mm-yyyy'), 'Rosie423', '3mybFdW8be');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('708927780', to_date('25-04-2002', 'dd-mm-yyyy'), 'Emm361', 'XDzqpWaxA3');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('789947168', to_date('16-06-2002', 'dd-mm-yyyy'), 'Vienna955', 'LoxlyVnRx0');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('158263429', to_date('20-01-2015', 'dd-mm-yyyy'), 'France851', 'aTAzVitcV8');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('798705531', to_date('15-09-2013', 'dd-mm-yyyy'), 'Ricky784', 'ygPgcEQIp2');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('619112383', to_date('17-11-2012', 'dd-mm-yyyy'), 'Howie666', 'uFjC7QNoTT');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('251808841', to_date('31-12-2001', 'dd-mm-yyyy'), 'Dustin765', 'rak5n8K3Nv');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('619874595', to_date('03-10-2012', 'dd-mm-yyyy'), 'Franz811', 'pDP2RPm5NG');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('978612834', to_date('01-11-2023', 'dd-mm-yyyy'), 'Dan485', 'OjJRsAWBAZ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('235761739', to_date('23-09-2005', 'dd-mm-yyyy'), 'Walter819', 'Ro0chmkHim');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('798632254', to_date('06-01-2007', 'dd-mm-yyyy'), 'Sinead535', '3NOTikKcgr');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('527971188', to_date('13-08-2016', 'dd-mm-yyyy'), 'Bernard513', 'YU29vgteb5');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('379348654', to_date('10-06-2015', 'dd-mm-yyyy'), 'Giovanni156', '7gwok0fXpb');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('315275105', to_date('08-09-2012', 'dd-mm-yyyy'), 'Christine666', 'vUa5qLxVGQ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('541714008', to_date('08-06-2014', 'dd-mm-yyyy'), 'Randy942', 'OzxKAnq7zI');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('856216050', to_date('02-07-2014', 'dd-mm-yyyy'), 'Leslie774', '8ZDrugvOtE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('577720618', to_date('01-09-2006', 'dd-mm-yyyy'), 'Taye436', 'fOWYalYdzx');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('483905679', to_date('30-12-2011', 'dd-mm-yyyy'), 'Devon287', 'nhblV44qTb');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('141166296', to_date('28-10-2002', 'dd-mm-yyyy'), 'Denise948', 'pmPTqFoxcT');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('055509419', to_date('23-09-2002', 'dd-mm-yyyy'), 'Jason674', 'VEYXVXEerw');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('332572816', to_date('24-12-2006', 'dd-mm-yyyy'), 'Susan833', 'pezSkE3CkC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('517024610', to_date('18-06-2020', 'dd-mm-yyyy'), 'Moe954', 'WLe10RRm3x');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('591957858', to_date('30-10-2003', 'dd-mm-yyyy'), 'Pam615', 'HPdShhzsK1');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('090465425', to_date('18-09-2008', 'dd-mm-yyyy'), 'Joe971', 'X47hDF1Tdm');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('624567221', to_date('21-09-2004', 'dd-mm-yyyy'), 'Wes355', '444WurooPM');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('499584708', to_date('13-12-2018', 'dd-mm-yyyy'), 'Cloris534', 'qwPCnAQyeR');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('078588875', to_date('16-02-2021', 'dd-mm-yyyy'), 'Neve675', 'eBrhy9lleY');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('756952320', to_date('29-08-2008', 'dd-mm-yyyy'), 'Anthony393', 'xaiq5nTx2y');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('781417795', to_date('02-12-2000', 'dd-mm-yyyy'), 'Dylan989', '5JGwHYPzpg');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('348648244', to_date('05-10-2019', 'dd-mm-yyyy'), 'Lucy969', 'DORuWKSoyf');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('523070923', to_date('29-04-2002', 'dd-mm-yyyy'), 'Lauren496', 'RfYNRKGc6O');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('511449615', to_date('28-05-2021', 'dd-mm-yyyy'), 'Luke451', 'ndgNMDC1ki');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('555012645', to_date('03-08-2011', 'dd-mm-yyyy'), 'Terry168', 'cT6EetZqCF');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('317113862', to_date('15-03-2019', 'dd-mm-yyyy'), 'Albertina735', 'J5QsSeBCKx');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('909087863', to_date('13-04-2000', 'dd-mm-yyyy'), 'Illeana215', 'GAeUCSL6Ka');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('917553275', to_date('04-09-2007', 'dd-mm-yyyy'), 'Penelope117', 'X7hJ42eMQl');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('688973370', to_date('02-05-2006', 'dd-mm-yyyy'), 'Brothers924', 's1RG3Xi1aX');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('747387759', to_date('01-01-2014', 'dd-mm-yyyy'), 'Melanie837', '2gdGudD5Oh');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('136019878', to_date('06-09-2011', 'dd-mm-yyyy'), 'Kenny777', 'S7KE5vNkgX');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('059968768', to_date('10-10-2009', 'dd-mm-yyyy'), 'Colin472', 'wlxeYZGZrf');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('120287546', to_date('21-03-2007', 'dd-mm-yyyy'), 'Wally874', 'MD97zfy6aL');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('058725396', to_date('22-06-2016', 'dd-mm-yyyy'), 'Garth367', 'SPNDCrZa6n');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('913647996', to_date('11-01-2018', 'dd-mm-yyyy'), 'Larnelle587', 'Wx0t47E91S');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('319029281', to_date('17-09-2021', 'dd-mm-yyyy'), 'Samuel263', '5KByd0vBe4');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('783918714', to_date('19-07-2005', 'dd-mm-yyyy'), 'Elle674', 'AUkDcVDkcF');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('688569966', to_date('28-03-2001', 'dd-mm-yyyy'), 'Nancy381', 'mlQ6hu5L1E');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('555151314', to_date('30-07-2019', 'dd-mm-yyyy'), 'Brad875', '7sNMtOqFpz');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('311246059', to_date('29-08-2004', 'dd-mm-yyyy'), 'Art571', 'Z8cEt1YJ5i');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('128447737', to_date('26-11-2005', 'dd-mm-yyyy'), 'Ed324', 'no35gBHoah');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('424018298', to_date('14-02-2000', 'dd-mm-yyyy'), 'Albert864', 'ChSFS4cqfs');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('971662190', to_date('26-01-2001', 'dd-mm-yyyy'), 'Cathy175', 'je1i3x2fqk');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('551736818', to_date('24-02-2021', 'dd-mm-yyyy'), 'Marty347', 'e2kFQjNIhF');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('386768609', to_date('06-04-2004', 'dd-mm-yyyy'), 'Nigel654', 'cjChbNFqq2');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('774597047', to_date('12-10-2022', 'dd-mm-yyyy'), 'Judy159', '6MPTHvz2PZ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('240939313', to_date('02-09-2003', 'dd-mm-yyyy'), 'Pam839', 'pScx43rUlB');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('874752399', to_date('30-05-2015', 'dd-mm-yyyy'), 'Sonny246', 'UsySVDHWZh');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('032555609', to_date('23-02-2004', 'dd-mm-yyyy'), 'Amy488', 'tpCIlhjd87');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('142861817', to_date('02-06-2018', 'dd-mm-yyyy'), 'Gavin212', 'ugcoJBDdSC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('053166731', to_date('21-11-2006', 'dd-mm-yyyy'), 'Ice422', 'p667Hk5NkZ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('537520439', to_date('31-05-2005', 'dd-mm-yyyy'), 'Ricardo724', 'sF0iyC4Spx');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('216475555', to_date('03-10-2007', 'dd-mm-yyyy'), 'Hector497', 'by7FEBAqbN');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('549134893', to_date('28-08-2006', 'dd-mm-yyyy'), 'Seann728', 'JzZAwMaeQI');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('967478251', to_date('28-07-2010', 'dd-mm-yyyy'), 'Caroline117', 'Y4nOOfjkar');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('028369330', to_date('21-09-2011', 'dd-mm-yyyy'), 'Rachael274', 'VGU1nQ2Tn1');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('195198779', to_date('29-10-2002', 'dd-mm-yyyy'), 'Jennifer349', 'RzT2ea3LUn');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('945150294', to_date('29-04-2004', 'dd-mm-yyyy'), 'Ralph188', 'NHFV41wVxN');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('025815914', to_date('21-03-2007', 'dd-mm-yyyy'), 'Davy573', 'Jb1QBuQof2');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('146137062', to_date('10-07-2018', 'dd-mm-yyyy'), 'Corey824', 'uPyznmhfZJ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('966420873', to_date('21-09-2016', 'dd-mm-yyyy'), 'Jennifer556', 'SAqnaPTim9');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('608394597', to_date('10-03-2008', 'dd-mm-yyyy'), 'Jennifer931', 'wrFSCKArmh');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('584514179', to_date('17-07-2019', 'dd-mm-yyyy'), 'Ryan238', 'TFTDcyizvM');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('660975076', to_date('29-01-2017', 'dd-mm-yyyy'), 'Spencer322', 'm1Ujhtfeu7');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('257532494', to_date('30-10-2020', 'dd-mm-yyyy'), 'Sandra673', 'ayufXt0k8f');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('045601319', to_date('09-12-2023', 'dd-mm-yyyy'), 'Kenneth762', '7FqSvK5DCc');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('245422235', to_date('30-05-2009', 'dd-mm-yyyy'), 'Leelee952', 'SQwwmAgjJc');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('090094931', to_date('29-06-2015', 'dd-mm-yyyy'), 'Xander367', '2qF6cGnKlf');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('998214636', to_date('01-06-2006', 'dd-mm-yyyy'), 'Miles738', '5e8hvUeCIA');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('072820783', to_date('12-10-2010', 'dd-mm-yyyy'), 'Mae323', '24LzeyeHcC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('164868085', to_date('17-08-2016', 'dd-mm-yyyy'), 'Lance587', 'wcnOeHI2ni');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('338766535', to_date('01-07-2012', 'dd-mm-yyyy'), 'Ellen426', 'xAcE4V60gd');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('257490434', to_date('27-02-2004', 'dd-mm-yyyy'), 'Clint482', 'nH1KpcYfO8');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('938313995', to_date('28-12-2006', 'dd-mm-yyyy'), 'Liv176', '5HHn2X3zjn');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('821726553', to_date('30-01-2014', 'dd-mm-yyyy'), 'Debra219', 'sWecRMq9ak');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('874481938', to_date('02-12-2012', 'dd-mm-yyyy'), 'Oded568', '2XJSrVwGSy');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('295160825', to_date('23-02-2002', 'dd-mm-yyyy'), 'Vanessa425', 'lDIDby53lL');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('602220915', to_date('09-04-2008', 'dd-mm-yyyy'), 'Lea795', 't0RpyUiUQv');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('424762764', to_date('04-05-2003', 'dd-mm-yyyy'), 'Leslie986', '3jDNyLqt7r');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('631569671', to_date('26-11-2018', 'dd-mm-yyyy'), 'Rich752', 'J3wGpTsS1m');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('612825720', to_date('27-05-2016', 'dd-mm-yyyy'), 'Steve831', 'LftLbaJFsQ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('173956351', to_date('28-04-2023', 'dd-mm-yyyy'), 'Milla421', '7fzlqss2JR');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('644249525', to_date('25-09-2000', 'dd-mm-yyyy'), 'Famke232', 'ymWqhPdxxk');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('880659583', to_date('06-01-2006', 'dd-mm-yyyy'), 'Penelope611', '1dBfKHnF0i');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('017131401', to_date('01-12-2014', 'dd-mm-yyyy'), 'Daniel791', 'ZvvoJmnwVN');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('913835482', to_date('21-04-2011', 'dd-mm-yyyy'), 'Kimberly684', 'ZZx27g9Yvb');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('631512677', to_date('09-11-2003', 'dd-mm-yyyy'), 'Milla832', '5xezZJMkWJ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('327375753', to_date('30-06-2018', 'dd-mm-yyyy'), 'Carla741', 'h4WoCpy2od');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('393777727', to_date('07-10-2017', 'dd-mm-yyyy'), 'Hank668', 'wg4xlKMUx3');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('855053927', to_date('23-11-2014', 'dd-mm-yyyy'), 'Fiona873', 'kbqke9oMGj');
commit;
prompt 200 records committed...
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('479610161', to_date('10-07-2017', 'dd-mm-yyyy'), 'Micky886', 'tpH8KtMqaW');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('085479466', to_date('09-02-2020', 'dd-mm-yyyy'), 'Johnny754', 'QgfOlmljnI');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('934564949', to_date('24-08-2020', 'dd-mm-yyyy'), 'Junior231', '768lrjQ594');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('066163526', to_date('25-01-2013', 'dd-mm-yyyy'), 'Mint676', 'riWAuaOxnB');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('124207649', to_date('24-12-2003', 'dd-mm-yyyy'), 'Kelli586', '99Ju2HA3CX');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('131671047', to_date('11-01-2005', 'dd-mm-yyyy'), 'Luis645', 'W6dJc5nQZi');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('461518573', to_date('03-01-2001', 'dd-mm-yyyy'), 'Vern193', 'xaBSjhh9FC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('871507308', to_date('20-03-2015', 'dd-mm-yyyy'), 'LeVar535', 'K84rZXc5Gc');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('913760353', to_date('17-07-2004', 'dd-mm-yyyy'), 'Oro276', 'rxv9vqcPeo');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('279175065', to_date('09-03-2022', 'dd-mm-yyyy'), 'Laurence742', 'X8djauyTx7');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('094482935', to_date('19-05-2015', 'dd-mm-yyyy'), 'Graham526', 'anTWmF5OfX');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('214335504', to_date('20-06-2012', 'dd-mm-yyyy'), 'Chi462', 'rKtccpVjct');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('391830753', to_date('17-12-2017', 'dd-mm-yyyy'), 'Angelina773', 'HYXyYBlFS2');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('014082919', to_date('03-12-2004', 'dd-mm-yyyy'), 'Mel513', 'Ju95leOX52');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('376247399', to_date('19-01-2002', 'dd-mm-yyyy'), 'Stanley562', 'O1YTGTI968');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('028592641', to_date('22-05-2000', 'dd-mm-yyyy'), 'Jeffrey994', 'uSojf9u6R9');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('355658237', to_date('03-05-2014', 'dd-mm-yyyy'), 'James841', 'ulw1U1QRID');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('464019730', to_date('26-05-2011', 'dd-mm-yyyy'), 'Chubby222', 'WTh1JscnbL');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('559859523', to_date('09-04-2020', 'dd-mm-yyyy'), 'Natacha639', 'eIxTLwhLCe');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('928264310', to_date('25-10-2018', 'dd-mm-yyyy'), 'Chrissie576', 'OAcUltBcj8');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('257484513', to_date('26-10-2001', 'dd-mm-yyyy'), 'Nastassja263', 'V38vQKpXbK');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('250647449', to_date('25-04-2019', 'dd-mm-yyyy'), 'Olga789', '7bLhjjiOG3');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('846104984', to_date('27-12-2022', 'dd-mm-yyyy'), 'Katie227', '5MRa9Y6acb');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('226545801', to_date('24-07-2004', 'dd-mm-yyyy'), 'Keith898', 'YtvpVZTJZu');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('531653197', to_date('17-11-2022', 'dd-mm-yyyy'), 'Rutger446', 'w9BsTIEBwy');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('973642055', to_date('01-07-2004', 'dd-mm-yyyy'), 'Clarence974', '41so0JkogY');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('360641780', to_date('24-11-2008', 'dd-mm-yyyy'), 'Mel859', 'vOhgBUJLXx');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('831042091', to_date('11-08-2016', 'dd-mm-yyyy'), 'Isaac583', 'DyiWiWDCZB');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('113036851', to_date('31-07-2002', 'dd-mm-yyyy'), 'Kathy177', 'WeruJSWjQ2');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('566197144', to_date('12-03-2003', 'dd-mm-yyyy'), 'Mike137', '8pm2fAAsYq');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('249308151', to_date('15-05-2017', 'dd-mm-yyyy'), 'Viggo541', 'hkXGDW0uoy');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('942977640', to_date('29-12-2017', 'dd-mm-yyyy'), 'Vincent177', 'asKPFK6qkR');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('531109735', to_date('23-07-2013', 'dd-mm-yyyy'), 'Trace447', '5cB87JhKmO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('241206486', to_date('09-03-2024', 'dd-mm-yyyy'), 'Jose711', '5a7coRR6mk');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('126047774', to_date('09-02-2013', 'dd-mm-yyyy'), 'Norm778', 'BskCYFpaEd');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('252004653', to_date('27-10-2000', 'dd-mm-yyyy'), 'Arnold246', '7SWwQR9GQJ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('263852543', to_date('12-07-2023', 'dd-mm-yyyy'), 'Breckin822', 'sODPwvrQce');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('699698977', to_date('16-11-2003', 'dd-mm-yyyy'), 'Cameron246', '6ypMU5WmTO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('614782689', to_date('01-01-2011', 'dd-mm-yyyy'), 'Julio838', 'XuXPmrjFNI');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('329948220', to_date('14-08-2009', 'dd-mm-yyyy'), 'Cheryl322', 'OZchJz0a1M');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('981531119', to_date('18-09-2022', 'dd-mm-yyyy'), 'Willie842', 'u5QdlFp3lw');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('519792429', to_date('23-04-2002', 'dd-mm-yyyy'), 'Freddy913', 'gdFYQUVC42');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('718788104', to_date('29-06-2016', 'dd-mm-yyyy'), 'Etta315', '9YMOg07PzN');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('843169084', to_date('06-11-2022', 'dd-mm-yyyy'), 'Harry131', '3XqOQZTiVh');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('582783692', to_date('28-10-2006', 'dd-mm-yyyy'), 'Percy993', 'orbmUk3R6q');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('745672175', to_date('18-10-2022', 'dd-mm-yyyy'), 'Pierce528', '0YGT5ysq53');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('888279161', to_date('29-02-2016', 'dd-mm-yyyy'), 'Giovanni431', 'oY9kHnZr53');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('370469772', to_date('12-05-2010', 'dd-mm-yyyy'), 'Kenny589', 'PwAuK5CnTJ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('377113286', to_date('23-09-2001', 'dd-mm-yyyy'), 'Gran476', 'XvxeC3PSE4');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('886474743', to_date('29-08-2002', 'dd-mm-yyyy'), 'Cheryl528', 'Vx4Kqbufzm');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('129715075', to_date('28-01-2021', 'dd-mm-yyyy'), 'Maury813', '2epSti1CnS');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('697846160', to_date('02-01-2016', 'dd-mm-yyyy'), 'Lauren874', '0UIxVWDNHx');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('720106083', to_date('27-03-2003', 'dd-mm-yyyy'), 'Freddie536', 'xEiuiZ42Uy');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('972588444', to_date('25-05-2023', 'dd-mm-yyyy'), 'Joanna426', 'U3XEt2A8DE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('771463068', to_date('04-09-2012', 'dd-mm-yyyy'), 'Andie563', 'jkJQAs5WXe');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('229940397', to_date('23-03-2014', 'dd-mm-yyyy'), 'Bernard116', 'oveDp0IYCY');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('611574934', to_date('15-03-2000', 'dd-mm-yyyy'), 'Anjelica157', 'DC7GqY7p4t');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('853341811', to_date('12-03-2010', 'dd-mm-yyyy'), 'Desmond923', 'GNEpDyfpYM');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('878867388', to_date('03-12-2021', 'dd-mm-yyyy'), 'Dwight549', 'aaMUVFkf5c');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('658307215', to_date('29-08-2016', 'dd-mm-yyyy'), 'Jann386', 'VZfo99riTV');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('273888222', to_date('30-08-2018', 'dd-mm-yyyy'), 'Carol748', 'vkwZUlei0O');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('361560323', to_date('04-10-2000', 'dd-mm-yyyy'), 'Victoria232', 'zpNycebGGe');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('418345089', to_date('28-02-2024', 'dd-mm-yyyy'), 'Rhea345', 'GGai1NeHOV');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('188284365', to_date('10-09-2004', 'dd-mm-yyyy'), 'Jonatha328', 'V3El0ytLze');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('561919139', to_date('26-02-2003', 'dd-mm-yyyy'), 'Morris496', 'I6Ipwaf4AD');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('490830032', to_date('20-01-2023', 'dd-mm-yyyy'), 'Frances862', 'NN5AdWTtz1');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('602505536', to_date('03-01-2003', 'dd-mm-yyyy'), 'Tea465', 'C279jYsgpi');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('143520341', to_date('16-10-2003', 'dd-mm-yyyy'), 'Chazz227', 'Ek73G2UXuw');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('035510904', to_date('27-01-2006', 'dd-mm-yyyy'), 'Denis184', 'Wkugy9uKga');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('391006246', to_date('28-02-2000', 'dd-mm-yyyy'), 'Garland761', '45K8p0dWIy');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('918067269', to_date('10-09-2002', 'dd-mm-yyyy'), 'Allan195', 'FrFLPuymzw');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('984268974', to_date('29-05-2000', 'dd-mm-yyyy'), 'Reese167', 'HIQwNY5gaA');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('214713146', to_date('09-07-2015', 'dd-mm-yyyy'), 'Gates562', 'gzVou7lNsG');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('374339845', to_date('09-10-2000', 'dd-mm-yyyy'), 'Carolyn324', 'gAuq6YXN61');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('528625739', to_date('11-03-2002', 'dd-mm-yyyy'), 'Robert541', 'bhocUjT4NZ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('625324658', to_date('18-06-2005', 'dd-mm-yyyy'), 'Mac377', 'QT32MbDZ4W');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('519806856', to_date('02-05-2001', 'dd-mm-yyyy'), 'Raymond766', '6T46JQqLNF');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('826605920', to_date('06-05-2002', 'dd-mm-yyyy'), 'Bo447', '5ysXcwrqa2');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('708212180', to_date('09-08-2011', 'dd-mm-yyyy'), 'Brian273', 'eLBCVZiHeR');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('691197193', to_date('11-06-2012', 'dd-mm-yyyy'), 'Maura923', 'K1rl3E2Z0n');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('736410796', to_date('27-09-2012', 'dd-mm-yyyy'), 'Roddy273', 'RDWhl8Yc92');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('668963614', to_date('02-12-2019', 'dd-mm-yyyy'), 'Gilbert159', 'GZzlyDsQul');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('348351561', to_date('29-07-2017', 'dd-mm-yyyy'), 'Alice429', 'DBEXJ3e7sb');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('145366143', to_date('14-07-2006', 'dd-mm-yyyy'), 'Courtney873', 'CjKABzRgsO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('758867042', to_date('29-07-2021', 'dd-mm-yyyy'), 'Clea983', '7lO3CNneTM');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('188258885', to_date('11-05-2020', 'dd-mm-yyyy'), 'Alfred126', 'mxD14MSZLo');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('309357389', to_date('20-03-2000', 'dd-mm-yyyy'), 'Eugene262', 'joIZnA06Ra');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('122728860', to_date('20-09-2005', 'dd-mm-yyyy'), 'Gino255', 'g61NIIGdbk');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('780840485', to_date('07-10-2023', 'dd-mm-yyyy'), 'Ted779', 'OIWCHFhL13');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('180191326', to_date('12-06-2023', 'dd-mm-yyyy'), 'Kirsten829', 'CjFTiEuQEV');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('063300220', to_date('20-12-2002', 'dd-mm-yyyy'), 'Aaron572', 'Kfyefpj8ZO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('530838321', to_date('16-10-2015', 'dd-mm-yyyy'), 'Jude479', 'L1rLlXKBRK');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('332935578', to_date('06-01-2017', 'dd-mm-yyyy'), 'Thora959', 'aaSudr2NiM');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('096353906', to_date('17-10-2001', 'dd-mm-yyyy'), 'Karen914', 'cDZGMXPHFB');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('342761949', to_date('12-01-2022', 'dd-mm-yyyy'), 'Anne685', 'c1HSsk2wCL');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('677097969', to_date('26-06-2008', 'dd-mm-yyyy'), 'Kathy317', 'sXoOUFYaYR');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('772907524', to_date('16-06-2006', 'dd-mm-yyyy'), 'Graham335', 'DvWYFbcHZE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('054807164', to_date('17-03-2022', 'dd-mm-yyyy'), 'Ben978', 'O9nfMMhcAw');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('765668671', to_date('17-12-2012', 'dd-mm-yyyy'), 'Illeana816', 'nBWsGIHPk0');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('600730948', to_date('05-07-2004', 'dd-mm-yyyy'), 'Rawlins689', 'JfQnQ9mvvR');
commit;
prompt 300 records committed...
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('081383228', to_date('24-05-2007', 'dd-mm-yyyy'), 'Grace228', '8ijedAEbtM');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('483206140', to_date('09-08-2010', 'dd-mm-yyyy'), 'Benjamin957', 'P96feal1Xl');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('951365336', to_date('19-10-2015', 'dd-mm-yyyy'), 'Jared317', 'qkvP5m2R3D');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('655586968', to_date('11-05-2005', 'dd-mm-yyyy'), 'Vincent836', 'DOBYmRARNz');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('499600585', to_date('17-10-2007', 'dd-mm-yyyy'), 'Pam663', 'kIPSKgggbE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('899786232', to_date('16-02-2017', 'dd-mm-yyyy'), 'Miles324', 'X7buOLSWSE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('668933071', to_date('24-08-2009', 'dd-mm-yyyy'), 'Arnold116', '3GDqE5eklW');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('157451231', to_date('06-04-2009', 'dd-mm-yyyy'), 'Yolanda393', 'Vy1z8deCl6');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('407435967', to_date('10-12-2006', 'dd-mm-yyyy'), 'Robbie441', 'LY8XpvyXgd');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('021781827', to_date('01-10-2001', 'dd-mm-yyyy'), 'Joaquin251', 'fZttsKGv6d');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('830383231', to_date('31-07-2017', 'dd-mm-yyyy'), 'Angela978', 'e1mIEpBdPb');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('949649669', to_date('26-07-2022', 'dd-mm-yyyy'), 'Christine558', 'yUPXZALnCJ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('191792029', to_date('14-10-2018', 'dd-mm-yyyy'), 'Jerry825', 'KQSfm6J6pt');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('574465011', to_date('04-02-2020', 'dd-mm-yyyy'), 'Gran784', 'AXI5rpwflP');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('334283784', to_date('21-11-2021', 'dd-mm-yyyy'), 'Matt652', 'y4UUFOWcgy');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('176375614', to_date('06-10-2003', 'dd-mm-yyyy'), 'Elijah842', 'Lbhq9FUdt8');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('690535760', to_date('04-07-2011', 'dd-mm-yyyy'), 'Helen451', '2y2pIAAJsF');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('675987499', to_date('09-06-2021', 'dd-mm-yyyy'), 'Maria158', 'mJmwHJC9pv');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('893824664', to_date('26-11-2009', 'dd-mm-yyyy'), 'Doug579', 'BG9QLPdc4C');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('017605424', to_date('29-11-2005', 'dd-mm-yyyy'), 'Ernest458', 'VOVg0kmhZD');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('731223212', to_date('30-07-2020', 'dd-mm-yyyy'), 'Chubby781', '4RBEbTB6ub');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('275457970', to_date('04-12-2012', 'dd-mm-yyyy'), 'Art631', 'yn4vyxRvqJ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('968200663', to_date('06-12-2022', 'dd-mm-yyyy'), 'Annie629', 'wcxncrbvCn');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('279593900', to_date('15-09-2003', 'dd-mm-yyyy'), 'Pamela938', 'NmKkspYosO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('980594838', to_date('01-11-2003', 'dd-mm-yyyy'), 'Elias185', 'B864rxhZgl');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('545498579', to_date('28-08-2017', 'dd-mm-yyyy'), 'Milla996', 'Bj9hpjD5yO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('367706464', to_date('09-07-2014', 'dd-mm-yyyy'), 'Trini164', 'h0XgZ3dexL');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('309732749', to_date('16-07-2011', 'dd-mm-yyyy'), 'April282', 'uOc651FC6A');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('949755377', to_date('02-09-2010', 'dd-mm-yyyy'), 'Gailard966', 'brHMvrXwXf');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('251574841', to_date('08-04-2010', 'dd-mm-yyyy'), 'Lucy433', 'GD0kFdecy0');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('543044858', to_date('21-02-2006', 'dd-mm-yyyy'), 'Clarence225', 'wXsHsu81JH');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('155248136', to_date('15-04-2008', 'dd-mm-yyyy'), 'Ernest169', 'VRQQmuvg4d');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('468380581', to_date('10-09-2023', 'dd-mm-yyyy'), 'Denzel216', '20pfePMZZt');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('784609914', to_date('09-10-2010', 'dd-mm-yyyy'), 'Amanda142', 'E2cz9NzeNG');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('187515796', to_date('02-04-2011', 'dd-mm-yyyy'), 'Zooey469', 'H4ezAqHAIi');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('075665329', to_date('08-01-2018', 'dd-mm-yyyy'), 'Hazel377', 'xOKa5hMQmc');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('402909496', to_date('24-07-2012', 'dd-mm-yyyy'), 'Brendan168', 'J2bIiZtSnZ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('864337815', to_date('19-05-2022', 'dd-mm-yyyy'), 'Petula629', 'IyzQbB4Op9');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('555047971', to_date('11-02-2000', 'dd-mm-yyyy'), 'Raymond225', 't4TT6nooek');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('419340592', to_date('09-08-2020', 'dd-mm-yyyy'), 'Raymond742', 'eHRCcguTFW');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('348007353', to_date('03-08-2004', 'dd-mm-yyyy'), 'Alessandro755', '3haerp82R0');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('638414377', to_date('18-05-2018', 'dd-mm-yyyy'), 'Andrew247', 'MI1x31X56T');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('078881161', to_date('08-12-2004', 'dd-mm-yyyy'), 'Emily227', 'Sb3Vg3iTXx');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('488229246', to_date('29-09-2018', 'dd-mm-yyyy'), 'Carolyn447', '9hU3LKYpeZ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('247748869', to_date('11-06-2022', 'dd-mm-yyyy'), 'Gates715', 'Sk8eqGpWya');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('297681984', to_date('11-12-2004', 'dd-mm-yyyy'), 'Fisher654', '01RADgc1E2');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('446332100', to_date('22-06-2005', 'dd-mm-yyyy'), 'Roger376', 'WSPrqtfdwm');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('390905524', to_date('30-04-2002', 'dd-mm-yyyy'), 'Ashley162', 'xRnvbNPFlq');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('602669135', to_date('16-02-2020', 'dd-mm-yyyy'), 'Charlize189', 'Xb4Rdiyf1b');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('267137605', to_date('25-12-2009', 'dd-mm-yyyy'), 'Hikaru584', 'rYqRQkGzoS');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('398373857', to_date('27-02-2017', 'dd-mm-yyyy'), 'Diane621', 'dwsSHYR7YF');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('177382748', to_date('31-03-2002', 'dd-mm-yyyy'), 'Ricardo617', 'AJaOOKDb1L');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('305084973', to_date('24-11-2003', 'dd-mm-yyyy'), 'Charles912', 'kP1BBWnNho');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('701763678', to_date('23-07-2009', 'dd-mm-yyyy'), 'Tamala358', 'BDlWl7kMGe');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('033035228', to_date('11-11-2020', 'dd-mm-yyyy'), 'Liev386', '8FvWOk2G0v');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('022601726', to_date('10-09-2021', 'dd-mm-yyyy'), 'Woody894', 'chxQtsr9Hz');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('421224696', to_date('28-03-2019', 'dd-mm-yyyy'), 'Saffron388', 'RclG52gDve');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('621314773', to_date('25-01-2012', 'dd-mm-yyyy'), 'Walter691', 'a7TYH05QhP');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('448707100', to_date('05-11-2006', 'dd-mm-yyyy'), 'Uma754', 'jbUzcwkEmZ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('417953406', to_date('29-09-2010', 'dd-mm-yyyy'), 'Isaac418', 'aqN9adQD5S');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('917208879', to_date('30-10-2023', 'dd-mm-yyyy'), 'Kris619', 'RIn8Rgmqnd');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('824236874', to_date('13-02-2007', 'dd-mm-yyyy'), 'Joshua995', 'UAVIbdQ7o4');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('771616343', to_date('26-12-2020', 'dd-mm-yyyy'), 'Rupert281', 'OhBuACpF6J');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('628942053', to_date('21-11-2022', 'dd-mm-yyyy'), 'Allan329', 'aKTtGUBLDg');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('265897934', to_date('01-10-2014', 'dd-mm-yyyy'), 'Kiefer734', 'VWeheUFdUA');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('766598824', to_date('04-12-2017', 'dd-mm-yyyy'), 'Steve984', 'IXrZWploSX');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('012259052', to_date('21-11-2007', 'dd-mm-yyyy'), 'Hal793', 'rkw53JKBBE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('186164668', to_date('29-05-2012', 'dd-mm-yyyy'), 'Jonathan727', 'WZy1YJCNuY');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('159620386', to_date('18-01-2007', 'dd-mm-yyyy'), 'Anita884', 'tJdWMMIgYr');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('810869456', to_date('16-02-2006', 'dd-mm-yyyy'), 'Harrison718', 'ByFGkPHM87');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('029124580', to_date('17-12-2007', 'dd-mm-yyyy'), 'Trick314', 'f0lij5F3SH');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('302857054', to_date('29-10-2003', 'dd-mm-yyyy'), 'Joseph716', 'tVrXfbRpOB');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('798274104', to_date('30-10-2006', 'dd-mm-yyyy'), 'Bradley431', 'aZINioRIee');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('268281389', to_date('09-05-2015', 'dd-mm-yyyy'), 'Robin557', 'KhYXn4ZZpe');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('524896676', to_date('23-06-2005', 'dd-mm-yyyy'), 'Marisa644', 'Dp9febSWBc');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('353108066', to_date('21-06-2003', 'dd-mm-yyyy'), 'Bobbi579', 'boy13iKMcq');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('800071003', to_date('02-06-2022', 'dd-mm-yyyy'), 'Betty462', '8sn7JEAs5a');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('287066393', to_date('14-12-2005', 'dd-mm-yyyy'), 'Cloris953', '7q9Rfja9vE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('192192535', to_date('10-09-2002', 'dd-mm-yyyy'), 'Gene977', '2cLzzfZuzm');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('061215635', to_date('29-09-2022', 'dd-mm-yyyy'), 'Catherine818', '9VjM7a6B1u');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('497982843', to_date('10-05-2018', 'dd-mm-yyyy'), 'Winona538', 't2aihMHlla');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('932205429', to_date('14-05-2011', 'dd-mm-yyyy'), 'Wang767', 'nChMo797gM');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('667461962', to_date('25-01-2008', 'dd-mm-yyyy'), 'Freddie895', 'CILJx26cJt');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('978514891', to_date('12-10-2005', 'dd-mm-yyyy'), 'Gena967', 'NcCxRRq2Gd');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('706196502', to_date('26-11-2003', 'dd-mm-yyyy'), 'Rade488', '6qQF1h7IEI');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('093818015', to_date('28-07-2022', 'dd-mm-yyyy'), 'Dionne133', 'RGUIrQ1gRi');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('322854435', to_date('14-06-2023', 'dd-mm-yyyy'), 'Lupe633', 'UjozCzlK7n');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('797864475', to_date('27-10-2013', 'dd-mm-yyyy'), 'Keanu265', 'x0mBKD4ad5');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('986715923', to_date('06-09-2001', 'dd-mm-yyyy'), 'Joe842', 'OKG6QIX8nT');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('950424090', to_date('12-09-2006', 'dd-mm-yyyy'), 'Dabney331', 'sEaC2n6Vjk');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('653774196', to_date('07-11-2022', 'dd-mm-yyyy'), 'Sean225', 'YehoqvvB2H');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('738373379', to_date('12-06-2017', 'dd-mm-yyyy'), 'Brenda757', 'wlx5894hsA');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('932959604', to_date('21-05-2000', 'dd-mm-yyyy'), 'Susan987', 'tORkwAtZP6');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('657588520', to_date('01-12-2022', 'dd-mm-yyyy'), 'Jimmie856', 'ToCjRVI2Ux');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('498584448', to_date('04-03-2021', 'dd-mm-yyyy'), 'Debi936', 'I0FFDqj84T');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('403239539', to_date('12-01-2021', 'dd-mm-yyyy'), 'Kate431', 'iMlK2G5xoA');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('633954768', to_date('05-08-2014', 'dd-mm-yyyy'), 'Rowan997', 'zOxBqV8bp9');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('791299463', to_date('17-02-2018', 'dd-mm-yyyy'), 'Edie619', 'iuYsztt77W');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('025274453', to_date('03-03-2024', 'dd-mm-yyyy'), 'Jesus429', 'kG5fEO7NyR');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('246071605', to_date('07-04-2007', 'dd-mm-yyyy'), 'Desmond751', 'ktrGaTQ1mP');
commit;
prompt 400 records committed...
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('245272383', to_date('21-06-2014', 'dd-mm-yyyy'), 'Vondie892', 'DFK4nwYvXA');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('939973048', to_date('17-01-2007', 'dd-mm-yyyy'), 'Barbara445', 'jBIzrkW2LH');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('301487527', to_date('11-07-2018', 'dd-mm-yyyy'), 'Rip949', '7JVDvPWwVl');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('119362966', to_date('21-11-2002', 'dd-mm-yyyy'), 'Lily825', 'IYKowVsuFl');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('746109991', to_date('19-06-2016', 'dd-mm-yyyy'), 'Carla834', '69UDkRMhKb');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('915567582', to_date('22-07-2003', 'dd-mm-yyyy'), 'Clint336', 'JAm5KZecA5');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('185553927', to_date('17-10-2007', 'dd-mm-yyyy'), 'Stellan949', '6by2JRECKY');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('029695329', to_date('13-02-2012', 'dd-mm-yyyy'), 'Juliet257', 'q8hFtYAf11');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('418350339', to_date('27-10-2016', 'dd-mm-yyyy'), 'Natasha916', '6z8XrPCvAO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('220633642', to_date('17-05-2008', 'dd-mm-yyyy'), 'Zooey651', 'SA9Grcmvmr');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('713944647', to_date('20-04-2024', 'dd-mm-yyyy'), 'Vondie384', '13NYb1tOW1');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('000677810', to_date('28-04-2005', 'dd-mm-yyyy'), 'Benicio714', 'bEASGVvrbK');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('928095860', to_date('05-03-2011', 'dd-mm-yyyy'), 'Treat682', 'c3pumAWESR');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('953469588', to_date('20-10-2003', 'dd-mm-yyyy'), 'Toshiro554', 'JsYaCXC3tv');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('255474214', to_date('09-02-2014', 'dd-mm-yyyy'), 'Emmylou952', 'FFMPUue1lp');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('335765816', to_date('09-10-2010', 'dd-mm-yyyy'), 'Lea347', 'vs1Vbjgo9k');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('176288723', to_date('13-08-2007', 'dd-mm-yyyy'), 'Bebe642', 'KxM8krEeTU');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('034808493', to_date('05-07-2006', 'dd-mm-yyyy'), 'Antonio898', 'YUut2VPTUV');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('847250676', to_date('22-10-2003', 'dd-mm-yyyy'), 'Thelma731', 'nXVcJHEQhq');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('189152630', to_date('28-09-2023', 'dd-mm-yyyy'), 'Rueben972', 'whk8PZOs1j');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('077412256', to_date('24-06-2013', 'dd-mm-yyyy'), 'Brenda181', '3K0wUg9DEh');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('386518366', to_date('09-11-2005', 'dd-mm-yyyy'), 'Max511', 'lkIvZ1KTRq');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('180966239', to_date('20-07-2001', 'dd-mm-yyyy'), 'Salma128', '6t4lWcTKNm');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('438188432', to_date('03-10-2016', 'dd-mm-yyyy'), 'Fiona999', 'rZPNRuAUl4');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('019362397', to_date('23-09-2000', 'dd-mm-yyyy'), 'Dan731', 'W9GsLssrez');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('259058467', to_date('01-08-2008', 'dd-mm-yyyy'), 'Sean133', 'RBvEXLFS1T');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('676285276', to_date('20-07-2009', 'dd-mm-yyyy'), 'Mary Beth496', 'tESBROT24p');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('664089285', to_date('05-07-2010', 'dd-mm-yyyy'), 'Crystal665', 'kqBX01gMF4');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('055249826', to_date('30-05-2003', 'dd-mm-yyyy'), 'Mykelti181', 'vijfwBd9oL');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('619459411', to_date('04-07-2001', 'dd-mm-yyyy'), 'Zooey176', 'yZ1bJHxhuC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('849628298', to_date('06-06-2011', 'dd-mm-yyyy'), 'Deborah334', 'c1H6WV2c5Q');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('046657439', to_date('04-09-2018', 'dd-mm-yyyy'), 'Tyrone388', 'AG9NUsFuit');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('513366861', to_date('19-02-2019', 'dd-mm-yyyy'), 'Elisabeth389', 'Zdm8ggOC4d');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('423509159', to_date('23-08-2020', 'dd-mm-yyyy'), 'Famke157', 'ioLnTEt6az');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('301483688', to_date('27-05-2008', 'dd-mm-yyyy'), 'Wes529', 'rpffYwZTWA');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('828869477', to_date('27-03-2007', 'dd-mm-yyyy'), 'Rupert625', 'ruVSdm6lG8');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('485100893', to_date('08-07-2013', 'dd-mm-yyyy'), 'Cesar845', 'c3AulZ72FZ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('498766701', to_date('29-07-2008', 'dd-mm-yyyy'), 'Hope674', 'bZSFY1jjuV');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('140829165', to_date('07-08-2011', 'dd-mm-yyyy'), 'Nastassja992', 'v73Opt15dw');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('850334182', to_date('26-11-2000', 'dd-mm-yyyy'), 'Patrick168', 'TKhgnkgdBV');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('206148591', to_date('26-03-2007', 'dd-mm-yyyy'), 'Vendetta342', 'hot24IyOlT');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('487301584', to_date('17-03-2016', 'dd-mm-yyyy'), 'Bebe874', 'mkbraAKNbE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('983492574', to_date('14-06-2012', 'dd-mm-yyyy'), 'Adam994', 'rixXnjZ4IG');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('801792400', to_date('04-05-2018', 'dd-mm-yyyy'), 'Kiefer311', 'n8eGJQYguX');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('853596678', to_date('03-02-2008', 'dd-mm-yyyy'), 'Larry138', 'mOI4vuxatw');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('697531067', to_date('07-06-2019', 'dd-mm-yyyy'), 'Andy356', 'uww1mHeJMp');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('942242894', to_date('02-03-2007', 'dd-mm-yyyy'), 'Vivica427', 'zl9AMCZFqs');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('001852633', to_date('01-12-2020', 'dd-mm-yyyy'), 'Elvis427', '6RaIgV0RyC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('971707537', to_date('08-01-2014', 'dd-mm-yyyy'), 'Lonnie629', 'Bak28lLWNG');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('937829536', to_date('11-04-2011', 'dd-mm-yyyy'), 'Kim325', 'ez8YPndm5g');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('269524383', to_date('21-10-2007', 'dd-mm-yyyy'), 'Mel667', 'eIWm2dBO0p');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('964121065', to_date('06-04-2016', 'dd-mm-yyyy'), 'Nicole556', 's5Nmzl4ixK');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('232611240', to_date('22-08-2006', 'dd-mm-yyyy'), 'Jill179', 'vhIOt49dBl');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('025953504', to_date('17-11-2009', 'dd-mm-yyyy'), 'Katrin534', 'oC6NBxbgaC');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('301595276', to_date('29-09-2021', 'dd-mm-yyyy'), 'Shelby365', 'Uds2FPbPMK');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('058608539', to_date('18-04-2014', 'dd-mm-yyyy'), 'Vern599', 'BJieJptWqg');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('908811401', to_date('03-04-2010', 'dd-mm-yyyy'), 'Marlon297', 'XXjSAj3vaP');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('729801502', to_date('11-06-2002', 'dd-mm-yyyy'), 'Leelee772', '2oxJl4SRcO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('844554382', to_date('24-02-2019', 'dd-mm-yyyy'), 'Patty849', 'Q0GMWIDV0W');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('432425942', to_date('20-03-2019', 'dd-mm-yyyy'), 'Suzy148', 'AWKkma2pEo');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('011679094', to_date('28-01-2006', 'dd-mm-yyyy'), 'Swoosie538', 'sZZHI3H5dd');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('915372180', to_date('01-03-2020', 'dd-mm-yyyy'), 'Delbert466', 'lF59fuoett');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('230944652', to_date('28-06-2017', 'dd-mm-yyyy'), 'Jarvis345', 'OhGWvLXRi3');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('161677298', to_date('29-06-2003', 'dd-mm-yyyy'), 'Darius475', 'Q2uPzZZs34');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('392278651', to_date('05-11-2017', 'dd-mm-yyyy'), 'Taye245', 'vo1odmnpLc');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('275681892', to_date('25-12-2016', 'dd-mm-yyyy'), 'Christina351', '0SoR87L4iU');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('281102853', to_date('23-06-2010', 'dd-mm-yyyy'), 'Ming-Na258', '404AkVTrYq');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('545327628', to_date('01-06-2001', 'dd-mm-yyyy'), 'Leon873', 'sB5VPzm3zI');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('965000417', to_date('26-04-2007', 'dd-mm-yyyy'), 'Wallace537', 'NjWF37dctQ');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('866701211', to_date('12-06-2021', 'dd-mm-yyyy'), 'Tea981', 'yHWJN0Jjex');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('584118594', to_date('06-07-2008', 'dd-mm-yyyy'), 'Wally571', '8gCtarrHAS');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('622978701', to_date('30-01-2020', 'dd-mm-yyyy'), 'Hikaru647', 'NyhiGb9AZi');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('336576783', to_date('27-05-2019', 'dd-mm-yyyy'), 'Rachid312', 'okQHcf4oua');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('652120441', to_date('17-06-2023', 'dd-mm-yyyy'), 'Radney586', 'XeI96k0zxe');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('442298493', to_date('12-05-2022', 'dd-mm-yyyy'), 'Kyle188', '9hrdt3gViM');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('701862029', to_date('26-05-2020', 'dd-mm-yyyy'), 'Carol891', '7N6RIREtkH');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('526716833', to_date('14-02-2004', 'dd-mm-yyyy'), 'Trace985', 'FqRQAc26iG');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('645106048', to_date('17-09-2007', 'dd-mm-yyyy'), 'Clint124', '8AfCPNjBka');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('905167354', to_date('02-07-2014', 'dd-mm-yyyy'), 'Ernest751', '13IvBysifx');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('805665451', to_date('13-07-2012', 'dd-mm-yyyy'), 'Jennifer568', '0jVKRF7wEd');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('920761389', to_date('20-11-2003', 'dd-mm-yyyy'), 'Andy439', 'nreXb19YSL');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('311894913', to_date('05-12-2023', 'dd-mm-yyyy'), 'Frankie483', '2jsC8GLsZs');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('219278525', to_date('14-10-2000', 'dd-mm-yyyy'), 'Dustin821', 'awHMAPbrGf');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('526540050', to_date('27-04-2003', 'dd-mm-yyyy'), 'Sheryl496', 'MOhYbc8rvO');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('110778805', to_date('03-10-2020', 'dd-mm-yyyy'), 'Antonio826', 'aoHz3AcrFE');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('701919398', to_date('24-10-2014', 'dd-mm-yyyy'), 'Ike293', 'MVGmOwXFRw');
insert into LIBRARIAN (librarianid, startdate, username, userpassword)
values ('662443577', to_date('17-03-2015', 'dd-mm-yyyy'), 'Armand377', 'TitTOyKVHf');
commit;
prompt 487 records loaded
prompt Loading BOOKLENDING...
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (1, to_date('17-03-2022', 'dd-mm-yyyy'), to_date('06-12-2022', 'dd-mm-yyyy'), null, '989570315', '596690563', 650);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (2, to_date('11-09-2022', 'dd-mm-yyyy'), to_date('25-09-2022', 'dd-mm-yyyy'), null, '874481938', '376926882', 403);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (3, to_date('27-03-2020', 'dd-mm-yyyy'), to_date('10-04-2020', 'dd-mm-yyyy'), null, '915923130', '526829293', 207);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (4, to_date('22-06-2011', 'dd-mm-yyyy'), to_date('18-03-2014', 'dd-mm-yyyy'), null, '913760353', '631487255', 304);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (5, to_date('25-08-2014', 'dd-mm-yyyy'), to_date('29-12-2022', 'dd-mm-yyyy'), null, '353506388', '791299463', 653);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (6, to_date('02-02-2009', 'dd-mm-yyyy'), to_date('12-11-2013', 'dd-mm-yyyy'), null, '066613546', '081383228', 642);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (7, to_date('04-01-2008', 'dd-mm-yyyy'), to_date('25-04-2013', 'dd-mm-yyyy'), null, '725276037', '214713146', 5);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (8, to_date('17-01-2016', 'dd-mm-yyyy'), to_date('31-01-2016', 'dd-mm-yyyy'), null, '793092711', '519792429', 298);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (9, to_date('31-07-2010', 'dd-mm-yyyy'), to_date('19-09-2014', 'dd-mm-yyyy'), null, '645106048', '498766701', 461);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (10, to_date('10-04-2015', 'dd-mm-yyyy'), to_date('24-04-2015', 'dd-mm-yyyy'), null, '413075709', '945150294', 698);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (11, to_date('20-09-2009', 'dd-mm-yyyy'), to_date('30-04-2011', 'dd-mm-yyyy'), null, '275681892', '526540050', 663);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (12, to_date('31-05-2003', 'dd-mm-yyyy'), to_date('30-04-2011', 'dd-mm-yyyy'), null, '688973370', '001852633', 33);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (13, to_date('15-02-2016', 'dd-mm-yyyy'), to_date('12-06-2018', 'dd-mm-yyyy'), null, '563934878', '524896676', 333);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (14, to_date('21-04-2017', 'dd-mm-yyyy'), to_date('05-05-2017', 'dd-mm-yyyy'), null, '235099187', '461518573', 22);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (15, to_date('14-04-2021', 'dd-mm-yyyy'), to_date('20-08-2023', 'dd-mm-yyyy'), null, '992475501', '187515796', 400);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (16, to_date('28-04-2012', 'dd-mm-yyyy'), to_date('14-05-2015', 'dd-mm-yyyy'), null, '938101191', '086072867', 868);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (17, to_date('20-11-2012', 'dd-mm-yyyy'), to_date('10-04-2022', 'dd-mm-yyyy'), null, '053078260', '017605424', 369);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (18, to_date('12-02-2008', 'dd-mm-yyyy'), to_date('18-06-2016', 'dd-mm-yyyy'), null, '800071003', '917208879', 1);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (19, to_date('26-12-2022', 'dd-mm-yyyy'), to_date('09-01-2023', 'dd-mm-yyyy'), null, '311690756', '170713739', 288);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (20, to_date('27-03-2017', 'dd-mm-yyyy'), to_date('10-04-2017', 'dd-mm-yyyy'), null, '878867388', '667461962', 475);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (21, to_date('02-06-2006', 'dd-mm-yyyy'), to_date('14-03-2017', 'dd-mm-yyyy'), null, '377017130', '263852543', 660);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (22, to_date('26-06-2020', 'dd-mm-yyyy'), to_date('10-07-2020', 'dd-mm-yyyy'), null, '081383228', '853341811', 415);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (23, to_date('05-03-2000', 'dd-mm-yyyy'), to_date('26-01-2022', 'dd-mm-yyyy'), null, '989570315', '856216050', 422);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (24, to_date('11-06-2018', 'dd-mm-yyyy'), to_date('11-12-2022', 'dd-mm-yyyy'), null, '878867388', '998214636', 801);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (25, to_date('25-09-2010', 'dd-mm-yyyy'), to_date('14-11-2018', 'dd-mm-yyyy'), null, '379348654', '096353906', 284);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (26, to_date('09-08-2021', 'dd-mm-yyyy'), to_date('24-03-2024', 'dd-mm-yyyy'), null, '562094648', '703815502', 202);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (27, to_date('28-06-2023', 'dd-mm-yyyy'), to_date('12-07-2023', 'dd-mm-yyyy'), null, '874752399', '319029281', 292);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (28, to_date('03-05-2016', 'dd-mm-yyyy'), to_date('06-12-2023', 'dd-mm-yyyy'), null, '261535229', '012259052', 976);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (29, to_date('16-08-2013', 'dd-mm-yyyy'), to_date('18-01-2022', 'dd-mm-yyyy'), null, '915372180', '582783692', 816);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (30, to_date('02-06-2019', 'dd-mm-yyyy'), to_date('16-06-2019', 'dd-mm-yyyy'), null, '035510904', '549134893', 240);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (31, to_date('18-05-2021', 'dd-mm-yyyy'), to_date('01-06-2021', 'dd-mm-yyyy'), null, '379348654', '315680603', 745);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (32, to_date('04-08-2013', 'dd-mm-yyyy'), to_date('20-09-2020', 'dd-mm-yyyy'), null, '417953406', '819819701', 815);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (33, to_date('02-01-2020', 'dd-mm-yyyy'), to_date('17-01-2023', 'dd-mm-yyyy'), null, '826540393', '281102853', 869);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (34, to_date('31-07-2014', 'dd-mm-yyyy'), to_date('14-08-2014', 'dd-mm-yyyy'), null, '553241085', '928264310', 446);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (35, to_date('18-03-2014', 'dd-mm-yyyy'), to_date('01-05-2018', 'dd-mm-yyyy'), null, '264847178', '081383228', 479);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (36, to_date('10-08-2001', 'dd-mm-yyyy'), to_date('26-02-2024', 'dd-mm-yyyy'), null, '155490931', '831042091', 239);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (37, to_date('28-07-2010', 'dd-mm-yyyy'), to_date('19-03-2024', 'dd-mm-yyyy'), null, '391352233', '800071003', 947);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (38, to_date('02-11-2023', 'dd-mm-yyyy'), to_date('16-11-2023', 'dd-mm-yyyy'), null, '963083303', '694117241', 467);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (39, to_date('09-10-2011', 'dd-mm-yyyy'), to_date('18-11-2015', 'dd-mm-yyyy'), null, '914006622', '268281389', 83);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (40, to_date('12-11-2015', 'dd-mm-yyyy'), to_date('26-11-2015', 'dd-mm-yyyy'), null, '441785402', '186164668', 373);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (41, to_date('24-09-2007', 'dd-mm-yyyy'), to_date('22-01-2020', 'dd-mm-yyyy'), null, '520422787', '235761739', 893);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (42, to_date('05-11-2018', 'dd-mm-yyyy'), to_date('19-11-2018', 'dd-mm-yyyy'), null, '913760353', '971662190', 20);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (43, to_date('12-06-2002', 'dd-mm-yyyy'), to_date('26-03-2016', 'dd-mm-yyyy'), null, '436366104', '980594838', 39);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (44, to_date('29-04-2012', 'dd-mm-yyyy'), to_date('13-05-2012', 'dd-mm-yyyy'), null, '805127954', '965000417', 270);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (45, to_date('13-12-2020', 'dd-mm-yyyy'), to_date('30-01-2024', 'dd-mm-yyyy'), null, '273149266', '045601319', 826);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (46, to_date('25-07-2009', 'dd-mm-yyyy'), to_date('03-01-2020', 'dd-mm-yyyy'), null, '054248733', '847250676', 84);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (47, to_date('24-10-2009', 'dd-mm-yyyy'), to_date('22-07-2016', 'dd-mm-yyyy'), null, '077468421', '176375614', 335);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (48, to_date('13-12-2018', 'dd-mm-yyyy'), to_date('06-08-2022', 'dd-mm-yyyy'), null, '035510904', '850334182', 591);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (49, to_date('14-09-2022', 'dd-mm-yyyy'), to_date('22-04-2024', 'dd-mm-yyyy'), null, '978612834', '106927049', 129);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (50, to_date('16-05-2009', 'dd-mm-yyyy'), to_date('11-02-2016', 'dd-mm-yyyy'), null, '216475555', '490830032', 767);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (51, to_date('27-02-2012', 'dd-mm-yyyy'), to_date('12-03-2012', 'dd-mm-yyyy'), null, '226545801', '772907524', 499);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (52, to_date('04-07-2021', 'dd-mm-yyyy'), to_date('18-07-2021', 'dd-mm-yyyy'), null, '783055575', '913647996', 319);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (53, to_date('01-05-2017', 'dd-mm-yyyy'), to_date('03-02-2023', 'dd-mm-yyyy'), null, '420027444', '608394597', 882);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (54, to_date('15-04-2013', 'dd-mm-yyyy'), to_date('09-09-2022', 'dd-mm-yyyy'), null, '241206486', '267137605', 849);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (55, to_date('25-06-2018', 'dd-mm-yyyy'), to_date('09-07-2018', 'dd-mm-yyyy'), null, '377017130', '255474214', 214);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (56, to_date('20-01-2000', 'dd-mm-yyyy'), to_date('21-02-2021', 'dd-mm-yyyy'), null, '029695329', '319029281', 832);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (57, to_date('04-07-2018', 'dd-mm-yyyy'), to_date('18-07-2018', 'dd-mm-yyyy'), null, '043939492', '864337815', 94);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (58, to_date('02-11-2015', 'dd-mm-yyyy'), to_date('23-07-2023', 'dd-mm-yyyy'), null, '582783692', '216475555', 90);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (59, to_date('15-08-2004', 'dd-mm-yyyy'), to_date('11-02-2017', 'dd-mm-yyyy'), null, '039153067', '301487527', 443);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (60, to_date('22-12-2017', 'dd-mm-yyyy'), to_date('28-05-2023', 'dd-mm-yyyy'), null, '161677298', '632046362', 632);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (61, to_date('27-07-2007', 'dd-mm-yyyy'), to_date('02-02-2015', 'dd-mm-yyyy'), null, '029124580', '379348654', 200);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (62, to_date('09-05-2010', 'dd-mm-yyyy'), to_date('16-06-2023', 'dd-mm-yyyy'), null, '240939313', '192192535', 950);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (63, to_date('12-09-2007', 'dd-mm-yyyy'), to_date('29-11-2020', 'dd-mm-yyyy'), null, '874752399', '053166731', 717);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (64, to_date('19-09-2008', 'dd-mm-yyyy'), to_date('18-02-2019', 'dd-mm-yyyy'), null, '932959604', '830383231', 512);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (65, to_date('29-09-2014', 'dd-mm-yyyy'), to_date('13-10-2014', 'dd-mm-yyyy'), null, '913760353', '353108066', 487);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (66, to_date('05-06-2012', 'dd-mm-yyyy'), to_date('03-12-2018', 'dd-mm-yyyy'), null, '526716833', '034808493', 362);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (67, to_date('30-07-2000', 'dd-mm-yyyy'), to_date('27-04-2022', 'dd-mm-yyyy'), null, '310404144', '776528409', 792);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (68, to_date('27-03-2022', 'dd-mm-yyyy'), to_date('10-04-2022', 'dd-mm-yyyy'), null, '507745420', '602220915', 864);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (69, to_date('24-06-2003', 'dd-mm-yyyy'), to_date('19-04-2010', 'dd-mm-yyyy'), null, '149245218', '914751680', 728);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (70, to_date('17-09-2018', 'dd-mm-yyyy'), to_date('01-10-2018', 'dd-mm-yyyy'), null, '664089285', '217140305', 547);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (71, to_date('06-04-2008', 'dd-mm-yyyy'), to_date('02-05-2015', 'dd-mm-yyyy'), null, '464019730', '632046362', 283);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (72, to_date('29-03-2007', 'dd-mm-yyyy'), to_date('31-03-2017', 'dd-mm-yyyy'), null, '873355323', '361560323', 538);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (73, to_date('04-08-2009', 'dd-mm-yyyy'), to_date('17-08-2019', 'dd-mm-yyyy'), null, '391486802', '880659583', 221);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (74, to_date('07-07-2013', 'dd-mm-yyyy'), to_date('21-07-2013', 'dd-mm-yyyy'), null, '164868085', '173956351', 137);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (75, to_date('16-06-2012', 'dd-mm-yyyy'), to_date('30-06-2012', 'dd-mm-yyyy'), null, '526716833', '269524383', 262);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (76, to_date('08-05-2007', 'dd-mm-yyyy'), to_date('10-08-2015', 'dd-mm-yyyy'), null, '413075709', '110778805', 379);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (77, to_date('18-11-2008', 'dd-mm-yyyy'), to_date('08-09-2015', 'dd-mm-yyyy'), null, '418542865', '348007353', 756);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (78, to_date('27-03-2002', 'dd-mm-yyyy'), to_date('08-07-2017', 'dd-mm-yyyy'), null, '871507308', '158263429', 545);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (79, to_date('08-05-2002', 'dd-mm-yyyy'), to_date('10-11-2013', 'dd-mm-yyyy'), null, '847250676', '736410796', 389);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (80, to_date('04-07-2012', 'dd-mm-yyyy'), to_date('05-05-2020', 'dd-mm-yyyy'), null, '638353369', '886474743', 218);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (81, to_date('21-09-2002', 'dd-mm-yyyy'), to_date('16-05-2024', 'dd-mm-yyyy'), null, '310404144', '758867042', 829);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (82, to_date('26-10-2003', 'dd-mm-yyyy'), to_date('14-09-2011', 'dd-mm-yyyy'), null, '271730213', '140829165', 464);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (83, to_date('08-09-2008', 'dd-mm-yyyy'), to_date('17-02-2018', 'dd-mm-yyyy'), null, '342956097', '315680603', 372);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (84, to_date('03-10-2002', 'dd-mm-yyyy'), to_date('27-12-2017', 'dd-mm-yyyy'), null, '574465011', '736410796', 824);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (85, to_date('21-09-2023', 'dd-mm-yyyy'), to_date('05-10-2023', 'dd-mm-yyyy'), null, '846104984', '934564949', 91);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (86, to_date('02-11-2007', 'dd-mm-yyyy'), to_date('24-10-2017', 'dd-mm-yyyy'), null, '311514630', '077412256', 899);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (87, to_date('09-05-2010', 'dd-mm-yyyy'), to_date('15-10-2012', 'dd-mm-yyyy'), null, '644249525', '274453753', 834);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (88, to_date('27-11-2019', 'dd-mm-yyyy'), to_date('11-12-2019', 'dd-mm-yyyy'), null, '897822661', '853596678', 93);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (89, to_date('15-06-2021', 'dd-mm-yyyy'), to_date('29-06-2021', 'dd-mm-yyyy'), null, '490830032', '771616343', 546);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (90, to_date('10-05-2005', 'dd-mm-yyyy'), to_date('11-06-2012', 'dd-mm-yyyy'), null, '499600585', '268281389', 651);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (91, to_date('10-11-2019', 'dd-mm-yyyy'), to_date('25-11-2021', 'dd-mm-yyyy'), null, '480612577', '376926882', 948);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (92, to_date('13-12-2010', 'dd-mm-yyyy'), to_date('18-09-2013', 'dd-mm-yyyy'), null, '244652438', '619112383', 572);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (93, to_date('14-08-2018', 'dd-mm-yyyy'), to_date('28-08-2018', 'dd-mm-yyyy'), null, '141519886', '377113286', 365);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (94, to_date('05-08-2018', 'dd-mm-yyyy'), to_date('26-11-2021', 'dd-mm-yyyy'), null, '735902946', '500068415', 30);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (95, to_date('07-02-2020', 'dd-mm-yyyy'), to_date('21-02-2020', 'dd-mm-yyyy'), null, '126770208', '953469588', 773);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (96, to_date('07-12-2022', 'dd-mm-yyyy'), to_date('21-12-2022', 'dd-mm-yyyy'), null, '886314861', '703815502', 739);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (97, to_date('07-03-2019', 'dd-mm-yyyy'), to_date('21-03-2019', 'dd-mm-yyyy'), null, '718788104', '288606298', 77);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (98, to_date('21-01-2017', 'dd-mm-yyyy'), to_date('28-06-2021', 'dd-mm-yyyy'), null, '046657439', '432425942', 719);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (99, to_date('10-04-2018', 'dd-mm-yyyy'), to_date('11-12-2020', 'dd-mm-yyyy'), null, '221505949', '738373379', 92);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (100, to_date('15-10-2015', 'dd-mm-yyyy'), to_date('31-03-2016', 'dd-mm-yyyy'), null, '562094648', '949649669', 349);
commit;
prompt 100 records committed...
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (101, to_date('24-04-2012', 'dd-mm-yyyy'), to_date('14-05-2015', 'dd-mm-yyyy'), null, '828869477', '553241085', 914);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (102, to_date('03-08-2022', 'dd-mm-yyyy'), to_date('17-08-2022', 'dd-mm-yyyy'), null, '327179287', '177902350', 871);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (103, to_date('15-09-2010', 'dd-mm-yyyy'), to_date('28-08-2014', 'dd-mm-yyyy'), null, '803660894', '942977640', 112);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (104, to_date('12-01-2015', 'dd-mm-yyyy'), to_date('01-04-2023', 'dd-mm-yyyy'), null, '639941357', '420027444', 275);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (105, to_date('23-03-2010', 'dd-mm-yyyy'), to_date('06-04-2010', 'dd-mm-yyyy'), null, '045601319', '846104984', 785);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (106, to_date('27-05-2010', 'dd-mm-yyyy'), to_date('21-07-2020', 'dd-mm-yyyy'), null, '594588133', '146137062', 969);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (107, to_date('03-02-2005', 'dd-mm-yyyy'), to_date('23-08-2018', 'dd-mm-yyyy'), null, '676285276', '025274453', 457);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (108, to_date('15-02-2006', 'dd-mm-yyyy'), to_date('03-01-2017', 'dd-mm-yyyy'), null, '127097395', '155248136', 644);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (109, to_date('14-05-2021', 'dd-mm-yyyy'), to_date('28-05-2021', 'dd-mm-yyyy'), null, '238684624', '676285276', 536);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (110, to_date('06-11-2016', 'dd-mm-yyyy'), to_date('28-09-2023', 'dd-mm-yyyy'), null, '831042091', '677097969', 877);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (402, to_date('07-07-2024 13:37:42', 'dd-mm-yyyy hh24:mi:ss'), to_date('21-07-2024', 'dd-mm-yyyy'), to_date('07-07-2024 17:13:21', 'dd-mm-yyyy hh24:mi:ss'), '418542865', '087859207', 658);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (111, to_date('04-07-2004', 'dd-mm-yyyy'), to_date('03-12-2011', 'dd-mm-yyyy'), null, '922607270', '905167354', 652);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (112, to_date('17-10-2000', 'dd-mm-yyyy'), to_date('14-06-2015', 'dd-mm-yyyy'), null, '464019730', '633954768', 788);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (113, to_date('07-08-2007', 'dd-mm-yyyy'), to_date('01-10-2018', 'dd-mm-yyyy'), null, '963083303', '374339845', 838);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (114, to_date('07-09-2007', 'dd-mm-yyyy'), to_date('26-06-2011', 'dd-mm-yyyy'), null, '653774196', '173956351', 344);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (115, to_date('14-07-2020', 'dd-mm-yyyy'), to_date('28-07-2020', 'dd-mm-yyyy'), null, '507745420', '697531067', 199);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (116, to_date('21-04-2023', 'dd-mm-yyyy'), to_date('05-05-2023', 'dd-mm-yyyy'), null, '250712526', '377113286', 885);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (117, to_date('22-01-2023', 'dd-mm-yyyy'), to_date('05-02-2023', 'dd-mm-yyyy'), null, '188284365', '771616343', 197);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (118, to_date('12-01-2007', 'dd-mm-yyyy'), to_date('21-01-2016', 'dd-mm-yyyy'), null, '542900586', '830383231', 16);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (119, to_date('27-10-2020', 'dd-mm-yyyy'), to_date('10-11-2020', 'dd-mm-yyyy'), null, '456794713', '851278188', 607);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (120, to_date('26-12-2012', 'dd-mm-yyyy'), to_date('01-12-2014', 'dd-mm-yyyy'), null, '518249933', '846104984', 972);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (121, to_date('16-02-2003', 'dd-mm-yyyy'), to_date('17-05-2019', 'dd-mm-yyyy'), null, '409480749', '424762764', 640);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (122, to_date('08-02-2023', 'dd-mm-yyyy'), to_date('22-02-2023', 'dd-mm-yyyy'), null, '031510193', '113036851', 470);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (123, to_date('30-12-2003', 'dd-mm-yyyy'), to_date('04-06-2019', 'dd-mm-yyyy'), null, '574465011', '245422235', 246);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (124, to_date('02-07-2003', 'dd-mm-yyyy'), to_date('16-01-2020', 'dd-mm-yyyy'), null, '334283784', '257484513', 321);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (125, to_date('01-07-2011', 'dd-mm-yyyy'), to_date('24-08-2019', 'dd-mm-yyyy'), null, '542900586', '154465176', 810);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (126, to_date('07-10-2023', 'dd-mm-yyyy'), to_date('21-10-2023', 'dd-mm-yyyy'), null, '376247399', '771616343', 580);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (127, to_date('15-03-2007', 'dd-mm-yyyy'), to_date('05-10-2010', 'dd-mm-yyyy'), null, '594588133', '232611240', 980);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (128, to_date('04-02-2010', 'dd-mm-yyyy'), to_date('18-06-2023', 'dd-mm-yyyy'), null, '327375753', '920761389', 729);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (129, to_date('27-05-2012', 'dd-mm-yyyy'), to_date('26-04-2021', 'dd-mm-yyyy'), null, '591957858', '801792400', 927);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (130, to_date('03-12-2002', 'dd-mm-yyyy'), to_date('25-11-2014', 'dd-mm-yyyy'), null, '356235416', '891562139', 574);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (131, to_date('01-11-2022', 'dd-mm-yyyy'), to_date('15-11-2022', 'dd-mm-yyyy'), null, '170713739', '379348654', 657);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (132, to_date('22-02-2010', 'dd-mm-yyyy'), to_date('07-01-2011', 'dd-mm-yyyy'), null, '563934878', '077412256', 963);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (133, to_date('27-06-2007', 'dd-mm-yyyy'), to_date('02-01-2022', 'dd-mm-yyyy'), null, '731223212', '830383231', 627);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (134, to_date('12-10-2015', 'dd-mm-yyyy'), to_date('25-12-2020', 'dd-mm-yyyy'), null, '309357389', '625529602', 843);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (135, to_date('09-12-2006', 'dd-mm-yyyy'), to_date('24-01-2020', 'dd-mm-yyyy'), null, '252004653', '776528409', 565);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (136, to_date('05-05-2005', 'dd-mm-yyyy'), to_date('19-02-2014', 'dd-mm-yyyy'), null, '604788032', '555047971', 250);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (137, to_date('02-08-2002', 'dd-mm-yyyy'), to_date('04-02-2014', 'dd-mm-yyyy'), null, '029695329', '949649669', 408);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (138, to_date('13-01-2021', 'dd-mm-yyyy'), to_date('27-01-2021', 'dd-mm-yyyy'), null, '087859207', '574465011', 481);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (139, to_date('24-02-2006', 'dd-mm-yyyy'), to_date('29-08-2011', 'dd-mm-yyyy'), null, '737691770', '285703464', 219);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (140, to_date('10-09-2018', 'dd-mm-yyyy'), to_date('24-09-2018', 'dd-mm-yyyy'), null, '013427448', '487301584', 35);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (141, to_date('27-05-2019', 'dd-mm-yyyy'), to_date('10-06-2019', 'dd-mm-yyyy'), null, '066613546', '081383228', 491);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (142, to_date('29-03-2001', 'dd-mm-yyyy'), to_date('26-01-2015', 'dd-mm-yyyy'), null, '826540393', '342761949', 903);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (143, to_date('22-04-2014', 'dd-mm-yyyy'), to_date('11-02-2022', 'dd-mm-yyyy'), null, '267137605', '272137266', 912);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (144, to_date('13-05-2007', 'dd-mm-yyyy'), to_date('13-12-2021', 'dd-mm-yyyy'), null, '266091930', '145366143', 56);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (145, to_date('12-08-2000', 'dd-mm-yyyy'), to_date('25-09-2018', 'dd-mm-yyyy'), null, '828869477', '309732749', 65);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (146, to_date('09-04-2008', 'dd-mm-yyyy'), to_date('14-10-2021', 'dd-mm-yyyy'), null, '069849743', '336288257', 336);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (147, to_date('06-02-2014', 'dd-mm-yyyy'), to_date('21-12-2023', 'dd-mm-yyyy'), null, '311514630', '376926882', 145);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (148, to_date('17-06-2016', 'dd-mm-yyyy'), to_date('05-05-2022', 'dd-mm-yyyy'), null, '669562483', '348723377', 196);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (149, to_date('06-04-2011', 'dd-mm-yyyy'), to_date('04-09-2017', 'dd-mm-yyyy'), null, '614784421', '063300220', 879);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (150, to_date('03-04-2012', 'dd-mm-yyyy'), to_date('29-04-2015', 'dd-mm-yyyy'), null, '688569966', '920761389', 629);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (151, to_date('12-05-2014', 'dd-mm-yyyy'), to_date('18-11-2023', 'dd-mm-yyyy'), null, '989981369', '086121419', 245);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (152, to_date('26-05-2019', 'dd-mm-yyyy'), to_date('09-06-2019', 'dd-mm-yyyy'), null, '559859523', '022601726', 195);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (153, to_date('14-04-2019', 'dd-mm-yyyy'), to_date('30-01-2021', 'dd-mm-yyyy'), null, '922607270', '915567582', 152);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (154, to_date('24-06-2022', 'dd-mm-yyyy'), to_date('08-07-2022', 'dd-mm-yyyy'), null, '843169084', '711309756', 854);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (155, to_date('25-10-2006', 'dd-mm-yyyy'), to_date('27-08-2015', 'dd-mm-yyyy'), null, '180191326', '920761389', 777);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (156, to_date('06-02-2023', 'dd-mm-yyyy'), to_date('20-02-2023', 'dd-mm-yyyy'), null, '054248733', '146137062', 69);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (157, to_date('21-10-2008', 'dd-mm-yyyy'), to_date('03-06-2014', 'dd-mm-yyyy'), null, '989570315', '849628298', 236);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (158, to_date('21-10-2006', 'dd-mm-yyyy'), to_date('22-11-2014', 'dd-mm-yyyy'), null, '905167354', '058608539', 863);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (159, to_date('04-10-2016', 'dd-mm-yyyy'), to_date('11-11-2023', 'dd-mm-yyyy'), null, '738373379', '837162122', 405);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (160, to_date('08-10-2008', 'dd-mm-yyyy'), to_date('21-10-2020', 'dd-mm-yyyy'), null, '531653197', '621314773', 791);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (161, to_date('06-10-2003', 'dd-mm-yyyy'), to_date('13-10-2019', 'dd-mm-yyyy'), null, '680540698', '014082919', 473);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (162, to_date('19-10-2018', 'dd-mm-yyyy'), to_date('31-03-2019', 'dd-mm-yyyy'), null, '511449615', '019362397', 931);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (163, to_date('30-11-2020', 'dd-mm-yyyy'), to_date('14-12-2020', 'dd-mm-yyyy'), null, '789950829', '682014481', 513);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (164, to_date('13-05-2019', 'dd-mm-yyyy'), to_date('27-05-2019', 'dd-mm-yyyy'), null, '577720618', '028592641', 550);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (165, to_date('04-01-2006', 'dd-mm-yyyy'), to_date('29-07-2011', 'dd-mm-yyyy'), null, '915923130', '055509419', 952);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (166, to_date('16-09-2009', 'dd-mm-yyyy'), to_date('25-10-2014', 'dd-mm-yyyy'), null, '803660894', '146137062', 966);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (167, to_date('02-11-2017', 'dd-mm-yyyy'), to_date('16-11-2017', 'dd-mm-yyyy'), null, '313589600', '645106048', 757);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (168, to_date('04-02-2002', 'dd-mm-yyyy'), to_date('12-11-2011', 'dd-mm-yyyy'), null, '029124580', '965000417', 509);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (169, to_date('04-10-2022', 'dd-mm-yyyy'), to_date('18-10-2022', 'dd-mm-yyyy'), null, '697531067', '072820783', 923);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (170, to_date('30-07-2009', 'dd-mm-yyyy'), to_date('22-10-2011', 'dd-mm-yyyy'), null, '523453408', '658307215', 892);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (171, to_date('01-06-2021', 'dd-mm-yyyy'), to_date('15-06-2021', 'dd-mm-yyyy'), null, '127097395', '033035228', 42);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (172, to_date('24-03-2009', 'dd-mm-yyyy'), to_date('18-08-2022', 'dd-mm-yyyy'), null, '688973370', '676285276', 643);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (173, to_date('10-01-2023', 'dd-mm-yyyy'), to_date('24-01-2023', 'dd-mm-yyyy'), null, '831042091', '189152630', 836);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (174, to_date('03-09-2020', 'dd-mm-yyyy'), to_date('17-09-2020', 'dd-mm-yyyy'), null, '239960682', '257484513', 559);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (175, to_date('02-12-2019', 'dd-mm-yyyy'), to_date('08-12-2023', 'dd-mm-yyyy'), null, '137842810', '442298493', 312);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (176, to_date('10-02-2020', 'dd-mm-yyyy'), to_date('24-02-2020', 'dd-mm-yyyy'), null, '917208879', '487301584', 188);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (177, to_date('01-04-2013', 'dd-mm-yyyy'), to_date('24-11-2021', 'dd-mm-yyyy'), null, '063528944', '555047971', 959);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (178, to_date('09-07-2007', 'dd-mm-yyyy'), to_date('01-02-2018', 'dd-mm-yyyy'), null, '322295223', '140829165', 593);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (179, to_date('12-05-2009', 'dd-mm-yyyy'), to_date('03-02-2018', 'dd-mm-yyyy'), null, '659562823', '559859523', 281);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (180, to_date('09-02-2021', 'dd-mm-yyyy'), to_date('07-10-2023', 'dd-mm-yyyy'), null, '093818015', '347276119', 471);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (181, to_date('24-06-2010', 'dd-mm-yyyy'), to_date('08-07-2010', 'dd-mm-yyyy'), null, '141166296', '578516249', 286);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (182, to_date('03-11-2008', 'dd-mm-yyyy'), to_date('06-12-2023', 'dd-mm-yyyy'), null, '740708570', '602220915', 278);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (183, to_date('30-10-2021', 'dd-mm-yyyy'), to_date('13-11-2021', 'dd-mm-yyyy'), null, '107455196', '485283160', 981);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (184, to_date('09-09-2021', 'dd-mm-yyyy'), to_date('23-09-2021', 'dd-mm-yyyy'), null, '614784421', '614782689', 213);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (185, to_date('12-08-2022', 'dd-mm-yyyy'), to_date('26-08-2022', 'dd-mm-yyyy'), null, '043939492', '920761389', 187);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (186, to_date('24-03-2010', 'dd-mm-yyyy'), to_date('09-06-2021', 'dd-mm-yyyy'), null, '418542865', '155248136', 87);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (187, to_date('18-01-2021', 'dd-mm-yyyy'), to_date('01-02-2021', 'dd-mm-yyyy'), null, '677905366', '390905524', 46);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (188, to_date('22-06-2003', 'dd-mm-yyyy'), to_date('26-12-2023', 'dd-mm-yyyy'), null, '045601319', '393777727', 823);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (189, to_date('02-03-2007', 'dd-mm-yyyy'), to_date('28-08-2015', 'dd-mm-yyyy'), null, '214335504', '077055177', 377);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (190, to_date('19-03-2009', 'dd-mm-yyyy'), to_date('09-04-2024', 'dd-mm-yyyy'), null, '175978110', '711309756', 366);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (191, to_date('31-05-2008', 'dd-mm-yyyy'), to_date('02-03-2016', 'dd-mm-yyyy'), null, '137842810', '245422235', 825);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (192, to_date('22-01-2011', 'dd-mm-yyyy'), to_date('12-09-2016', 'dd-mm-yyyy'), null, '061215635', '180966239', 356);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (193, to_date('09-12-2001', 'dd-mm-yyyy'), to_date('06-02-2011', 'dd-mm-yyyy'), null, '418350339', '485283160', 569);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (194, to_date('20-01-2019', 'dd-mm-yyyy'), to_date('08-12-2023', 'dd-mm-yyyy'), null, '107093007', '370469772', 141);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (195, to_date('01-12-2009', 'dd-mm-yyyy'), to_date('13-02-2019', 'dd-mm-yyyy'), null, '488229246', '826605920', 506);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (196, to_date('04-05-2001', 'dd-mm-yyyy'), to_date('23-11-2017', 'dd-mm-yyyy'), null, '022601726', '729801502', 469);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (197, to_date('28-02-2020', 'dd-mm-yyyy'), to_date('13-03-2020', 'dd-mm-yyyy'), null, '826540393', '682262028', 946);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (198, to_date('26-10-2011', 'dd-mm-yyyy'), to_date('07-03-2016', 'dd-mm-yyyy'), null, '039153067', '168438555', 417);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (199, to_date('15-11-2020', 'dd-mm-yyyy'), to_date('29-11-2020', 'dd-mm-yyyy'), null, '305084973', '984268974', 234);
commit;
prompt 200 records committed...
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (200, to_date('10-08-2000', 'dd-mm-yyyy'), to_date('12-01-2017', 'dd-mm-yyyy'), null, '487301584', '652120441', 525);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (201, to_date('02-09-2012', 'dd-mm-yyyy'), to_date('15-08-2020', 'dd-mm-yyyy'), null, '145366143', '257532494', 89);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (202, to_date('04-11-2021', 'dd-mm-yyyy'), to_date('18-11-2021', 'dd-mm-yyyy'), null, '697846160', '645106048', 975);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (203, to_date('08-03-2019', 'dd-mm-yyyy'), to_date('22-03-2019', 'dd-mm-yyyy'), null, '186328775', '837162122', 853);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (204, to_date('17-03-2018', 'dd-mm-yyyy'), to_date('31-03-2018', 'dd-mm-yyyy'), null, '957911531', '275681892', 299);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (205, to_date('09-08-2006', 'dd-mm-yyyy'), to_date('14-01-2011', 'dd-mm-yyyy'), null, '126770208', '186164668', 147);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (206, to_date('03-12-2012', 'dd-mm-yyyy'), to_date('11-10-2022', 'dd-mm-yyyy'), null, '917208879', '029124580', 750);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (207, to_date('22-12-2004', 'dd-mm-yyyy'), to_date('27-04-2012', 'dd-mm-yyyy'), null, '697531067', '272137266', 906);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (208, to_date('13-10-2013', 'dd-mm-yyyy'), to_date('12-05-2023', 'dd-mm-yyyy'), null, '353506388', '127352453', 537);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (209, to_date('14-01-2016', 'dd-mm-yyyy'), to_date('28-01-2016', 'dd-mm-yyyy'), null, '418542865', '191792029', 189);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (210, to_date('27-11-2021', 'dd-mm-yyyy'), to_date('11-12-2021', 'dd-mm-yyyy'), null, '029466664', '120287546', 59);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (211, to_date('27-02-2010', 'dd-mm-yyyy'), to_date('20-06-2013', 'dd-mm-yyyy'), null, '723375847', '078881161', 808);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (212, to_date('21-03-2022', 'dd-mm-yyyy'), to_date('04-04-2022', 'dd-mm-yyyy'), null, '680606541', '177902350', 770);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (213, to_date('10-11-2020', 'dd-mm-yyyy'), to_date('24-11-2020', 'dd-mm-yyyy'), null, '874752399', '951365336', 114);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (214, to_date('13-05-2009', 'dd-mm-yyyy'), to_date('27-10-2011', 'dd-mm-yyyy'), null, '149245218', '119362966', 553);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (215, to_date('28-04-2006', 'dd-mm-yyyy'), to_date('12-10-2017', 'dd-mm-yyyy'), null, '045601319', '560046205', 47);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (216, to_date('11-09-2004', 'dd-mm-yyyy'), to_date('17-09-2019', 'dd-mm-yyyy'), null, '093818015', '257532494', 762);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (217, to_date('18-05-2016', 'dd-mm-yyyy'), to_date('27-11-2023', 'dd-mm-yyyy'), null, '563934878', '448707100', 748);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (218, to_date('05-02-2008', 'dd-mm-yyyy'), to_date('07-08-2016', 'dd-mm-yyyy'), null, '322854435', '143520341', 978);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (219, to_date('26-11-2002', 'dd-mm-yyyy'), to_date('02-05-2016', 'dd-mm-yyyy'), null, '145366143', '424102835', 495);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (220, to_date('23-06-2013', 'dd-mm-yyyy'), to_date('03-07-2020', 'dd-mm-yyyy'), null, '765668671', '780840485', 235);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (221, to_date('13-12-2009', 'dd-mm-yyyy'), to_date('21-12-2011', 'dd-mm-yyyy'), null, '682014481', '986715923', 993);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (222, to_date('13-01-2011', 'dd-mm-yyyy'), to_date('27-01-2011', 'dd-mm-yyyy'), null, '989981369', '798274104', 857);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (223, to_date('31-03-2011', 'dd-mm-yyyy'), to_date('11-02-2018', 'dd-mm-yyyy'), null, '310404144', '219278525', 50);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (224, to_date('20-08-2013', 'dd-mm-yyyy'), to_date('19-08-2023', 'dd-mm-yyyy'), null, '086072867', '017131401', 267);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (225, to_date('27-04-2023', 'dd-mm-yyyy'), to_date('11-05-2023', 'dd-mm-yyyy'), null, '374339845', '461518573', 602);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (226, to_date('24-03-2021', 'dd-mm-yyyy'), to_date('07-04-2021', 'dd-mm-yyyy'), null, '097482024', '066163526', 571);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (227, to_date('12-05-2011', 'dd-mm-yyyy'), to_date('30-04-2017', 'dd-mm-yyyy'), null, '647332571', '266091930', 702);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (228, to_date('21-07-2022', 'dd-mm-yyyy'), to_date('04-08-2022', 'dd-mm-yyyy'), null, '162991219', '488229246', 113);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (229, to_date('12-02-2010', 'dd-mm-yyyy'), to_date('02-06-2020', 'dd-mm-yyyy'), null, '417953406', '555047971', 589);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (230, to_date('22-11-2012', 'dd-mm-yyyy'), to_date('14-12-2018', 'dd-mm-yyyy'), null, '770600157', '983815148', 11);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (231, to_date('17-09-2023', 'dd-mm-yyyy'), to_date('14-07-2024', 'dd-mm-yyyy'), null, '898194084', '309732749', 587);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (232, to_date('01-02-2015', 'dd-mm-yyyy'), to_date('15-02-2015', 'dd-mm-yyyy'), null, '107093007', '348351561', 530);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (233, to_date('22-02-2006', 'dd-mm-yyyy'), to_date('22-01-2017', 'dd-mm-yyyy'), null, '441162660', '028369330', 401);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (234, to_date('01-01-2016', 'dd-mm-yyyy'), to_date('15-01-2016', 'dd-mm-yyyy'), null, '031510193', '054248733', 14);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (235, to_date('26-06-2018', 'dd-mm-yyyy'), to_date('10-07-2018', 'dd-mm-yyyy'), null, '311690756', '624567221', 637);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (236, to_date('02-05-2023', 'dd-mm-yyyy'), to_date('16-05-2023', 'dd-mm-yyyy'), null, '446332100', '659345030', 603);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (237, to_date('07-09-2019', 'dd-mm-yyyy'), to_date('21-09-2019', 'dd-mm-yyyy'), null, '751666263', '799881575', 726);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (238, to_date('02-03-2008', 'dd-mm-yyyy'), to_date('29-11-2022', 'dd-mm-yyyy'), null, '045601319', '230944652', 249);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (239, to_date('12-01-2007', 'dd-mm-yyyy'), to_date('08-02-2017', 'dd-mm-yyyy'), null, '094482935', '758867042', 156);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (240, to_date('31-12-2016', 'dd-mm-yyyy'), to_date('20-01-2024', 'dd-mm-yyyy'), null, '805127954', '093818015', 34);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (241, to_date('16-10-2009', 'dd-mm-yyyy'), to_date('19-04-2010', 'dd-mm-yyyy'), null, '066613546', '545327628', 98);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (242, to_date('24-11-2005', 'dd-mm-yyyy'), to_date('24-04-2015', 'dd-mm-yyyy'), null, '260510850', '675987499', 894);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (243, to_date('28-01-2023', 'dd-mm-yyyy'), to_date('11-02-2023', 'dd-mm-yyyy'), null, '696182052', '216475555', 996);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (244, to_date('18-03-2004', 'dd-mm-yyyy'), to_date('04-07-2018', 'dd-mm-yyyy'), null, '195785327', '055509419', 334);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (245, to_date('02-01-2001', 'dd-mm-yyyy'), to_date('16-04-2021', 'dd-mm-yyyy'), null, '653774196', '327375753', 128);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (246, to_date('07-04-2020', 'dd-mm-yyyy'), to_date('09-12-2021', 'dd-mm-yyyy'), null, '664042086', '660975076', 988);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (247, to_date('27-12-2008', 'dd-mm-yyyy'), to_date('15-09-2023', 'dd-mm-yyyy'), null, '555012645', '555012645', 119);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (248, to_date('15-09-2013', 'dd-mm-yyyy'), to_date('29-09-2013', 'dd-mm-yyyy'), null, '511449615', '914751680', 67);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (249, to_date('30-05-2016', 'dd-mm-yyyy'), to_date('13-06-2016', 'dd-mm-yyyy'), null, '185553927', '747387759', 938);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (250, to_date('05-11-2008', 'dd-mm-yyyy'), to_date('06-01-2012', 'dd-mm-yyyy'), null, '696456011', '500068415', 318);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (251, to_date('20-09-2015', 'dd-mm-yyyy'), to_date('04-10-2015', 'dd-mm-yyyy'), null, '420027444', '175375438', 910);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (252, to_date('25-07-2013', 'dd-mm-yyyy'), to_date('14-01-2019', 'dd-mm-yyyy'), null, '843169084', '113036851', 212);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (253, to_date('23-03-2023', 'dd-mm-yyyy'), to_date('06-04-2023', 'dd-mm-yyyy'), null, '448707100', '866701211', 833);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (254, to_date('08-11-2000', 'dd-mm-yyyy'), to_date('21-01-2012', 'dd-mm-yyyy'), null, '136473730', '448707100', 72);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (255, to_date('15-01-2000', 'dd-mm-yyyy'), to_date('21-07-2024', 'dd-mm-yyyy'), null, '898194084', '461518573', 954);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (256, to_date('31-03-2003', 'dd-mm-yyyy'), to_date('08-01-2016', 'dd-mm-yyyy'), null, '749084891', '942977640', 636);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (257, to_date('08-06-2015', 'dd-mm-yyyy'), to_date('14-06-2019', 'dd-mm-yyyy'), null, '680540698', '701862029', 831);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (258, to_date('01-08-2002', 'dd-mm-yyyy'), to_date('13-08-2023', 'dd-mm-yyyy'), null, '803660894', '232611240', 590);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (259, to_date('29-01-2016', 'dd-mm-yyyy'), to_date('12-02-2016', 'dd-mm-yyyy'), null, '577720618', '697531067', 794);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (260, to_date('31-08-2012', 'dd-mm-yyyy'), to_date('01-10-2019', 'dd-mm-yyyy'), null, '329948220', '920761389', 595);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (261, to_date('03-10-2006', 'dd-mm-yyyy'), to_date('24-12-2011', 'dd-mm-yyyy'), null, '488229246', '220633642', 586);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (262, to_date('20-06-2008', 'dd-mm-yyyy'), to_date('03-12-2010', 'dd-mm-yyyy'), null, '107455196', '301487527', 82);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (263, to_date('13-02-2001', 'dd-mm-yyyy'), to_date('09-05-2023', 'dd-mm-yyyy'), null, '214713146', '259058467', 935);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (264, to_date('25-09-2012', 'dd-mm-yyyy'), to_date('09-10-2015', 'dd-mm-yyyy'), null, '669562483', '188258885', 248);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (265, to_date('25-05-2017', 'dd-mm-yyyy'), to_date('05-08-2018', 'dd-mm-yyyy'), null, '887892305', '259058467', 889);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (266, to_date('04-02-2004', 'dd-mm-yyyy'), to_date('07-03-2015', 'dd-mm-yyyy'), null, '311514630', '798274104', 435);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (267, to_date('21-04-2014', 'dd-mm-yyyy'), to_date('05-05-2014', 'dd-mm-yyyy'), null, '050573245', '216475555', 733);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (268, to_date('25-10-2022', 'dd-mm-yyyy'), to_date('08-11-2022', 'dd-mm-yyyy'), null, '847250676', '664089285', 620);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (269, to_date('27-10-2005', 'dd-mm-yyyy'), to_date('25-02-2019', 'dd-mm-yyyy'), null, '418350339', '528625739', 878);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (270, to_date('11-12-2016', 'dd-mm-yyyy'), to_date('25-12-2016', 'dd-mm-yyyy'), null, '847250676', '483206140', 696);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (271, to_date('21-01-2020', 'dd-mm-yyyy'), to_date('04-02-2020', 'dd-mm-yyyy'), null, '163506853', '157451231', 18);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (272, to_date('21-04-2023', 'dd-mm-yyyy'), to_date('05-05-2023', 'dd-mm-yyyy'), null, '334283784', '968200663', 135);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (273, to_date('30-04-2008', 'dd-mm-yyyy'), to_date('02-12-2012', 'dd-mm-yyyy'), null, '918067269', '014082919', 949);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (274, to_date('01-10-2023', 'dd-mm-yyyy'), to_date('15-10-2023', 'dd-mm-yyyy'), null, '803660894', '241206486', 169);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (275, to_date('16-01-2001', 'dd-mm-yyyy'), to_date('27-05-2023', 'dd-mm-yyyy'), null, '413075709', '398373857', 705);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (276, to_date('27-08-2007', 'dd-mm-yyyy'), to_date('24-12-2019', 'dd-mm-yyyy'), null, '334283784', '240939313', 327);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (277, to_date('10-11-2012', 'dd-mm-yyyy'), to_date('24-11-2012', 'dd-mm-yyyy'), null, '271730213', '185553927', 330);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (278, to_date('25-07-2015', 'dd-mm-yyyy'), to_date('21-07-2024', 'dd-mm-yyyy'), null, '898194084', '367775460', 447);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (279, to_date('05-03-2010', 'dd-mm-yyyy'), to_date('26-02-2011', 'dd-mm-yyyy'), null, '086072867', '185553927', 96);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (280, to_date('01-02-2008', 'dd-mm-yyyy'), to_date('24-10-2022', 'dd-mm-yyyy'), null, '085170682', '847250676', 320);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (281, to_date('09-02-2006', 'dd-mm-yyyy'), to_date('01-04-2023', 'dd-mm-yyyy'), null, '070289159', '274453753', 360);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (282, to_date('23-06-2001', 'dd-mm-yyyy'), to_date('25-08-2017', 'dd-mm-yyyy'), null, '680606541', '701389269', 88);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (283, to_date('20-10-2001', 'dd-mm-yyyy'), to_date('23-09-2020', 'dd-mm-yyyy'), null, '555012645', '886474743', 203);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (284, to_date('28-06-2012', 'dd-mm-yyyy'), to_date('01-12-2023', 'dd-mm-yyyy'), null, '087859207', '309732749', 371);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (285, to_date('05-04-2010', 'dd-mm-yyyy'), to_date('23-05-2015', 'dd-mm-yyyy'), null, '801792400', '984268974', 722);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (286, to_date('13-12-2000', 'dd-mm-yyyy'), to_date('21-05-2015', 'dd-mm-yyyy'), null, '989981369', '697846160', 146);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (287, to_date('09-06-2015', 'dd-mm-yyyy'), to_date('16-01-2020', 'dd-mm-yyyy'), null, '751666263', '531109735', 454);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (288, to_date('25-09-2015', 'dd-mm-yyyy'), to_date('09-10-2015', 'dd-mm-yyyy'), null, '136074808', '553241085', 936);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (289, to_date('24-04-2019', 'dd-mm-yyyy'), to_date('20-01-2023', 'dd-mm-yyyy'), null, '085170682', '789947168', 490);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (290, to_date('23-04-2011', 'dd-mm-yyyy'), to_date('15-01-2017', 'dd-mm-yyyy'), null, '304620961', '279593900', 584);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (291, to_date('19-04-2020', 'dd-mm-yyyy'), to_date('03-05-2020', 'dd-mm-yyyy'), null, '972588444', '257490434', 442);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (292, to_date('20-09-2013', 'dd-mm-yyyy'), to_date('03-11-2022', 'dd-mm-yyyy'), null, '507745420', '044973672', 58);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (293, to_date('14-06-2010', 'dd-mm-yyyy'), to_date('27-05-2015', 'dd-mm-yyyy'), null, '264847178', '490830032', 172);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (294, to_date('21-10-2008', 'dd-mm-yyyy'), to_date('01-05-2015', 'dd-mm-yyyy'), null, '811048828', '367775460', 76);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (295, to_date('11-07-2021', 'dd-mm-yyyy'), to_date('25-07-2021', 'dd-mm-yyyy'), null, '432425942', '127352453', 498);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (296, to_date('21-02-2009', 'dd-mm-yyyy'), to_date('19-10-2012', 'dd-mm-yyyy'), null, '244652438', '972588444', 886);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (297, to_date('06-12-2021', 'dd-mm-yyyy'), to_date('20-12-2021', 'dd-mm-yyyy'), null, '901820276', '746109991', 193);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (298, to_date('23-02-2023', 'dd-mm-yyyy'), to_date('09-03-2023', 'dd-mm-yyyy'), null, '574465011', '631569671', 761);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (299, to_date('11-10-2023', 'dd-mm-yyyy'), to_date('25-10-2023', 'dd-mm-yyyy'), null, '310404144', '268281389', 962);
commit;
prompt 300 records committed...
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (300, to_date('05-10-2019', 'dd-mm-yyyy'), to_date('19-10-2019', 'dd-mm-yyyy'), null, '413075709', '281102853', 399);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (301, to_date('14-03-2014', 'dd-mm-yyyy'), to_date('28-03-2014', 'dd-mm-yyyy'), null, '915701674', '684705736', 691);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (302, to_date('24-04-2021', 'dd-mm-yyyy'), to_date('08-05-2021', 'dd-mm-yyyy'), null, '735902946', '053166731', 911);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (303, to_date('21-04-2007', 'dd-mm-yyyy'), to_date('08-11-2016', 'dd-mm-yyyy'), null, '812794163', '001852633', 901);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (304, to_date('29-12-2004', 'dd-mm-yyyy'), to_date('18-02-2013', 'dd-mm-yyyy'), null, '093818015', '081383228', 711);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (305, to_date('28-09-2016', 'dd-mm-yyyy'), to_date('08-10-2016', 'dd-mm-yyyy'), null, '723375847', '701389269', 445);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (306, to_date('29-01-2003', 'dd-mm-yyyy'), to_date('12-01-2010', 'dd-mm-yyyy'), null, '350227847', '653774196', 307);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (307, to_date('23-05-2006', 'dd-mm-yyyy'), to_date('17-07-2016', 'dd-mm-yyyy'), null, '666467223', '781417795', 904);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (308, to_date('27-12-2022', 'dd-mm-yyyy'), to_date('10-01-2023', 'dd-mm-yyyy'), null, '453202055', '691006719', 852);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (309, to_date('25-04-2010', 'dd-mm-yyyy'), to_date('15-12-2015', 'dd-mm-yyyy'), null, '783055575', '485100893', 450);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (310, to_date('06-11-2011', 'dd-mm-yyyy'), to_date('04-03-2019', 'dd-mm-yyyy'), null, '329948220', '660975076', 695);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (311, to_date('08-06-2010', 'dd-mm-yyyy'), to_date('26-06-2022', 'dd-mm-yyyy'), null, '113036851', '164868085', 476);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (312, to_date('06-02-2008', 'dd-mm-yyyy'), to_date('23-01-2017', 'dd-mm-yyyy'), null, '379348654', '798632254', 31);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (313, to_date('11-09-2016', 'dd-mm-yyyy'), to_date('05-12-2016', 'dd-mm-yyyy'), null, '684705736', '909087863', 751);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (314, to_date('06-12-2020', 'dd-mm-yyyy'), to_date('20-12-2020', 'dd-mm-yyyy'), null, '614784421', '622978701', 345);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (315, to_date('19-10-2020', 'dd-mm-yyyy'), to_date('02-11-2020', 'dd-mm-yyyy'), null, '350227847', '279593900', 845);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (316, to_date('14-01-2022', 'dd-mm-yyyy'), to_date('28-01-2022', 'dd-mm-yyyy'), null, '498584448', '232611240', 645);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (317, to_date('15-10-2012', 'dd-mm-yyyy'), to_date('29-01-2014', 'dd-mm-yyyy'), null, '938313995', '011679094', 924);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (318, to_date('04-05-2022', 'dd-mm-yyyy'), to_date('18-05-2022', 'dd-mm-yyyy'), null, '350227847', '390905524', 177);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (319, to_date('13-03-2022', 'dd-mm-yyyy'), to_date('27-03-2022', 'dd-mm-yyyy'), null, '983955201', '939973048', 599);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (320, to_date('06-06-2021', 'dd-mm-yyyy'), to_date('07-10-2021', 'dd-mm-yyyy'), null, '682014481', '033035228', 873);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (321, to_date('31-05-2018', 'dd-mm-yyyy'), to_date('14-06-2018', 'dd-mm-yyyy'), null, '740708570', '951365336', 37);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (322, to_date('27-08-2017', 'dd-mm-yyyy'), to_date('19-02-2021', 'dd-mm-yyyy'), null, '077468421', '206148591', 381);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (323, to_date('19-04-2008', 'dd-mm-yyyy'), to_date('14-03-2021', 'dd-mm-yyyy'), null, '688973370', '526716833', 357);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (324, to_date('16-06-2008', 'dd-mm-yyyy'), to_date('13-10-2019', 'dd-mm-yyyy'), null, '984268974', '301487527', 494);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (325, to_date('24-05-2008', 'dd-mm-yyyy'), to_date('08-11-2021', 'dd-mm-yyyy'), null, '684705736', '025815914', 287);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (326, to_date('30-07-2015', 'dd-mm-yyyy'), to_date('13-08-2015', 'dd-mm-yyyy'), null, '128447737', '131671047', 626);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (327, to_date('08-11-2000', 'dd-mm-yyyy'), to_date('27-02-2014', 'dd-mm-yyyy'), null, '271730213', '168438555', 539);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (328, to_date('03-07-2004', 'dd-mm-yyyy'), to_date('25-01-2020', 'dd-mm-yyyy'), null, '137607044', '574465011', 675);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (329, to_date('31-07-2020', 'dd-mm-yyyy'), to_date('14-08-2020', 'dd-mm-yyyy'), null, '888279161', '025953504', 303);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (330, to_date('24-02-2012', 'dd-mm-yyyy'), to_date('13-05-2019', 'dd-mm-yyyy'), null, '765668671', '799881575', 659);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (331, to_date('23-05-2012', 'dd-mm-yyyy'), to_date('16-12-2018', 'dd-mm-yyyy'), null, '914006622', '973642055', 699);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (332, to_date('09-05-2016', 'dd-mm-yyyy'), to_date('27-04-2020', 'dd-mm-yyyy'), null, '851304587', '949649669', 431);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (333, to_date('07-09-2003', 'dd-mm-yyyy'), to_date('31-10-2021', 'dd-mm-yyyy'), null, '322854435', '942977640', 227);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (334, to_date('08-12-2003', 'dd-mm-yyyy'), to_date('16-09-2011', 'dd-mm-yyyy'), null, '456794713', '367706464', 121);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (335, to_date('08-06-2011', 'dd-mm-yyyy'), to_date('17-05-2016', 'dd-mm-yyyy'), null, '063528944', '346411238', 727);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (336, to_date('21-10-2001', 'dd-mm-yyyy'), to_date('27-11-2018', 'dd-mm-yyyy'), null, '878919173', '348648244', 638);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (337, to_date('03-11-2001', 'dd-mm-yyyy'), to_date('15-01-2019', 'dd-mm-yyyy'), null, '922607270', '937829536', 71);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (338, to_date('13-09-2006', 'dd-mm-yyyy'), to_date('06-08-2017', 'dd-mm-yyyy'), null, '677905366', '130969218', 183);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (339, to_date('23-03-2021', 'dd-mm-yyyy'), to_date('06-04-2021', 'dd-mm-yyyy'), null, '688973370', '559859523', 386);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (340, to_date('19-12-2016', 'dd-mm-yyyy'), to_date('02-01-2017', 'dd-mm-yyyy'), null, '574465011', '072820783', 414);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (341, to_date('09-03-2023', 'dd-mm-yyyy'), to_date('23-03-2023', 'dd-mm-yyyy'), null, '066516192', '251808841', 528);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (342, to_date('13-01-2009', 'dd-mm-yyyy'), to_date('25-04-2014', 'dd-mm-yyyy'), null, '033035228', '745672175', 185);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (343, to_date('07-12-2023', 'dd-mm-yyyy'), to_date('21-12-2023', 'dd-mm-yyyy'), null, '782812737', '146137062', 138);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (344, to_date('13-01-2020', 'dd-mm-yyyy'), to_date('27-01-2020', 'dd-mm-yyyy'), null, '511449615', '720106083', 406);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (345, to_date('14-08-2020', 'dd-mm-yyyy'), to_date('11-12-2023', 'dd-mm-yyyy'), null, '523453408', '706196502', 995);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (346, to_date('22-12-2023', 'dd-mm-yyyy'), to_date('05-01-2024', 'dd-mm-yyyy'), null, '494302245', '691006719', 154);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (347, to_date('05-07-2023', 'dd-mm-yyyy'), to_date('19-07-2023', 'dd-mm-yyyy'), null, '396904603', '066163526', 647);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (348, to_date('12-09-2021', 'dd-mm-yyyy'), to_date('26-09-2021', 'dd-mm-yyyy'), null, '800071003', '252004653', 674);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (349, to_date('10-07-2000', 'dd-mm-yyyy'), to_date('03-07-2010', 'dd-mm-yyyy'), null, '322854435', '438188432', 850);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (350, to_date('20-08-2020', 'dd-mm-yyyy'), to_date('03-09-2020', 'dd-mm-yyyy'), null, '054248733', '983815148', 764);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (351, to_date('17-01-2023', 'dd-mm-yyyy'), to_date('31-01-2023', 'dd-mm-yyyy'), null, '159620386', '240939313', 685);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (352, to_date('18-08-2019', 'dd-mm-yyyy'), to_date('01-09-2019', 'dd-mm-yyyy'), null, '238684624', '706196502', 81);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (353, to_date('06-03-2016', 'dd-mm-yyyy'), to_date('20-03-2016', 'dd-mm-yyyy'), null, '063528944', '899786232', 1000);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (354, to_date('01-03-2004', 'dd-mm-yyyy'), to_date('08-12-2022', 'dd-mm-yyyy'), null, '499600585', '983815148', 555);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (355, to_date('13-02-2016', 'dd-mm-yyyy'), to_date('14-03-2016', 'dd-mm-yyyy'), null, '766598824', '191792029', 483);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (356, to_date('13-11-2007', 'dd-mm-yyyy'), to_date('01-09-2013', 'dd-mm-yyyy'), null, '188284365', '677097969', 718);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (357, to_date('26-06-2007', 'dd-mm-yyyy'), to_date('21-05-2016', 'dd-mm-yyyy'), null, '855053927', '245272383', 743);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (358, to_date('13-05-2005', 'dd-mm-yyyy'), to_date('14-01-2018', 'dd-mm-yyyy'), null, '487301584', '376926882', 75);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (359, to_date('28-06-2014', 'dd-mm-yyyy'), to_date('12-07-2014', 'dd-mm-yyyy'), null, '560046205', '141376208', 519);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (360, to_date('16-11-2015', 'dd-mm-yyyy'), to_date('28-09-2023', 'dd-mm-yyyy'), null, '498584448', '417953406', 616);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (361, to_date('21-05-2001', 'dd-mm-yyyy'), to_date('13-07-2011', 'dd-mm-yyyy'), null, '374339845', '021781827', 326);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (362, to_date('19-02-2020', 'dd-mm-yyyy'), to_date('04-03-2020', 'dd-mm-yyyy'), null, '127097395', '953469588', 251);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (363, to_date('07-08-2007', 'dd-mm-yyyy'), to_date('25-06-2015', 'dd-mm-yyyy'), to_date('07-07-2024 12:45:55', 'dd-mm-yyyy hh24:mi:ss'), '013427448', '909087863', 922);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (364, to_date('11-04-2022', 'dd-mm-yyyy'), to_date('25-04-2022', 'dd-mm-yyyy'), null, '214713146', '915372180', 615);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (365, to_date('09-08-2015', 'dd-mm-yyyy'), to_date('01-05-2024', 'dd-mm-yyyy'), null, '367985568', '638414377', 350);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (366, to_date('03-09-2009', 'dd-mm-yyyy'), to_date('20-03-2020', 'dd-mm-yyyy'), null, '751666263', '851278188', 822);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (367, to_date('14-07-2017', 'dd-mm-yyyy'), to_date('16-11-2020', 'dd-mm-yyyy'), null, '086072867', '915372180', 143);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (368, to_date('29-10-2014', 'dd-mm-yyyy'), to_date('21-12-2018', 'dd-mm-yyyy'), null, '022601726', '631487255', 449);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (369, to_date('17-05-2019', 'dd-mm-yyyy'), to_date('31-05-2019', 'dd-mm-yyyy'), null, '856216050', '280673575', 859);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (370, to_date('27-08-2007', 'dd-mm-yyyy'), to_date('12-04-2022', 'dd-mm-yyyy'), null, '454626264', '917553275', 102);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (371, to_date('21-10-2014', 'dd-mm-yyyy'), to_date('26-09-2022', 'dd-mm-yyyy'), null, '082415344', '379348654', 926);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (372, to_date('22-09-2014', 'dd-mm-yyyy'), to_date('07-08-2024', 'dd-mm-yyyy'), null, '898194084', '279175065', 407);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (373, to_date('15-12-2018', 'dd-mm-yyyy'), to_date('29-12-2018', 'dd-mm-yyyy'), null, '061215635', '628942053', 802);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (374, to_date('11-08-2022', 'dd-mm-yyyy'), to_date('25-08-2022', 'dd-mm-yyyy'), null, '725276037', '311246059', 354);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (375, to_date('17-01-2022', 'dd-mm-yyyy'), to_date('31-01-2022', 'dd-mm-yyyy'), null, '871507308', '490830032', 508);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (376, to_date('10-06-2008', 'dd-mm-yyyy'), to_date('20-02-2016', 'dd-mm-yyyy'), null, '311690756', '703815502', 784);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (377, to_date('25-08-2000', 'dd-mm-yyyy'), to_date('21-11-2010', 'dd-mm-yyyy'), null, '914006622', '319029281', 811);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (378, to_date('16-07-2005', 'dd-mm-yyyy'), to_date('31-10-2013', 'dd-mm-yyyy'), null, '334283784', '469016250', 865);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (379, to_date('16-08-2016', 'dd-mm-yyyy'), to_date('25-03-2018', 'dd-mm-yyyy'), null, '305084973', '086072867', 669);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (380, to_date('09-03-2006', 'dd-mm-yyyy'), to_date('02-03-2015', 'dd-mm-yyyy'), null, '507745420', '736410796', 163);
insert into BOOKLENDING (lendingid, lendingdate, duedate, returndate, clientid, librarianid, copyid)
values (381, to_date('18-04-2016', 'dd-mm-yyyy'), to_date('27-05-2022', 'dd-mm-yyyy'), null, '453202055', '251808841', 488);
commit;
prompt 382 records loaded
prompt Loading BOOK_AUTHOR...
insert into BOOK_AUTHOR (author, bookid)
values ('Pat-Humphrey', 231);
insert into BOOK_AUTHOR (author, bookid)
values ('Patrick-Carrey', 446);
insert into BOOK_AUTHOR (author, bookid)
values ('Patrick-Devine', 73);
insert into BOOK_AUTHOR (author, bookid)
values ('Patti-Gill', 165);
insert into BOOK_AUTHOR (author, bookid)
values ('Penelope-Cocker', 166);
insert into BOOK_AUTHOR (author, bookid)
values ('Penelope-Witt', 417);
insert into BOOK_AUTHOR (author, bookid)
values ('Phil-Cox', 208);
insert into BOOK_AUTHOR (author, bookid)
values ('Phil-Quatro', 483);
insert into BOOK_AUTHOR (author, bookid)
values ('Philip-Herrmann', 42);
insert into BOOK_AUTHOR (author, bookid)
values ('Philip-Stevens', 275);
insert into BOOK_AUTHOR (author, bookid)
values ('Phoebe-Harnes', 296);
insert into BOOK_AUTHOR (author, bookid)
values ('Phoebe-Kramer', 74);
insert into BOOK_AUTHOR (author, bookid)
values ('Phoebe-Payton', 146);
insert into BOOK_AUTHOR (author, bookid)
values ('Pierce-McKean', 72);
insert into BOOK_AUTHOR (author, bookid)
values ('Praga-Brandt', 358);
insert into BOOK_AUTHOR (author, bookid)
values ('Queen-Fichtner', 384);
insert into BOOK_AUTHOR (author, bookid)
values ('Queen-Neuwirth', 30);
insert into BOOK_AUTHOR (author, bookid)
values ('Quentin-Statham', 330);
insert into BOOK_AUTHOR (author, bookid)
values ('Rachael-Rodgers', 399);
insert into BOOK_AUTHOR (author, bookid)
values ('Rachel-Cassidy', 208);
insert into BOOK_AUTHOR (author, bookid)
values ('Rachel-Crouch', 176);
insert into BOOK_AUTHOR (author, bookid)
values ('Rachel-Wong', 420);
insert into BOOK_AUTHOR (author, bookid)
values ('Rachid-Baldwin', 236);
insert into BOOK_AUTHOR (author, bookid)
values ('Rachid-Giannini', 335);
insert into BOOK_AUTHOR (author, bookid)
values ('Rachid-Puckett', 381);
insert into BOOK_AUTHOR (author, bookid)
values ('Radney-Gano', 59);
insert into BOOK_AUTHOR (author, bookid)
values ('Ralph-Pryce', 235);
insert into BOOK_AUTHOR (author, bookid)
values ('Ralph-Weller', 80);
insert into BOOK_AUTHOR (author, bookid)
values ('Ramsey-Sinise', 311);
insert into BOOK_AUTHOR (author, bookid)
values ('Randall-McBride', 115);
insert into BOOK_AUTHOR (author, bookid)
values ('Raul-Van Shelton', 19);
insert into BOOK_AUTHOR (author, bookid)
values ('Rawlins-Dorn', 419);
insert into BOOK_AUTHOR (author, bookid)
values ('Ray-Benson', 179);
insert into BOOK_AUTHOR (author, bookid)
values ('Ray-Rebhorn', 84);
insert into BOOK_AUTHOR (author, bookid)
values ('Raymond-Ledger', 29);
insert into BOOK_AUTHOR (author, bookid)
values ('Reese-O''Keefe', 236);
insert into BOOK_AUTHOR (author, bookid)
values ('Remy-Cromwell', 474);
insert into BOOK_AUTHOR (author, bookid)
values ('Rene-Freeman', 29);
insert into BOOK_AUTHOR (author, bookid)
values ('Ricardo-Applegate', 383);
insert into BOOK_AUTHOR (author, bookid)
values ('Ricardo-Raitt', 94);
insert into BOOK_AUTHOR (author, bookid)
values ('Rich-Mantegna', 374);
insert into BOOK_AUTHOR (author, bookid)
values ('Richard-Whitmore', 326);
insert into BOOK_AUTHOR (author, bookid)
values ('Richie-Blair', 461);
insert into BOOK_AUTHOR (author, bookid)
values ('Rick-Davison', 25);
insert into BOOK_AUTHOR (author, bookid)
values ('Rickie-Brando', 381);
insert into BOOK_AUTHOR (author, bookid)
values ('Rickie-Hagar', 406);
insert into BOOK_AUTHOR (author, bookid)
values ('Rickie-Orton', 51);
insert into BOOK_AUTHOR (author, bookid)
values ('Rik-MacIsaac', 115);
insert into BOOK_AUTHOR (author, bookid)
values ('Rita-Cara', 374);
insert into BOOK_AUTHOR (author, bookid)
values ('Ritchie-Faithfull', 139);
insert into BOOK_AUTHOR (author, bookid)
values ('Rob-Malkovich', 313);
insert into BOOK_AUTHOR (author, bookid)
values ('Rob-Stampley', 229);
insert into BOOK_AUTHOR (author, bookid)
values ('Robbie-Carlyle', 390);
insert into BOOK_AUTHOR (author, bookid)
values ('Robbie-Randal', 145);
insert into BOOK_AUTHOR (author, bookid)
values ('Robby-Atkins', 66);
insert into BOOK_AUTHOR (author, bookid)
values ('Robby-Sedaka', 210);
insert into BOOK_AUTHOR (author, bookid)
values ('Robby-Sylvian', 317);
insert into BOOK_AUTHOR (author, bookid)
values ('Robin-Gallant', 219);
insert into BOOK_AUTHOR (author, bookid)
values ('Robin-McCain', 99);
insert into BOOK_AUTHOR (author, bookid)
values ('Robin-Parsons', 218);
insert into BOOK_AUTHOR (author, bookid)
values ('Rodney-Davidson', 59);
insert into BOOK_AUTHOR (author, bookid)
values ('Ron-Brickell', 311);
insert into BOOK_AUTHOR (author, bookid)
values ('Ronnie-Lennox', 216);
insert into BOOK_AUTHOR (author, bookid)
values ('Rory-Daniels', 398);
insert into BOOK_AUTHOR (author, bookid)
values ('Rory-Senior', 345);
insert into BOOK_AUTHOR (author, bookid)
values ('Rosanna-Singh', 340);
insert into BOOK_AUTHOR (author, bookid)
values ('Rueben-Bale', 430);
insert into BOOK_AUTHOR (author, bookid)
values ('Rufus-Mirren', 346);
insert into BOOK_AUTHOR (author, bookid)
values ('Rupert-Kadison', 141);
insert into BOOK_AUTHOR (author, bookid)
values ('Russell-Klein', 193);
insert into BOOK_AUTHOR (author, bookid)
values ('Saffron-Kapanka', 490);
insert into BOOK_AUTHOR (author, bookid)
values ('Saffron-Van Damme', 344);
insert into BOOK_AUTHOR (author, bookid)
values ('Sally-Dzundza', 429);
insert into BOOK_AUTHOR (author, bookid)
values ('Sander-Costa', 262);
insert into BOOK_AUTHOR (author, bookid)
values ('Sarah-Rush', 468);
insert into BOOK_AUTHOR (author, bookid)
values ('Shannon-Belushi', 191);
insert into BOOK_AUTHOR (author, bookid)
values ('Shannyn-Ammons', 229);
insert into BOOK_AUTHOR (author, bookid)
values ('Sharon-Pleasure', 11);
insert into BOOK_AUTHOR (author, bookid)
values ('Shelby-Nielsen', 144);
insert into BOOK_AUTHOR (author, bookid)
values ('Simon-Furay', 26);
insert into BOOK_AUTHOR (author, bookid)
values ('Sinead-Tsettos', 256);
insert into BOOK_AUTHOR (author, bookid)
values ('Sona-Holly', 160);
insert into BOOK_AUTHOR (author, bookid)
values ('Sona-Raybon', 157);
insert into BOOK_AUTHOR (author, bookid)
values ('Sonny-Benson', 225);
insert into BOOK_AUTHOR (author, bookid)
values ('Stellan-Zeta-Jones', 61);
insert into BOOK_AUTHOR (author, bookid)
values ('Stephen-Parm', 168);
insert into BOOK_AUTHOR (author, bookid)
values ('Steve-Brosnan', 270);
insert into BOOK_AUTHOR (author, bookid)
values ('Steve-Whitaker', 450);
insert into BOOK_AUTHOR (author, bookid)
values ('Steven-Def', 341);
insert into BOOK_AUTHOR (author, bookid)
values ('Stevie-Chambers', 270);
insert into BOOK_AUTHOR (author, bookid)
values ('Stevie-Winstone', 268);
insert into BOOK_AUTHOR (author, bookid)
values ('Suzi-Stone', 177);
insert into BOOK_AUTHOR (author, bookid)
values ('Tal-Lynne', 494);
insert into BOOK_AUTHOR (author, bookid)
values ('Tamala-Bening', 432);
insert into BOOK_AUTHOR (author, bookid)
values ('Tanya-Cox', 464);
insert into BOOK_AUTHOR (author, bookid)
values ('Tara-Brooke', 170);
insert into BOOK_AUTHOR (author, bookid)
values ('Tara-Neeson', 164);
insert into BOOK_AUTHOR (author, bookid)
values ('Tara-Sherman', 382);
insert into BOOK_AUTHOR (author, bookid)
values ('Tara-Simpson', 156);
insert into BOOK_AUTHOR (author, bookid)
values ('Taryn-Hingle', 474);
commit;
prompt 100 records committed...
insert into BOOK_AUTHOR (author, bookid)
values ('Taryn-Ripley', 100);
insert into BOOK_AUTHOR (author, bookid)
values ('Taye-Michaels', 385);
insert into BOOK_AUTHOR (author, bookid)
values ('Tcheky-Olyphant', 438);
insert into BOOK_AUTHOR (author, bookid)
values ('Tea-Pryce', 214);
insert into BOOK_AUTHOR (author, bookid)
values ('Tea-Sellers', 230);
insert into BOOK_AUTHOR (author, bookid)
values ('Teena-Clarkson', 323);
insert into BOOK_AUTHOR (author, bookid)
values ('Teena-Jane', 148);
insert into BOOK_AUTHOR (author, bookid)
values ('Teena-Jovovich', 250);
insert into BOOK_AUTHOR (author, bookid)
values ('Terence-Dafoe', 103);
insert into BOOK_AUTHOR (author, bookid)
values ('Terence-Davies', 208);
insert into BOOK_AUTHOR (author, bookid)
values ('Terence-Weisberg', 162);
insert into BOOK_AUTHOR (author, bookid)
values ('Terrence-Carrack', 309);
insert into BOOK_AUTHOR (author, bookid)
values ('Terri-Del Toro', 340);
insert into BOOK_AUTHOR (author, bookid)
values ('Thelma-Cartlidge', 162);
insert into BOOK_AUTHOR (author, bookid)
values ('Thomas-Browne', 171);
insert into BOOK_AUTHOR (author, bookid)
values ('Thomas-Depp', 109);
insert into BOOK_AUTHOR (author, bookid)
values ('Thomas-Hughes', 4);
insert into BOOK_AUTHOR (author, bookid)
values ('Thomas-Rispoli', 16);
insert into BOOK_AUTHOR (author, bookid)
values ('Thomas-Ryan', 483);
insert into BOOK_AUTHOR (author, bookid)
values ('Timothy-Lovitz', 267);
insert into BOOK_AUTHOR (author, bookid)
values ('Todd-Rawls', 43);
insert into BOOK_AUTHOR (author, bookid)
values ('Tom-Gibbons', 402);
insert into BOOK_AUTHOR (author, bookid)
values ('Tori-Langella', 427);
insert into BOOK_AUTHOR (author, bookid)
values ('Toshiro-Englund', 59);
insert into BOOK_AUTHOR (author, bookid)
values ('Trace-Bugnon', 223);
insert into BOOK_AUTHOR (author, bookid)
values ('Trace-Holiday', 323);
insert into BOOK_AUTHOR (author, bookid)
values ('Tracy-Conley', 103);
insert into BOOK_AUTHOR (author, bookid)
values ('Tracy-Plummer', 401);
insert into BOOK_AUTHOR (author, bookid)
values ('Trick-Rock', 212);
insert into BOOK_AUTHOR (author, bookid)
values ('Trini-Dunn', 125);
insert into BOOK_AUTHOR (author, bookid)
values ('Trini-Purefoy', 213);
insert into BOOK_AUTHOR (author, bookid)
values ('Trini-Vega', 253);
insert into BOOK_AUTHOR (author, bookid)
values ('Ty-Flemyng', 450);
insert into BOOK_AUTHOR (author, bookid)
values ('Tzi-Suchet', 470);
insert into BOOK_AUTHOR (author, bookid)
values ('Udo-Goldberg', 404);
insert into BOOK_AUTHOR (author, bookid)
values ('Vanessa-Dawson', 472);
insert into BOOK_AUTHOR (author, bookid)
values ('Vanessa-Parker', 348);
insert into BOOK_AUTHOR (author, bookid)
values ('Vertical-Irving', 214);
insert into BOOK_AUTHOR (author, bookid)
values ('Veruca-Gibson', 97);
insert into BOOK_AUTHOR (author, bookid)
values ('Veruca-Maguire', 169);
insert into BOOK_AUTHOR (author, bookid)
values ('Veruca-Waits', 483);
insert into BOOK_AUTHOR (author, bookid)
values ('Victor-Ali', 6);
insert into BOOK_AUTHOR (author, bookid)
values ('Victoria-Murdock', 156);
insert into BOOK_AUTHOR (author, bookid)
values ('Vin-Dushku', 243);
insert into BOOK_AUTHOR (author, bookid)
values ('Vince-Keaton', 262);
insert into BOOK_AUTHOR (author, bookid)
values ('Vince-Pleasure', 3);
insert into BOOK_AUTHOR (author, bookid)
values ('Vincent-Idol', 81);
insert into BOOK_AUTHOR (author, bookid)
values ('Ving-Witt', 258);
insert into BOOK_AUTHOR (author, bookid)
values ('Vondie-Gyllenhaal', 196);
insert into BOOK_AUTHOR (author, bookid)
values ('Wade-Idol', 435);
insert into BOOK_AUTHOR (author, bookid)
values ('Wallace-Chapman', 354);
insert into BOOK_AUTHOR (author, bookid)
values ('Wang-Swayze', 420);
insert into BOOK_AUTHOR (author, bookid)
values ('Wayman-Cox', 461);
insert into BOOK_AUTHOR (author, bookid)
values ('Wayman-Taha', 422);
insert into BOOK_AUTHOR (author, bookid)
values ('Wes-Emmett', 417);
insert into BOOK_AUTHOR (author, bookid)
values ('Wesley-Chaykin', 305);
insert into BOOK_AUTHOR (author, bookid)
values ('Will-Hawthorne', 134);
insert into BOOK_AUTHOR (author, bookid)
values ('Will-Utada', 127);
insert into BOOK_AUTHOR (author, bookid)
values ('Willem-Macy', 104);
insert into BOOK_AUTHOR (author, bookid)
values ('William-Diggs', 488);
insert into BOOK_AUTHOR (author, bookid)
values ('Willie-Adler', 493);
insert into BOOK_AUTHOR (author, bookid)
values ('Willie-Molina', 72);
insert into BOOK_AUTHOR (author, bookid)
values ('Winona-Cattrall', 342);
insert into BOOK_AUTHOR (author, bookid)
values ('Winona-Sizemore', 444);
insert into BOOK_AUTHOR (author, bookid)
values ('Winona-Stigers', 218);
insert into BOOK_AUTHOR (author, bookid)
values ('Yolanda-Harrelson', 484);
insert into BOOK_AUTHOR (author, bookid)
values ('Yolanda-Paltrow', 43);
insert into BOOK_AUTHOR (author, bookid)
values ('Aaron-Belushi', 170);
insert into BOOK_AUTHOR (author, bookid)
values ('Aaron-Cook', 393);
insert into BOOK_AUTHOR (author, bookid)
values ('Adrien-Plowright', 66);
insert into BOOK_AUTHOR (author, bookid)
values ('Aidan-Gaines', 48);
insert into BOOK_AUTHOR (author, bookid)
values ('Aidan-Lofgren', 338);
insert into BOOK_AUTHOR (author, bookid)
values ('Aimee-Wayans', 432);
insert into BOOK_AUTHOR (author, bookid)
values ('Al-Tempest', 246);
insert into BOOK_AUTHOR (author, bookid)
values ('Alannah-Douglas', 166);
insert into BOOK_AUTHOR (author, bookid)
values ('Albert-Martin', 390);
insert into BOOK_AUTHOR (author, bookid)
values ('Albertina-Amos', 483);
insert into BOOK_AUTHOR (author, bookid)
values ('Albertina-Frampton', 297);
insert into BOOK_AUTHOR (author, bookid)
values ('Alessandro-Arnold', 168);
insert into BOOK_AUTHOR (author, bookid)
values ('Alex-Fender', 264);
insert into BOOK_AUTHOR (author, bookid)
values ('Alfie-Herrmann', 43);
insert into BOOK_AUTHOR (author, bookid)
values ('Alfie-Kudrow', 251);
insert into BOOK_AUTHOR (author, bookid)
values ('Alfred-Downey', 246);
insert into BOOK_AUTHOR (author, bookid)
values ('Alfred-Kirkwood', 187);
insert into BOOK_AUTHOR (author, bookid)
values ('Alice-Gertner', 429);
insert into BOOK_AUTHOR (author, bookid)
values ('Alicia-Sample', 357);
insert into BOOK_AUTHOR (author, bookid)
values ('Allison-Sample', 99);
insert into BOOK_AUTHOR (author, bookid)
values ('Amanda-Lipnicki', 164);
insert into BOOK_AUTHOR (author, bookid)
values ('Amy-Fiorentino', 432);
insert into BOOK_AUTHOR (author, bookid)
values ('Andre-Liu', 464);
insert into BOOK_AUTHOR (author, bookid)
values ('Andrea-Cara', 493);
insert into BOOK_AUTHOR (author, bookid)
values ('Andrea-Sinise', 274);
insert into BOOK_AUTHOR (author, bookid)
values ('Andrew-Azaria', 398);
insert into BOOK_AUTHOR (author, bookid)
values ('Andy-Larter', 308);
insert into BOOK_AUTHOR (author, bookid)
values ('Ani-Summer', 274);
insert into BOOK_AUTHOR (author, bookid)
values ('Ann-Loring', 397);
insert into BOOK_AUTHOR (author, bookid)
values ('Anna-Williams', 84);
insert into BOOK_AUTHOR (author, bookid)
values ('Anne-Cruz', 397);
insert into BOOK_AUTHOR (author, bookid)
values ('Anne-Tempest', 177);
insert into BOOK_AUTHOR (author, bookid)
values ('Annette-Evanswood', 218);
commit;
prompt 200 records committed...
insert into BOOK_AUTHOR (author, bookid)
values ('Annie-Williams', 107);
insert into BOOK_AUTHOR (author, bookid)
values ('Anthony-Cash', 151);
insert into BOOK_AUTHOR (author, bookid)
values ('Antonio-Berkeley', 257);
insert into BOOK_AUTHOR (author, bookid)
values ('Antonio-Reid', 369);
insert into BOOK_AUTHOR (author, bookid)
values ('Armand-Perrineau', 346);
insert into BOOK_AUTHOR (author, bookid)
values ('Arnold-Coe', 156);
insert into BOOK_AUTHOR (author, bookid)
values ('Arnold-Moffat', 355);
insert into BOOK_AUTHOR (author, bookid)
values ('Arnold-Torres', 426);
insert into BOOK_AUTHOR (author, bookid)
values ('Art-Giannini', 32);
insert into BOOK_AUTHOR (author, bookid)
values ('Art-Solido', 2);
insert into BOOK_AUTHOR (author, bookid)
values ('Arturo-Solido', 450);
insert into BOOK_AUTHOR (author, bookid)
values ('Ashley-Jackson', 242);
insert into BOOK_AUTHOR (author, bookid)
values ('Ashley-Lucien', 100);
insert into BOOK_AUTHOR (author, bookid)
values ('Ashton-Langella', 333);
insert into BOOK_AUTHOR (author, bookid)
values ('Austin-Loeb', 116);
insert into BOOK_AUTHOR (author, bookid)
values ('Avenged-McPherson', 149);
insert into BOOK_AUTHOR (author, bookid)
values ('Avril-Brody', 278);
insert into BOOK_AUTHOR (author, bookid)
values ('Barbara-Dench', 30);
insert into BOOK_AUTHOR (author, bookid)
values ('Barbara-Page', 100);
insert into BOOK_AUTHOR (author, bookid)
values ('Bebe-Pierce', 260);
insert into BOOK_AUTHOR (author, bookid)
values ('Belinda-Rifkin', 344);
insert into BOOK_AUTHOR (author, bookid)
values ('Benicio-Zellweger', 435);
insert into BOOK_AUTHOR (author, bookid)
values ('Benjamin-Mohr', 483);
insert into BOOK_AUTHOR (author, bookid)
values ('Benjamin-Morton', 428);
insert into BOOK_AUTHOR (author, bookid)
values ('Bernard-Levy', 286);
insert into BOOK_AUTHOR (author, bookid)
values ('Bernie-Furtado', 246);
insert into BOOK_AUTHOR (author, bookid)
values ('Bette-D''Onofrio', 175);
insert into BOOK_AUTHOR (author, bookid)
values ('Bette-Kretschmann', 54);
insert into BOOK_AUTHOR (author, bookid)
values ('Beverley-McKennitt', 135);
insert into BOOK_AUTHOR (author, bookid)
values ('Beverley-Russo', 143);
insert into BOOK_AUTHOR (author, bookid)
values ('Bill-Preston', 62);
insert into BOOK_AUTHOR (author, bookid)
values ('Bill-Robards', 440);
insert into BOOK_AUTHOR (author, bookid)
values ('Billy-Ponty', 293);
insert into BOOK_AUTHOR (author, bookid)
values ('Bob-DeVito', 146);
insert into BOOK_AUTHOR (author, bookid)
values ('Bobbi-Cronin', 404);
insert into BOOK_AUTHOR (author, bookid)
values ('Bobbi-Hedaya', 306);
insert into BOOK_AUTHOR (author, bookid)
values ('Bobby-Freeman', 116);
insert into BOOK_AUTHOR (author, bookid)
values ('Bonnie-Dupree', 352);
insert into BOOK_AUTHOR (author, bookid)
values ('Boyd-Mac', 334);
insert into BOOK_AUTHOR (author, bookid)
values ('Boyd-Platt', 199);
insert into BOOK_AUTHOR (author, bookid)
values ('Boz-Gambon', 329);
insert into BOOK_AUTHOR (author, bookid)
values ('Bradley-Lorenz', 226);
insert into BOOK_AUTHOR (author, bookid)
values ('Bradley-Ryder', 89);
insert into BOOK_AUTHOR (author, bookid)
values ('Breckin-Waits', 224);
insert into BOOK_AUTHOR (author, bookid)
values ('Brenda-Baranski', 45);
insert into BOOK_AUTHOR (author, bookid)
values ('Brenda-Kingsley', 473);
insert into BOOK_AUTHOR (author, bookid)
values ('Brenda-Pullman', 164);
insert into BOOK_AUTHOR (author, bookid)
values ('Brendan-Henriksen', 432);
insert into BOOK_AUTHOR (author, bookid)
values ('Brendan-Janssen', 43);
insert into BOOK_AUTHOR (author, bookid)
values ('Brendan-McClinton', 214);
insert into BOOK_AUTHOR (author, bookid)
values ('Bridget-Arnold', 317);
insert into BOOK_AUTHOR (author, bookid)
values ('Bridgette-Gilley', 193);
insert into BOOK_AUTHOR (author, bookid)
values ('Brittany-Gaines', 499);
insert into BOOK_AUTHOR (author, bookid)
values ('Brittany-Teng', 347);
insert into BOOK_AUTHOR (author, bookid)
values ('Brooke-Chaykin', 409);
insert into BOOK_AUTHOR (author, bookid)
values ('Brooke-Hewett', 256);
insert into BOOK_AUTHOR (author, bookid)
values ('Brothers-Jovovich', 184);
insert into BOOK_AUTHOR (author, bookid)
values ('Bruce-Emmerich', 248);
insert into BOOK_AUTHOR (author, bookid)
values ('Bryan-Hughes', 391);
insert into BOOK_AUTHOR (author, bookid)
values ('Buddy-Thorton', 438);
insert into BOOK_AUTHOR (author, bookid)
values ('Buffy-Jolie', 123);
insert into BOOK_AUTHOR (author, bookid)
values ('Busta-Flemyng', 295);
insert into BOOK_AUTHOR (author, bookid)
values ('Campbell-Nakai', 332);
insert into BOOK_AUTHOR (author, bookid)
values ('Campbell-Postlethwaite', 1);
insert into BOOK_AUTHOR (author, bookid)
values ('Carl-Ball', 149);
insert into BOOK_AUTHOR (author, bookid)
values ('Carla-Shearer', 424);
insert into BOOK_AUTHOR (author, bookid)
values ('Carlene-Kurtz', 90);
insert into BOOK_AUTHOR (author, bookid)
values ('Carole-McGill', 395);
insert into BOOK_AUTHOR (author, bookid)
values ('Carole-Mifune', 334);
insert into BOOK_AUTHOR (author, bookid)
values ('Caroline-Joli', 281);
insert into BOOK_AUTHOR (author, bookid)
values ('Carolyn-Tripplehorn', 27);
insert into BOOK_AUTHOR (author, bookid)
values ('Catherine-Jackson', 27);
insert into BOOK_AUTHOR (author, bookid)
values ('Catherine-Speaks', 248);
insert into BOOK_AUTHOR (author, bookid)
values ('Celia-Costa', 139);
insert into BOOK_AUTHOR (author, bookid)
values ('Cevin-Walker', 388);
insert into BOOK_AUTHOR (author, bookid)
values ('Chaka-Koteas', 20);
insert into BOOK_AUTHOR (author, bookid)
values ('Chaka-Saucedo', 117);
insert into BOOK_AUTHOR (author, bookid)
values ('Charlize-De Niro', 192);
insert into BOOK_AUTHOR (author, bookid)
values ('Charlize-McLean', 472);
insert into BOOK_AUTHOR (author, bookid)
values ('Chazz-Hershey', 219);
insert into BOOK_AUTHOR (author, bookid)
values ('Chazz-Rush', 224);
insert into BOOK_AUTHOR (author, bookid)
values ('Cheech-Flemyng', 499);
insert into BOOK_AUTHOR (author, bookid)
values ('Cheech-Sinise', 262);
insert into BOOK_AUTHOR (author, bookid)
values ('Chely-Sobieski', 29);
insert into BOOK_AUTHOR (author, bookid)
values ('Cheryl-Henriksen', 400);
insert into BOOK_AUTHOR (author, bookid)
values ('Chet-Holmes', 483);
insert into BOOK_AUTHOR (author, bookid)
values ('Chi-O''Donnell', 420);
insert into BOOK_AUTHOR (author, bookid)
values ('Chloe-Carlisle', 407);
insert into BOOK_AUTHOR (author, bookid)
values ('Chris-Paquin', 443);
insert into BOOK_AUTHOR (author, bookid)
values ('Christine-Davison', 321);
insert into BOOK_AUTHOR (author, bookid)
values ('Chubby-Hutton', 198);
insert into BOOK_AUTHOR (author, bookid)
values ('Claire-Biehn', 375);
insert into BOOK_AUTHOR (author, bookid)
values ('Clarence-Mantegna', 327);
insert into BOOK_AUTHOR (author, bookid)
values ('Claude-Shaw', 55);
insert into BOOK_AUTHOR (author, bookid)
values ('Claude-Wheel', 500);
insert into BOOK_AUTHOR (author, bookid)
values ('Cledus-Schiff', 342);
insert into BOOK_AUTHOR (author, bookid)
values ('Cliff-Pressly', 361);
insert into BOOK_AUTHOR (author, bookid)
values ('Cliff-Weller', 223);
insert into BOOK_AUTHOR (author, bookid)
values ('Clint-Heald', 80);
insert into BOOK_AUTHOR (author, bookid)
values ('Clint-Pantoliano', 413);
commit;
prompt 300 records committed...
insert into BOOK_AUTHOR (author, bookid)
values ('Colleen-Leto', 294);
insert into BOOK_AUTHOR (author, bookid)
values ('Connie-Pleasence', 350);
insert into BOOK_AUTHOR (author, bookid)
values ('Connie-Vannelli', 208);
insert into BOOK_AUTHOR (author, bookid)
values ('Corey-Schwimmer', 42);
insert into BOOK_AUTHOR (author, bookid)
values ('Crystal-Brosnan', 454);
insert into BOOK_AUTHOR (author, bookid)
values ('Cuba-Cozier', 442);
insert into BOOK_AUTHOR (author, bookid)
values ('Cuba-Weir', 474);
insert into BOOK_AUTHOR (author, bookid)
values ('Curtis-Idle', 163);
insert into BOOK_AUTHOR (author, bookid)
values ('Cyndi-Palmer', 131);
insert into BOOK_AUTHOR (author, bookid)
values ('Cyndi-Schreiber', 241);
insert into BOOK_AUTHOR (author, bookid)
values ('Danni-Schiff', 193);
insert into BOOK_AUTHOR (author, bookid)
values ('Dar-Bailey', 310);
insert into BOOK_AUTHOR (author, bookid)
values ('Darius-Rains', 283);
insert into BOOK_AUTHOR (author, bookid)
values ('Darren-Sevenfold', 244);
insert into BOOK_AUTHOR (author, bookid)
values ('Daryle-Day-Lewis', 10);
insert into BOOK_AUTHOR (author, bookid)
values ('Daryle-Portman', 374);
insert into BOOK_AUTHOR (author, bookid)
values ('Dave-Capshaw', 338);
insert into BOOK_AUTHOR (author, bookid)
values ('Dave-Hart', 8);
insert into BOOK_AUTHOR (author, bookid)
values ('Davy-Hiatt', 149);
insert into BOOK_AUTHOR (author, bookid)
values ('Debby-Atkinson', 413);
insert into BOOK_AUTHOR (author, bookid)
values ('Debby-Loveless', 488);
insert into BOOK_AUTHOR (author, bookid)
values ('Deborah-Loring', 29);
insert into BOOK_AUTHOR (author, bookid)
values ('Debra-Baranski', 124);
insert into BOOK_AUTHOR (author, bookid)
values ('Debra-Church', 212);
insert into BOOK_AUTHOR (author, bookid)
values ('Delbert-DeVita', 108);
insert into BOOK_AUTHOR (author, bookid)
values ('Delbert-Penn', 94);
insert into BOOK_AUTHOR (author, bookid)
values ('Delbert-Raye', 388);
insert into BOOK_AUTHOR (author, bookid)
values ('Delroy-Curtis', 115);
insert into BOOK_AUTHOR (author, bookid)
values ('Demi-Idol', 113);
insert into BOOK_AUTHOR (author, bookid)
values ('Denise-Calle', 35);
insert into BOOK_AUTHOR (author, bookid)
values ('Denise-Pleasence', 367);
insert into BOOK_AUTHOR (author, bookid)
values ('Denise-Ryan', 161);
insert into BOOK_AUTHOR (author, bookid)
values ('Dennis-Schiavelli', 256);
insert into BOOK_AUTHOR (author, bookid)
values ('Denny-Harris', 168);
insert into BOOK_AUTHOR (author, bookid)
values ('Denzel-Polito', 37);
insert into BOOK_AUTHOR (author, bookid)
values ('Derek-Beatty', 316);
insert into BOOK_AUTHOR (author, bookid)
values ('Derek-Huston', 465);
insert into BOOK_AUTHOR (author, bookid)
values ('Derrick-Rubinek', 470);
insert into BOOK_AUTHOR (author, bookid)
values ('Desmond-Li', 180);
insert into BOOK_AUTHOR (author, bookid)
values ('Diane-Garza', 77);
insert into BOOK_AUTHOR (author, bookid)
values ('Dianne-Diffie', 377);
insert into BOOK_AUTHOR (author, bookid)
values ('Dick-Moffat', 216);
insert into BOOK_AUTHOR (author, bookid)
values ('Dionne-Diaz', 338);
insert into BOOK_AUTHOR (author, bookid)
values ('Dom-Aaron', 153);
insert into BOOK_AUTHOR (author, bookid)
values ('Dom-Perrineau', 186);
insert into BOOK_AUTHOR (author, bookid)
values ('Don-Esposito', 475);
insert into BOOK_AUTHOR (author, bookid)
values ('Don-Liotta', 112);
insert into BOOK_AUTHOR (author, bookid)
values ('Donna-Camp', 311);
insert into BOOK_AUTHOR (author, bookid)
values ('Donna-Church', 214);
insert into BOOK_AUTHOR (author, bookid)
values ('Donna-Cleese', 236);
insert into BOOK_AUTHOR (author, bookid)
values ('Dorry-DeVita', 252);
insert into BOOK_AUTHOR (author, bookid)
values ('Doug-Winans', 459);
insert into BOOK_AUTHOR (author, bookid)
values ('Dwight-Condition', 12);
insert into BOOK_AUTHOR (author, bookid)
values ('Eddie-Tripplehorn', 32);
insert into BOOK_AUTHOR (author, bookid)
values ('Edgar-Kahn', 278);
insert into BOOK_AUTHOR (author, bookid)
values ('Edwin-Plowright', 128);
insert into BOOK_AUTHOR (author, bookid)
values ('Elisabeth-Johansson', 155);
insert into BOOK_AUTHOR (author, bookid)
values ('Elizabeth-Archer', 305);
insert into BOOK_AUTHOR (author, bookid)
values ('Elvis-Rebhorn', 238);
insert into BOOK_AUTHOR (author, bookid)
values ('Elvis-Vaughn', 71);
insert into BOOK_AUTHOR (author, bookid)
values ('Emerson-Adler', 127);
insert into BOOK_AUTHOR (author, bookid)
values ('Emilio-Skarsgard', 152);
insert into BOOK_AUTHOR (author, bookid)
values ('Emily-Lopez', 148);
insert into BOOK_AUTHOR (author, bookid)
values ('Emily-Reeve', 484);
insert into BOOK_AUTHOR (author, bookid)
values ('Emily-Tippe', 114);
insert into BOOK_AUTHOR (author, bookid)
values ('Emm-Stevens', 450);
insert into BOOK_AUTHOR (author, bookid)
values ('Emma-Eat World', 204);
insert into BOOK_AUTHOR (author, bookid)
values ('Emma-McGill', 224);
insert into BOOK_AUTHOR (author, bookid)
values ('Eric-Haysbert', 110);
insert into BOOK_AUTHOR (author, bookid)
values ('Eric-Hingle', 74);
insert into BOOK_AUTHOR (author, bookid)
values ('Eric-Iglesias', 498);
insert into BOOK_AUTHOR (author, bookid)
values ('Eric-Santana', 394);
insert into BOOK_AUTHOR (author, bookid)
values ('Ernest-England', 144);
insert into BOOK_AUTHOR (author, bookid)
values ('Ethan-McKennitt', 304);
insert into BOOK_AUTHOR (author, bookid)
values ('Etta-Gary', 150);
insert into BOOK_AUTHOR (author, bookid)
values ('Eugene-Beck', 371);
insert into BOOK_AUTHOR (author, bookid)
values ('Fairuza-Bogguss', 74);
insert into BOOK_AUTHOR (author, bookid)
values ('Fats-Renfro', 419);
insert into BOOK_AUTHOR (author, bookid)
values ('Fats-Tarantino', 116);
insert into BOOK_AUTHOR (author, bookid)
values ('Faye-Brock', 474);
insert into BOOK_AUTHOR (author, bookid)
values ('Fiona-Atkinson', 41);
insert into BOOK_AUTHOR (author, bookid)
values ('Fiona-Dafoe', 287);
insert into BOOK_AUTHOR (author, bookid)
values ('Fionnula-Parker', 280);
insert into BOOK_AUTHOR (author, bookid)
values ('Forest-Horton', 331);
insert into BOOK_AUTHOR (author, bookid)
values ('France-Tomlin', 326);
insert into BOOK_AUTHOR (author, bookid)
values ('Frances-Rundgren', 361);
insert into BOOK_AUTHOR (author, bookid)
values ('Frankie-Harry', 173);
insert into BOOK_AUTHOR (author, bookid)
values ('Frankie-Parker', 147);
insert into BOOK_AUTHOR (author, bookid)
values ('Frankie-Porter', 443);
insert into BOOK_AUTHOR (author, bookid)
values ('Frankie-Tomlin', 120);
insert into BOOK_AUTHOR (author, bookid)
values ('Franz-Quinlan', 314);
insert into BOOK_AUTHOR (author, bookid)
values ('Freddy-Shannon', 486);
insert into BOOK_AUTHOR (author, bookid)
values ('Frederic-Thewlis', 121);
insert into BOOK_AUTHOR (author, bookid)
values ('Gabrielle-Phillippe', 274);
insert into BOOK_AUTHOR (author, bookid)
values ('Gaby-Copeland', 460);
insert into BOOK_AUTHOR (author, bookid)
values ('Gailard-Askew', 283);
insert into BOOK_AUTHOR (author, bookid)
values ('Garland-Clooney', 254);
insert into BOOK_AUTHOR (author, bookid)
values ('Garland-Warren', 122);
insert into BOOK_AUTHOR (author, bookid)
values ('Garth-Abraham', 100);
insert into BOOK_AUTHOR (author, bookid)
values ('Geena-Barry', 263);
commit;
prompt 400 records committed...
insert into BOOK_AUTHOR (author, bookid)
values ('Geena-Flatts', 65);
insert into BOOK_AUTHOR (author, bookid)
values ('Gena-Schneider', 42);
insert into BOOK_AUTHOR (author, bookid)
values ('Gene-White', 92);
insert into BOOK_AUTHOR (author, bookid)
values ('Geoff-Todd', 125);
insert into BOOK_AUTHOR (author, bookid)
values ('Gina-Bugnon', 71);
insert into BOOK_AUTHOR (author, bookid)
values ('Gino-Dempsey', 110);
insert into BOOK_AUTHOR (author, bookid)
values ('Gino-McCoy', 220);
insert into BOOK_AUTHOR (author, bookid)
values ('Glenn-Lynne', 475);
insert into BOOK_AUTHOR (author, bookid)
values ('Goran-Armstrong', 65);
insert into BOOK_AUTHOR (author, bookid)
values ('Gord-Shepherd', 431);
insert into BOOK_AUTHOR (author, bookid)
values ('Grace-Bacon', 487);
insert into BOOK_AUTHOR (author, bookid)
values ('Grace-Bonneville', 27);
insert into BOOK_AUTHOR (author, bookid)
values ('Greg-Bale', 19);
insert into BOOK_AUTHOR (author, bookid)
values ('Greg-Colton', 229);
insert into BOOK_AUTHOR (author, bookid)
values ('Greg-Dorn', 166);
insert into BOOK_AUTHOR (author, bookid)
values ('Gwyneth-Travers', 389);
insert into BOOK_AUTHOR (author, bookid)
values ('Hal-Metcalf', 402);
insert into BOOK_AUTHOR (author, bookid)
values ('Harris-Carrack', 137);
insert into BOOK_AUTHOR (author, bookid)
values ('Harris-Cohn', 56);
insert into BOOK_AUTHOR (author, bookid)
values ('Harris-MacDowell', 283);
insert into BOOK_AUTHOR (author, bookid)
values ('Hazel-Clayton', 121);
insert into BOOK_AUTHOR (author, bookid)
values ('Hazel-Lawrence', 288);
insert into BOOK_AUTHOR (author, bookid)
values ('Hazel-Roy Parnell', 370);
insert into BOOK_AUTHOR (author, bookid)
values ('Heath-Coward', 347);
insert into BOOK_AUTHOR (author, bookid)
values ('Hector-Carrington', 32);
insert into BOOK_AUTHOR (author, bookid)
values ('Henry-Dafoe', 20);
insert into BOOK_AUTHOR (author, bookid)
values ('Herbie-Bachman', 340);
insert into BOOK_AUTHOR (author, bookid)
values ('Herbie-Channing', 258);
insert into BOOK_AUTHOR (author, bookid)
values ('Hex-Gracie', 150);
insert into BOOK_AUTHOR (author, bookid)
values ('Hex-Griffin', 85);
insert into BOOK_AUTHOR (author, bookid)
values ('Hikaru-Portman', 56);
insert into BOOK_AUTHOR (author, bookid)
values ('Hilary-Lithgow', 42);
insert into BOOK_AUTHOR (author, bookid)
values ('Hilton-Adkins', 41);
insert into BOOK_AUTHOR (author, bookid)
values ('Hilton-Bryson', 319);
insert into BOOK_AUTHOR (author, bookid)
values ('Holland-Carrere', 186);
insert into BOOK_AUTHOR (author, bookid)
values ('Holly-Lucas', 280);
insert into BOOK_AUTHOR (author, bookid)
values ('Holly-Perry', 392);
insert into BOOK_AUTHOR (author, bookid)
values ('Hookah-Macy', 296);
insert into BOOK_AUTHOR (author, bookid)
values ('Hope-Beals', 468);
insert into BOOK_AUTHOR (author, bookid)
values ('Hope-Soda', 438);
insert into BOOK_AUTHOR (author, bookid)
values ('Horace-Affleck', 180);
insert into BOOK_AUTHOR (author, bookid)
values ('Horace-Brock', 381);
insert into BOOK_AUTHOR (author, bookid)
values ('Ice-Fierstein', 49);
insert into BOOK_AUTHOR (author, bookid)
values ('Ice-Hopkins', 153);
insert into BOOK_AUTHOR (author, bookid)
values ('Ice-Weston', 279);
insert into BOOK_AUTHOR (author, bookid)
values ('Ike-Armatrading', 368);
insert into BOOK_AUTHOR (author, bookid)
values ('Ike-Coleman', 450);
insert into BOOK_AUTHOR (author, bookid)
values ('Ike-Dooley', 81);
insert into BOOK_AUTHOR (author, bookid)
values ('Ike-Kidman', 285);
insert into BOOK_AUTHOR (author, bookid)
values ('Ike-Postlethwaite', 485);
insert into BOOK_AUTHOR (author, bookid)
values ('Ike-Sobieski', 300);
insert into BOOK_AUTHOR (author, bookid)
values ('Illeana-Huston', 389);
insert into BOOK_AUTHOR (author, bookid)
values ('Irene-Hurt', 286);
insert into BOOK_AUTHOR (author, bookid)
values ('Isaac-Quinones', 42);
insert into BOOK_AUTHOR (author, bookid)
values ('Isabella-Coughlan', 400);
insert into BOOK_AUTHOR (author, bookid)
values ('Isabella-Sinise', 202);
insert into BOOK_AUTHOR (author, bookid)
values ('Isaiah-Warburton', 495);
insert into BOOK_AUTHOR (author, bookid)
values ('Ivan-Yankovic', 130);
insert into BOOK_AUTHOR (author, bookid)
values ('Jackson-Singh', 51);
insert into BOOK_AUTHOR (author, bookid)
values ('Jaime-Cohn', 248);
insert into BOOK_AUTHOR (author, bookid)
values ('Jake-Sinise', 427);
insert into BOOK_AUTHOR (author, bookid)
values ('Jake-Stuermer', 52);
insert into BOOK_AUTHOR (author, bookid)
values ('James-Dolenz', 159);
insert into BOOK_AUTHOR (author, bookid)
values ('Jane-Feliciano', 410);
insert into BOOK_AUTHOR (author, bookid)
values ('Janeane-Forrest', 365);
insert into BOOK_AUTHOR (author, bookid)
values ('Jann-O''Sullivan', 464);
insert into BOOK_AUTHOR (author, bookid)
values ('Jann-Scaggs', 416);
insert into BOOK_AUTHOR (author, bookid)
values ('Jann-Skerritt', 274);
insert into BOOK_AUTHOR (author, bookid)
values ('Jared-Holly', 375);
insert into BOOK_AUTHOR (author, bookid)
values ('Jason-Botti', 25);
insert into BOOK_AUTHOR (author, bookid)
values ('Jason-McCoy', 190);
insert into BOOK_AUTHOR (author, bookid)
values ('Jason-Rains', 244);
insert into BOOK_AUTHOR (author, bookid)
values ('Javon-Benoit', 274);
insert into BOOK_AUTHOR (author, bookid)
values ('Javon-Garcia', 36);
insert into BOOK_AUTHOR (author, bookid)
values ('Jay-Basinger', 95);
insert into BOOK_AUTHOR (author, bookid)
values ('Jay-Horizon', 487);
insert into BOOK_AUTHOR (author, bookid)
values ('Jay-Latifah', 319);
insert into BOOK_AUTHOR (author, bookid)
values ('Jean-Claude-Bugnon', 271);
insert into BOOK_AUTHOR (author, bookid)
values ('Jean-Claude-Doucette', 91);
insert into BOOK_AUTHOR (author, bookid)
values ('Jeanne-Hudson', 14);
insert into BOOK_AUTHOR (author, bookid)
values ('Jeff-Aaron', 14);
insert into BOOK_AUTHOR (author, bookid)
values ('Jeffery-Arnold', 136);
insert into BOOK_AUTHOR (author, bookid)
values ('Jennifer-Kimball', 145);
insert into BOOK_AUTHOR (author, bookid)
values ('Jeroen-Shawn', 493);
insert into BOOK_AUTHOR (author, bookid)
values ('Jesus-Herrmann', 476);
insert into BOOK_AUTHOR (author, bookid)
values ('Jet-Donovan', 100);
insert into BOOK_AUTHOR (author, bookid)
values ('Jim-Osment', 196);
insert into BOOK_AUTHOR (author, bookid)
values ('Jim-Stuermer', 291);
insert into BOOK_AUTHOR (author, bookid)
values ('Jimmie-Conners', 204);
insert into BOOK_AUTHOR (author, bookid)
values ('Joanna-Saucedo', 63);
insert into BOOK_AUTHOR (author, bookid)
values ('Joanna-Stuermer', 162);
insert into BOOK_AUTHOR (author, bookid)
values ('Joaquin-Weiland', 134);
insert into BOOK_AUTHOR (author, bookid)
values ('Jodie-Cetera', 169);
insert into BOOK_AUTHOR (author, bookid)
values ('Jodie-Curfman', 420);
insert into BOOK_AUTHOR (author, bookid)
values ('Joe-Balin', 288);
insert into BOOK_AUTHOR (author, bookid)
values ('Joely-Spacey', 354);
insert into BOOK_AUTHOR (author, bookid)
values ('Joey-McPherson', 397);
insert into BOOK_AUTHOR (author, bookid)
values ('John-Ferrer', 436);
insert into BOOK_AUTHOR (author, bookid)
values ('John-Kane', 54);
insert into BOOK_AUTHOR (author, bookid)
values ('John-Ryan', 367);
commit;
prompt 500 records committed...
insert into BOOK_AUTHOR (author, bookid)
values ('John-Sutherland', 128);
insert into BOOK_AUTHOR (author, bookid)
values ('John-Worrell', 5);
insert into BOOK_AUTHOR (author, bookid)
values ('Johnette-Laurie', 448);
insert into BOOK_AUTHOR (author, bookid)
values ('Johnnie-Schock', 472);
insert into BOOK_AUTHOR (author, bookid)
values ('Jon-Smith', 483);
insert into BOOK_AUTHOR (author, bookid)
values ('Jonathan-Strathairn', 347);
insert into BOOK_AUTHOR (author, bookid)
values ('Jonathan-Weir', 1);
insert into BOOK_AUTHOR (author, bookid)
values ('Jose-Dukakis', 30);
insert into BOOK_AUTHOR (author, bookid)
values ('Jose-Stewart', 238);
insert into BOOK_AUTHOR (author, bookid)
values ('Joseph-Goldwyn', 361);
insert into BOOK_AUTHOR (author, bookid)
values ('Joseph-Sweeney', 237);
insert into BOOK_AUTHOR (author, bookid)
values ('Josh-Fender', 379);
insert into BOOK_AUTHOR (author, bookid)
values ('Josh-Steagall', 381);
insert into BOOK_AUTHOR (author, bookid)
values ('Joshua-Prinze', 12);
insert into BOOK_AUTHOR (author, bookid)
values ('Joy-Barrymore', 38);
insert into BOOK_AUTHOR (author, bookid)
values ('Juan-Lloyd', 239);
insert into BOOK_AUTHOR (author, bookid)
values ('Judge-Gano', 439);
insert into BOOK_AUTHOR (author, bookid)
values ('Judge-Mazzello', 15);
insert into BOOK_AUTHOR (author, bookid)
values ('Juliana-McCain', 271);
insert into BOOK_AUTHOR (author, bookid)
values ('Julianna-Patton', 391);
insert into BOOK_AUTHOR (author, bookid)
values ('Julianna-Sirtis', 469);
insert into BOOK_AUTHOR (author, bookid)
values ('Julianne-Armstrong', 419);
insert into BOOK_AUTHOR (author, bookid)
values ('Juliette-McCabe', 83);
insert into BOOK_AUTHOR (author, bookid)
values ('Karen-Phoenix', 136);
insert into BOOK_AUTHOR (author, bookid)
values ('Karon-Culkin', 98);
insert into BOOK_AUTHOR (author, bookid)
values ('Katie-Mandrell', 452);
insert into BOOK_AUTHOR (author, bookid)
values ('Katie-Quinn', 338);
insert into BOOK_AUTHOR (author, bookid)
values ('Katrin-Aaron', 21);
insert into BOOK_AUTHOR (author, bookid)
values ('Kay-Sedaka', 184);
insert into BOOK_AUTHOR (author, bookid)
values ('Kazem-Gibson', 228);
insert into BOOK_AUTHOR (author, bookid)
values ('Keanu-Perrineau', 172);
insert into BOOK_AUTHOR (author, bookid)
values ('Keanu-Sinise', 375);
insert into BOOK_AUTHOR (author, bookid)
values ('Keanu-Tankard', 391);
insert into BOOK_AUTHOR (author, bookid)
values ('Kelli-Clark', 281);
insert into BOOK_AUTHOR (author, bookid)
values ('Kelli-Furtado', 312);
insert into BOOK_AUTHOR (author, bookid)
values ('Kenneth-Biggs', 117);
insert into BOOK_AUTHOR (author, bookid)
values ('Kevn-Crudup', 317);
insert into BOOK_AUTHOR (author, bookid)
values ('Kevn-Plummer', 419);
insert into BOOK_AUTHOR (author, bookid)
values ('Kid-Pitney', 84);
insert into BOOK_AUTHOR (author, bookid)
values ('Kieran-Costner', 49);
insert into BOOK_AUTHOR (author, bookid)
values ('Kim-McBride', 218);
insert into BOOK_AUTHOR (author, bookid)
values ('Kimberly-Marx', 36);
insert into BOOK_AUTHOR (author, bookid)
values ('Kimberly-Neill', 225);
insert into BOOK_AUTHOR (author, bookid)
values ('Kirk-Gates', 18);
insert into BOOK_AUTHOR (author, bookid)
values ('Kirsten-Dorn', 242);
insert into BOOK_AUTHOR (author, bookid)
values ('Kirsten-Hatchet', 115);
insert into BOOK_AUTHOR (author, bookid)
values ('Kris-Roy Parnell', 348);
insert into BOOK_AUTHOR (author, bookid)
values ('Kristin-Hagerty', 486);
insert into BOOK_AUTHOR (author, bookid)
values ('Kurt-LaBelle', 374);
insert into BOOK_AUTHOR (author, bookid)
values ('Kyle-Cleese', 242);
insert into BOOK_AUTHOR (author, bookid)
values ('Kyra-Deejay', 338);
insert into BOOK_AUTHOR (author, bookid)
values ('Kyra-Spacek', 376);
insert into BOOK_AUTHOR (author, bookid)
values ('Larnelle-Yorn', 281);
insert into BOOK_AUTHOR (author, bookid)
values ('Latin-Keen', 476);
insert into BOOK_AUTHOR (author, bookid)
values ('Latin-Keeslar', 274);
insert into BOOK_AUTHOR (author, bookid)
values ('Laura-Downey', 249);
insert into BOOK_AUTHOR (author, bookid)
values ('Lauren-Firth', 142);
insert into BOOK_AUTHOR (author, bookid)
values ('Leelee-Durning', 98);
insert into BOOK_AUTHOR (author, bookid)
values ('Leelee-Margolyes', 289);
insert into BOOK_AUTHOR (author, bookid)
values ('Leelee-Stevenson', 171);
insert into BOOK_AUTHOR (author, bookid)
values ('Lena-Holmes', 493);
insert into BOOK_AUTHOR (author, bookid)
values ('Lennie-Paul', 91);
insert into BOOK_AUTHOR (author, bookid)
values ('Lenny-Child', 88);
insert into BOOK_AUTHOR (author, bookid)
values ('Lenny-Gough', 323);
insert into BOOK_AUTHOR (author, bookid)
values ('Leon-Holliday', 356);
insert into BOOK_AUTHOR (author, bookid)
values ('Leonardo-Adler', 317);
insert into BOOK_AUTHOR (author, bookid)
values ('Leonardo-Capshaw', 378);
insert into BOOK_AUTHOR (author, bookid)
values ('Lesley-Alston', 8);
insert into BOOK_AUTHOR (author, bookid)
values ('Lesley-Hewitt', 444);
insert into BOOK_AUTHOR (author, bookid)
values ('Lesley-McNarland', 20);
insert into BOOK_AUTHOR (author, bookid)
values ('Leslie-Brooks', 150);
insert into BOOK_AUTHOR (author, bookid)
values ('Leslie-Damon', 35);
insert into BOOK_AUTHOR (author, bookid)
values ('Leslie-Sedgwick', 153);
insert into BOOK_AUTHOR (author, bookid)
values ('Liam-Bancroft', 412);
insert into BOOK_AUTHOR (author, bookid)
values ('Liam-Plimpton', 306);
insert into BOOK_AUTHOR (author, bookid)
values ('Lila-Murray', 18);
insert into BOOK_AUTHOR (author, bookid)
values ('Lindsey-Sandler', 339);
insert into BOOK_AUTHOR (author, bookid)
values ('Lisa-Wiedlin', 84);
insert into BOOK_AUTHOR (author, bookid)
values ('Lloyd-Craddock', 25);
insert into BOOK_AUTHOR (author, bookid)
values ('Lloyd-Sledge', 408);
insert into BOOK_AUTHOR (author, bookid)
values ('Lois-Cruise', 47);
insert into BOOK_AUTHOR (author, bookid)
values ('Loretta-Hershey', 25);
insert into BOOK_AUTHOR (author, bookid)
values ('Loretta-Koteas', 177);
insert into BOOK_AUTHOR (author, bookid)
values ('Loretta-Sobieski', 436);
insert into BOOK_AUTHOR (author, bookid)
values ('Lorraine-Voight', 11);
insert into BOOK_AUTHOR (author, bookid)
values ('Lou-Kristofferson', 248);
insert into BOOK_AUTHOR (author, bookid)
values ('Louise-Blige', 72);
insert into BOOK_AUTHOR (author, bookid)
values ('Louise-Ford', 485);
insert into BOOK_AUTHOR (author, bookid)
values ('Louise-Oszajca', 452);
insert into BOOK_AUTHOR (author, bookid)
values ('Louise-Wagner', 419);
insert into BOOK_AUTHOR (author, bookid)
values ('Lucy-Roberts', 435);
insert into BOOK_AUTHOR (author, bookid)
values ('Lupe-Ward', 216);
insert into BOOK_AUTHOR (author, bookid)
values ('Maceo-Elwes', 354);
insert into BOOK_AUTHOR (author, bookid)
values ('Machine-Whitman', 231);
insert into BOOK_AUTHOR (author, bookid)
values ('Madeline-Evett', 170);
insert into BOOK_AUTHOR (author, bookid)
values ('Madeline-McCoy', 85);
insert into BOOK_AUTHOR (author, bookid)
values ('Mae-Finn', 30);
insert into BOOK_AUTHOR (author, bookid)
values ('Maggie-Balin', 176);
insert into BOOK_AUTHOR (author, bookid)
values ('Maggie-Jolie', 58);
insert into BOOK_AUTHOR (author, bookid)
values ('Mandy-Ammons', 184);
commit;
prompt 600 records committed...
insert into BOOK_AUTHOR (author, bookid)
values ('Mandy-Sellers', 178);
insert into BOOK_AUTHOR (author, bookid)
values ('Manu-Sorvino', 381);
insert into BOOK_AUTHOR (author, bookid)
values ('Marie-Glenn', 103);
insert into BOOK_AUTHOR (author, bookid)
values ('Marisa-Ali', 185);
insert into BOOK_AUTHOR (author, bookid)
values ('Marisa-Dushku', 53);
insert into BOOK_AUTHOR (author, bookid)
values ('Mark-Cromwell', 337);
insert into BOOK_AUTHOR (author, bookid)
values ('Marlon-Van Damme', 177);
insert into BOOK_AUTHOR (author, bookid)
values ('Martin-Jenkins', 376);
insert into BOOK_AUTHOR (author, bookid)
values ('Marty-Hewitt', 3);
insert into BOOK_AUTHOR (author, bookid)
values ('Marty-Leto', 299);
insert into BOOK_AUTHOR (author, bookid)
values ('Mary Beth-Furtado', 9);
insert into BOOK_AUTHOR (author, bookid)
values ('Mary Beth-White', 350);
insert into BOOK_AUTHOR (author, bookid)
values ('Mary-Gere', 490);
insert into BOOK_AUTHOR (author, bookid)
values ('Mary-Louise-Morales', 144);
insert into BOOK_AUTHOR (author, bookid)
values ('Matthew-Blair', 391);
insert into BOOK_AUTHOR (author, bookid)
values ('Maura-Nivola', 415);
insert into BOOK_AUTHOR (author, bookid)
values ('Maureen-Morse', 309);
insert into BOOK_AUTHOR (author, bookid)
values ('Maury-Biel', 50);
insert into BOOK_AUTHOR (author, bookid)
values ('Maury-Margulies', 332);
insert into BOOK_AUTHOR (author, bookid)
values ('Maury-Posey', 443);
insert into BOOK_AUTHOR (author, bookid)
values ('Meg-Gere', 161);
insert into BOOK_AUTHOR (author, bookid)
values ('Mel-Karyo', 98);
insert into BOOK_AUTHOR (author, bookid)
values ('Melanie-Wright', 222);
insert into BOOK_AUTHOR (author, bookid)
values ('Melba-Houston', 46);
insert into BOOK_AUTHOR (author, bookid)
values ('Melba-Spacek', 210);
insert into BOOK_AUTHOR (author, bookid)
values ('Melba-Wiedlin', 80);
insert into BOOK_AUTHOR (author, bookid)
values ('Mena-Kelly', 299);
insert into BOOK_AUTHOR (author, bookid)
values ('Meredith-Lawrence', 270);
insert into BOOK_AUTHOR (author, bookid)
values ('Meredith-Pepper', 384);
insert into BOOK_AUTHOR (author, bookid)
values ('Merle-Hatfield', 450);
insert into BOOK_AUTHOR (author, bookid)
values ('Merrill-Garber', 38);
insert into BOOK_AUTHOR (author, bookid)
values ('Merrill-Ness', 227);
insert into BOOK_AUTHOR (author, bookid)
values ('Mia-Colon', 334);
insert into BOOK_AUTHOR (author, bookid)
values ('Michelle-Manning', 297);
insert into BOOK_AUTHOR (author, bookid)
values ('Miguel-Jay', 200);
insert into BOOK_AUTHOR (author, bookid)
values ('Mika-Arkenstone', 77);
insert into BOOK_AUTHOR (author, bookid)
values ('Mika-Crewson', 42);
insert into BOOK_AUTHOR (author, bookid)
values ('Mika-DeGraw', 268);
insert into BOOK_AUTHOR (author, bookid)
values ('Mika-Landau', 100);
insert into BOOK_AUTHOR (author, bookid)
values ('Mike-Harary', 145);
insert into BOOK_AUTHOR (author, bookid)
values ('Mike-Meyer', 494);
insert into BOOK_AUTHOR (author, bookid)
values ('Mike-Rundgren', 414);
insert into BOOK_AUTHOR (author, bookid)
values ('Miki-Yorn', 449);
insert into BOOK_AUTHOR (author, bookid)
values ('Miles-Sampson', 150);
insert into BOOK_AUTHOR (author, bookid)
values ('Millie-Gold', 148);
insert into BOOK_AUTHOR (author, bookid)
values ('Mindy-Blaine', 143);
insert into BOOK_AUTHOR (author, bookid)
values ('Ming-Na-Lyonne', 117);
insert into BOOK_AUTHOR (author, bookid)
values ('Ming-Na-Vaughn', 404);
insert into BOOK_AUTHOR (author, bookid)
values ('Mint-Crystal', 100);
insert into BOOK_AUTHOR (author, bookid)
values ('Mint-Nakai', 176);
insert into BOOK_AUTHOR (author, bookid)
values ('Mira-Viterelli', 48);
insert into BOOK_AUTHOR (author, bookid)
values ('Miranda-Payton', 238);
insert into BOOK_AUTHOR (author, bookid)
values ('Miriam-Linney', 394);
insert into BOOK_AUTHOR (author, bookid)
values ('Mitchell-Carrey', 299);
insert into BOOK_AUTHOR (author, bookid)
values ('Moe-Huston', 461);
insert into BOOK_AUTHOR (author, bookid)
values ('Molly-Hauser', 143);
insert into BOOK_AUTHOR (author, bookid)
values ('Morris-Sorvino', 500);
insert into BOOK_AUTHOR (author, bookid)
values ('Murray-Campbell', 165);
insert into BOOK_AUTHOR (author, bookid)
values ('Mykelti-Bracco', 474);
insert into BOOK_AUTHOR (author, bookid)
values ('Nancy-Garofalo', 286);
insert into BOOK_AUTHOR (author, bookid)
values ('Nancy-Sartain', 313);
insert into BOOK_AUTHOR (author, bookid)
values ('Naomi-Chappelle', 125);
insert into BOOK_AUTHOR (author, bookid)
values ('Naomi-Gore', 92);
insert into BOOK_AUTHOR (author, bookid)
values ('Naomi-Kurtz', 493);
insert into BOOK_AUTHOR (author, bookid)
values ('Natacha-Quinlan', 199);
insert into BOOK_AUTHOR (author, bookid)
values ('Natalie-Forrest', 128);
insert into BOOK_AUTHOR (author, bookid)
values ('Natascha-Turner', 475);
insert into BOOK_AUTHOR (author, bookid)
values ('Natasha-Condition', 148);
insert into BOOK_AUTHOR (author, bookid)
values ('Ned-Elizondo', 57);
insert into BOOK_AUTHOR (author, bookid)
values ('Neil-Arden', 350);
insert into BOOK_AUTHOR (author, bookid)
values ('Neil-Clooney', 293);
insert into BOOK_AUTHOR (author, bookid)
values ('Neneh-Reeve', 389);
insert into BOOK_AUTHOR (author, bookid)
values ('Neve-Salt', 53);
insert into BOOK_AUTHOR (author, bookid)
values ('Neve-Sandoval', 370);
insert into BOOK_AUTHOR (author, bookid)
values ('Nickel-Getty', 42);
insert into BOOK_AUTHOR (author, bookid)
values ('Nickel-Lawrence', 407);
insert into BOOK_AUTHOR (author, bookid)
values ('Nicky-Blaine', 173);
insert into BOOK_AUTHOR (author, bookid)
values ('Nicky-Lunch', 129);
insert into BOOK_AUTHOR (author, bookid)
values ('Nicolas-Liu', 121);
insert into BOOK_AUTHOR (author, bookid)
values ('Nicole-Scaggs', 487);
insert into BOOK_AUTHOR (author, bookid)
values ('Nigel-Holland', 245);
insert into BOOK_AUTHOR (author, bookid)
values ('Nik-Willard', 404);
insert into BOOK_AUTHOR (author, bookid)
values ('Nikki-Broderick', 150);
insert into BOOK_AUTHOR (author, bookid)
values ('Nils-Young', 391);
insert into BOOK_AUTHOR (author, bookid)
values ('Nora-Biel', 212);
insert into BOOK_AUTHOR (author, bookid)
values ('Oded-Tankard', 306);
insert into BOOK_AUTHOR (author, bookid)
values ('Omar-De Niro', 152);
insert into BOOK_AUTHOR (author, bookid)
values ('Omar-Garber', 2);
insert into BOOK_AUTHOR (author, bookid)
values ('Oro-Napolitano', 122);
insert into BOOK_AUTHOR (author, bookid)
values ('Oro-Teng', 462);
insert into BOOK_AUTHOR (author, bookid)
values ('Ossie-Dourif', 29);
insert into BOOK_AUTHOR (author, bookid)
values ('Ozzy-Dorff', 330);
insert into BOOK_AUTHOR (author, bookid)
values ('Ozzy-Dorn', 415);
insert into BOOK_AUTHOR (author, bookid)
values ('Pablo-Gagnon', 138);
insert into BOOK_AUTHOR (author, bookid)
values ('Pablo-Stewart', 343);
insert into BOOK_AUTHOR (author, bookid)
values ('Pam-Spine', 99);
insert into BOOK_AUTHOR (author, bookid)
values ('Pamela-Marie', 292);
insert into BOOK_AUTHOR (author, bookid)
values ('Parker-Balk', 498);
insert into BOOK_AUTHOR (author, bookid)
values ('Parker-Madonna', 483);
insert into BOOK_AUTHOR (author, bookid)
values ('Pat-Charles', 303);
commit;
prompt 700 records loaded
prompt Loading FINES...
insert into FINES (clientid, totalfine)
values ('013427448', 250);
commit;
prompt 1 records loaded
prompt Loading NOTIFICATIONS...
prompt Table is empty
prompt Loading PLAYCATEGORY...
insert into PLAYCATEGORY (categoryid, categoryname)
values (1, 'Board');
insert into PLAYCATEGORY (categoryid, categoryname)
values (2, 'Card');
insert into PLAYCATEGORY (categoryid, categoryname)
values (3, 'Role-playing');
insert into PLAYCATEGORY (categoryid, categoryname)
values (4, 'Puzzle');
insert into PLAYCATEGORY (categoryid, categoryname)
values (5, 'Cooperative');
commit;
prompt 5 records loaded
prompt Loading PLAYPUBLISHER...
insert into PLAYPUBLISHER (publisherid, publishername)
values (1, 'Rummikub');
insert into PLAYPUBLISHER (publisherid, publishername)
values (2, 'Domino rally');
insert into PLAYPUBLISHER (publisherid, publishername)
values (3, 'Monopoly');
insert into PLAYPUBLISHER (publisherid, publishername)
values (4, 'Jumbo');
insert into PLAYPUBLISHER (publisherid, publishername)
values (5, 'Kodkod');
insert into PLAYPUBLISHER (publisherid, publishername)
values (6, 'Clementoni');
commit;
prompt 6 records loaded
prompt Loading PLAY...
insert into PLAY (playid, playname, categoryid, publisherid)
values (1, '13 Dead End Drive', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (2, '1313 Dead End Drive', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (3, '18XX', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (4, '221B Baker Street: The Master Detective Game', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (5, '30 Seconds', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (6, '500 rum', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (7, 'A Feast for Odin', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (8, 'A Game of War', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (9, 'Abalone', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (10, 'About Time', 4, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (11, 'Acquire', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (12, 'Acronymble', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (13, 'Afrikan t?hti', 2, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (14, 'Agon', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (15, 'Agricola', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (16, 'Air Charter', 1, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (17, 'Aksharit', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (18, 'Aladdin''s Dragons', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (19, 'Alhambra', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (20, 'Alias', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (21, 'American Megafauna', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (22, 'Amun-Re', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (23, 'Android: Netrunner', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (24, 'Anti-Monopoly', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (25, 'Apples to Apples', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (26, 'Arimaa', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (27, 'Arkham Horror', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (28, 'Articulate!', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (29, 'Asalto', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (30, 'Attack!', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (31, 'Auf Achse', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (32, 'Australia', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (33, 'Ave Caesar', 4, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (34, 'Axis & Allies', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (35, 'Azul', 1, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (36, 'Backgammon', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (37, 'Bailout! The Game', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (38, 'Balderdash', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (39, 'Bang!', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (40, 'Barbarossa', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (41, 'Battle Sheep', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (42, 'BattleLore', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (43, 'Battleship', 4, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (44, 'Battlestar Galactica', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (45, 'Beggar-my-neighbour', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (46, 'Betrayal at House on the Hill', 1, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (47, 'Bezzerwizzer', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (48, 'Blackjack', 5, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (49, 'Blankety Blank', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (50, 'Blockade', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (51, 'Blokus', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (52, 'Blood Bowl', 4, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (53, 'Blood Feud in New York', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (54, 'Blood Rage', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (55, 'Blue Max', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (56, 'Bonkers!', 4, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (57, 'Bookchase', 1, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (58, 'Brain Chain', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (59, 'Briscola', 1, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (60, 'Buccaneer', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (61, 'Bul', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (62, 'Camel Up', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (63, 'Camelot', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (64, 'Canasta', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (65, 'Candy Land', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (66, 'Can''t Stop', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (67, 'Capitol', 4, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (68, 'Carcassonne', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (69, 'Careers', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (70, 'Caribbean', 4, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (71, 'Cartagena', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (72, 'Castle Risk', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (73, 'CatanÂ (The Settlers of Catan)', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (74, 'Caylus', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (75, 'ChaturangaÂ (Indian chess)', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (76, 'Cheat', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (77, 'Checkers', 2, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (78, 'Chess', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (79, 'Chinese checkersÂ (Sternhalma)', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (80, 'Chowka bhara', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (81, 'Chromino', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (82, 'CirKis', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (83, 'Civilization', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (84, 'Clans', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (85, 'Clue Jr.: Case of the Missing Pet', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (86, 'Clue/Cluedo', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (87, 'Codenames', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (88, 'Coin Hoppingâ€”Washington D.C.', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (89, 'Colt Express', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (90, 'Commands & Colors: Ancients', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (91, 'Concept', 1, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (92, 'Connect Four', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (93, 'Connect6', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (94, 'Conspiracy', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (95, 'Continuo', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (96, 'Contract bridge', 4, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (97, 'Coppit', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (98, 'Cosmic Encounter', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (99, 'Cranium', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (100, 'Crazy Eights', 3, 4);
commit;
prompt 100 records committed...
insert into PLAY (playid, playname, categoryid, publisherid)
values (101, 'Cribbage', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (102, 'Cross and circle game', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (103, 'Crosstrack', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (104, 'Dald?s', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (105, 'Dark Tower', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (106, 'Dead of Winter: A Cross Roads Game', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (107, 'Diamant', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (108, 'Diamond', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (109, 'Diceball!', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (110, 'Die Macher', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (111, 'Diplomacy', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (112, 'Dixit', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (113, 'Djambi', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (114, 'Dominion', 5, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (115, 'Don''t Miss the Boat', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (116, 'Don''t Quote Me', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (117, 'Doom: The Boardgame', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (118, 'Dorn', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (119, 'Doublets', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (120, 'Downfall', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (121, 'Draughts', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (122, 'Drunter und Dr?ber', 5, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (123, 'Dune', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (124, 'Dungeons & Dragons', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (125, 'Dutch Blitz', 2, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (126, 'DVONN', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (127, 'Eclipse: New Dawn for the Galaxy', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (128, 'Egyptian Ratscrew', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (129, 'El Grande', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (130, 'Elfenland', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (131, 'Enchanted Forest', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (132, 'English Game', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (133, 'Entdecker', 5, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (134, 'Escape from Atlantis', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (135, 'Everdell', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (136, 'Exploding Kittens', 2, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (137, 'Fanorona', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (138, 'Fictionary', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (139, 'Figure It Out', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (140, 'Finance', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (141, 'Fireball Island', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (142, 'Focus', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (143, 'Fresco', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (144, 'Game For Fame', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (145, 'Game of the Generals', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (146, 'Ghettopoly', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (147, 'Ghosts', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (148, 'Gift Trap', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (149, 'Giganten', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (150, 'Gin rummy', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (151, 'GIPF', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (152, 'Girl Talk', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (153, 'Gl?ckshaus', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (154, 'Go', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (155, 'Go Fish', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (156, 'Gobblet', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (157, 'Gomoku', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (158, 'Gong Zhu', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (159, 'Go-Stop', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (160, 'GridIron Master', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (161, 'Guess Who?', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (162, 'Halma', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (163, 'Hare and Hounds', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (164, 'Hearts', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (165, 'Heroscape', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (166, 'Hex', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (167, 'Hey, That''s My Fish!', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (168, 'Hijara', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (169, 'History of the World', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (170, 'Hoity Toity', 4, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (171, 'Hooop!', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (172, 'Hotel', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (173, 'Hounds and Jackals', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (174, 'H?sker D??', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (175, 'I''m the Boss!', 2, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (176, 'Imhotep', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (177, 'Imperial', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (178, 'Indigo', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (179, 'Ingenious', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (180, 'Inkan aarre', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (181, 'Irish', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (182, 'Jacquet', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (183, 'Jaipur', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (184, 'JanggiÂ (Korean chess)', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (185, 'Jass', 5, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (186, 'Java', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (187, 'Jenga', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (188, 'John Company', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (189, 'Journey Through Europe', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (190, 'Junta', 4, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (191, 'Kalah', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (192, 'Kamisado', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (193, 'Karuba', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (194, 'Keltis', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (195, 'Kemps', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (196, 'Khet', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (197, 'Kill Doctor Lucky', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (198, 'King of Tokyo', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (199, 'King Oil', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (200, 'Kingdomino', 2, 1);
commit;
prompt 200 records committed...
insert into PLAY (playid, playname, categoryid, publisherid)
values (201, 'Kingdoms', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (202, 'Knock-out whist', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (203, 'Labyrinth', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (204, 'Landslide', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (205, 'Las Vegas', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (206, 'Le Havre', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (207, 'Liubo', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (208, 'Lords of Waterdeep', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (209, 'Lost Cities', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (210, 'L?wenherz', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (211, 'Luck of the Draw', 1, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (212, 'Ludo', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (213, 'Mad Gab', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (214, 'Mahjong', 2, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (215, 'MakrukÂ (Thai chess)', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (216, 'Malefiz', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (217, 'Mall Madness', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (218, 'Manhattan', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (219, 'Mastermind', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (220, 'Masterpiece', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (221, 'Matching game', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (222, 'Mau-Mau', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (223, 'Medici', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (224, 'Medina', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (225, 'Memory', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (226, 'Mensch ?rgere Dich nicht', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (227, 'Merchant of Venus', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (228, 'Metro', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (229, 'Mexica', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (230, 'Mikado', 5, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (231, 'Mine a Million', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (232, 'Modern Art', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (233, 'Monopoly', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (234, 'Monopoly Deal', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (235, 'Mutant Meeples', 2, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (236, 'Near and Far', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (237, 'Nerts', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (238, 'Niagara', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (239, 'Nine men''s morris', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (240, 'Okey', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (241, 'Old maid', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (242, 'Omega Virus', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (243, 'One-card', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (244, 'Onyx', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (245, 'Operation', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (246, 'Ouija', 4, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (247, 'Ouk-KhmerÂ (Cambodian chess)', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (248, 'Outrage!', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (249, 'Oware', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (250, 'Pack & Stack', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (251, 'Pank-a-Squith', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (252, 'Parcheesi', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (253, 'Parqu?s', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (254, 'Patience', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (255, 'Pay Day', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (256, 'Personal Preference', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (257, 'Phase 10', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (258, 'Pictionary', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (259, 'Pinochle', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (260, 'Pirate''s Cove', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (261, 'Plateau', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (262, 'Poker', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (263, 'Poleconomy', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (264, 'Power Grid', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (265, 'Primordial Soup', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (266, 'Probe', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (267, 'Puerto Rico', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (268, 'P?NCT', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (269, 'Puzzle', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (270, 'Qin', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (271, 'Quarto', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (272, 'Quoridor', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (273, 'Qwirkle', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (274, 'Qwirkle', 1, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (275, 'Ra', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (276, 'Rack-O', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (277, 'Rail Baron', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (278, 'Railway Rivals', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (279, 'ReversiÂ (Othello)', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (280, 'Ricochet Robots', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (281, 'Risk', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (282, 'Rithmomachy', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (283, 'Rivers, Roads & Rails', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (284, 'RoboRally', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (285, 'RSVP', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (286, 'Rummikub', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (287, 'Rummoli', 4, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (288, 'Rummoli', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (289, 'Rummy', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (290, 'Saboteur', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (291, 'S?hkku', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (292, 'Saint Petersburg', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (293, 'Samurai', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (294, 'San Marco', 4, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (295, 'Santorini', 5, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (296, 'Scattergories', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (297, 'Scene It?', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (298, 'Schnapsen', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (299, 'Scotland Yard', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (300, 'Scoundrels of Skullport', 2, 3);
commit;
prompt 300 records committed...
insert into PLAY (playid, playname, categoryid, publisherid)
values (301, 'Scrabble', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (302, 'Scythe', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (303, 'Sector 41', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (304, 'Senet', 4, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (305, 'Sequence', 1, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (306, 'Set', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (307, 'Shadow Hunters', 5, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (308, 'Shadows over Camelot', 2, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (309, 'ShatarÂ (Mongolian chess)', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (310, 'ShatranjÂ (Persian chess)', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (311, 'Shengguan Tu', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (312, 'Sherlock Holmes: Consulting Detective', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (313, 'Shichi Narabe', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (314, 'ShogiÂ (Japanese chess)', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (315, 'Shogun/Samurai Swords', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (316, 'Simon', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (317, 'SittuyinÂ (Burmese chess)', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (318, 'Skat', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (319, 'Skip-Bo', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (320, 'Skip-Bo', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (321, 'Skirrid', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (322, 'Slapjack', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (323, 'Sleeping Queens', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (324, 'Small World', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (325, 'Snakes and Ladders', 5, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (326, 'Snap', 3, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (327, 'Snip-snap-snorum', 4, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (328, 'Solarquest', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (329, 'Sorry!', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (330, 'Space Hulk', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (331, 'Spades', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (332, 'Splendor', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (333, 'Spoons', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (334, 'Spy Alley', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (335, 'Squatter', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (336, 'Star Wars Epic Duels', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (337, 'Star Wars Tactics', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (338, 'Star Wars: X-Wing Miniatures Game', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (339, 'StarCraft: The Board Game', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (340, 'Stock Ticker', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (341, 'Strange Synergy', 4, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (342, 'Stratego', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (343, 'Suffragetto', 2, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (344, 'Sugoroku', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (345, 'Summit', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (346, 'Summoner Wars (Second Edition)', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (347, 'Ta Y?', 2, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (348, 'T?b', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (349, 'TaflÂ (Tablut)', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (350, 'Taj Mahal', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (351, 'Tak', 1, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (352, 'Take It Easy', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (353, 'Take the Galaxy', 1, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (354, 'Tantrix', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (355, 'TEG', 3, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (356, 'Terakh', 5, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (357, 'Terra Mystica', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (358, 'Terraforming Mars', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (359, 'The Farming Game', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (360, 'The Game of Life', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (361, 'The Great Train Robbery', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (362, 'The Great Train Robbery', 4, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (363, 'The LOGO Board Game', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (364, 'The London Game', 3, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (365, 'The Mad Magazine Game', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (366, 'The Magic Labyrinth', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (367, 'The Princes of Florence', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (368, 'The Quest of the Philosopher''s Stone', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (369, 'Three thirteen', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (370, 'Through the Ages: A Story of Civilization', 3, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (371, 'Through the Desert', 4, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (372, 'Thurn and Taxis', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (373, 'Ticket to Ride', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (374, 'Tigris and Euphrates', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (375, 'Tikal', 5, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (376, 'Timberland', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (377, 'Time''s Up!', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (378, 'Titan', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (379, 'Top Secret Spies', 2, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (380, 'Torres', 4, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (381, 'Totopoly', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (382, 'Tracks to Telluride', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (383, 'TransAmerica', 2, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (384, 'Travel Go', 3, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (385, 'Trick-taking game', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (386, 'Tri-nim', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (387, 'Trivial Pursuit', 5, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (388, 'Trouble', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (389, 'Tsuro', 1, 5);
insert into PLAY (playid, playname, categoryid, publisherid)
values (390, 'Tsuro of the Seas', 1, 4);
insert into PLAY (playid, playname, categoryid, publisherid)
values (391, 'Twilight Imperium', 5, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (392, 'Twilight Struggle: The Cold War, 1945â€“1989', 2, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (393, 'Ubongo', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (394, 'Uno', 5, 3);
insert into PLAY (playid, playname, categoryid, publisherid)
values (395, 'Uno Flip!', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (396, 'Upwords', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (397, 'Vanished Planet', 2, 1);
insert into PLAY (playid, playname, categoryid, publisherid)
values (398, 'Verquere', 3, 2);
insert into PLAY (playid, playname, categoryid, publisherid)
values (399, 'Vinci', 1, 6);
insert into PLAY (playid, playname, categoryid, publisherid)
values (400, 'War', 3, 4);
commit;
prompt 400 records loaded
prompt Loading PLAYCOPY...
insert into PLAYCOPY (copyid, available, playid)
values (1, 0, 7);
insert into PLAYCOPY (copyid, available, playid)
values (2, 1, 238);
insert into PLAYCOPY (copyid, available, playid)
values (3, 0, 34);
insert into PLAYCOPY (copyid, available, playid)
values (4, 0, 191);
insert into PLAYCOPY (copyid, available, playid)
values (5, 0, 122);
insert into PLAYCOPY (copyid, available, playid)
values (6, 1, 4);
insert into PLAYCOPY (copyid, available, playid)
values (7, 0, 351);
insert into PLAYCOPY (copyid, available, playid)
values (8, 0, 198);
insert into PLAYCOPY (copyid, available, playid)
values (9, 1, 354);
insert into PLAYCOPY (copyid, available, playid)
values (10, 1, 253);
insert into PLAYCOPY (copyid, available, playid)
values (11, 0, 92);
insert into PLAYCOPY (copyid, available, playid)
values (12, 1, 234);
insert into PLAYCOPY (copyid, available, playid)
values (13, 0, 133);
insert into PLAYCOPY (copyid, available, playid)
values (14, 1, 133);
insert into PLAYCOPY (copyid, available, playid)
values (15, 0, 155);
insert into PLAYCOPY (copyid, available, playid)
values (16, 0, 68);
insert into PLAYCOPY (copyid, available, playid)
values (17, 1, 102);
insert into PLAYCOPY (copyid, available, playid)
values (18, 0, 241);
insert into PLAYCOPY (copyid, available, playid)
values (19, 0, 96);
insert into PLAYCOPY (copyid, available, playid)
values (20, 1, 395);
insert into PLAYCOPY (copyid, available, playid)
values (21, 1, 141);
insert into PLAYCOPY (copyid, available, playid)
values (22, 0, 261);
insert into PLAYCOPY (copyid, available, playid)
values (23, 0, 323);
insert into PLAYCOPY (copyid, available, playid)
values (24, 0, 142);
insert into PLAYCOPY (copyid, available, playid)
values (25, 0, 333);
insert into PLAYCOPY (copyid, available, playid)
values (26, 1, 130);
insert into PLAYCOPY (copyid, available, playid)
values (27, 0, 26);
insert into PLAYCOPY (copyid, available, playid)
values (28, 1, 93);
insert into PLAYCOPY (copyid, available, playid)
values (29, 0, 44);
insert into PLAYCOPY (copyid, available, playid)
values (30, 1, 330);
insert into PLAYCOPY (copyid, available, playid)
values (31, 0, 12);
insert into PLAYCOPY (copyid, available, playid)
values (32, 0, 41);
insert into PLAYCOPY (copyid, available, playid)
values (33, 1, 331);
insert into PLAYCOPY (copyid, available, playid)
values (34, 0, 97);
insert into PLAYCOPY (copyid, available, playid)
values (35, 0, 85);
insert into PLAYCOPY (copyid, available, playid)
values (36, 1, 266);
insert into PLAYCOPY (copyid, available, playid)
values (37, 1, 79);
insert into PLAYCOPY (copyid, available, playid)
values (38, 0, 369);
insert into PLAYCOPY (copyid, available, playid)
values (39, 0, 136);
insert into PLAYCOPY (copyid, available, playid)
values (40, 1, 139);
insert into PLAYCOPY (copyid, available, playid)
values (41, 0, 256);
insert into PLAYCOPY (copyid, available, playid)
values (42, 1, 243);
insert into PLAYCOPY (copyid, available, playid)
values (43, 0, 170);
insert into PLAYCOPY (copyid, available, playid)
values (44, 0, 245);
insert into PLAYCOPY (copyid, available, playid)
values (45, 0, 299);
insert into PLAYCOPY (copyid, available, playid)
values (46, 1, 170);
insert into PLAYCOPY (copyid, available, playid)
values (47, 0, 45);
insert into PLAYCOPY (copyid, available, playid)
values (48, 1, 41);
insert into PLAYCOPY (copyid, available, playid)
values (49, 1, 221);
insert into PLAYCOPY (copyid, available, playid)
values (50, 1, 267);
insert into PLAYCOPY (copyid, available, playid)
values (51, 1, 150);
insert into PLAYCOPY (copyid, available, playid)
values (52, 0, 229);
insert into PLAYCOPY (copyid, available, playid)
values (53, 0, 45);
insert into PLAYCOPY (copyid, available, playid)
values (54, 0, 158);
insert into PLAYCOPY (copyid, available, playid)
values (55, 1, 196);
insert into PLAYCOPY (copyid, available, playid)
values (56, 0, 258);
insert into PLAYCOPY (copyid, available, playid)
values (57, 0, 165);
insert into PLAYCOPY (copyid, available, playid)
values (58, 0, 341);
insert into PLAYCOPY (copyid, available, playid)
values (59, 0, 139);
insert into PLAYCOPY (copyid, available, playid)
values (60, 0, 157);
insert into PLAYCOPY (copyid, available, playid)
values (61, 1, 224);
insert into PLAYCOPY (copyid, available, playid)
values (62, 0, 273);
insert into PLAYCOPY (copyid, available, playid)
values (63, 1, 28);
insert into PLAYCOPY (copyid, available, playid)
values (64, 0, 280);
insert into PLAYCOPY (copyid, available, playid)
values (65, 1, 129);
insert into PLAYCOPY (copyid, available, playid)
values (66, 0, 388);
insert into PLAYCOPY (copyid, available, playid)
values (67, 1, 372);
insert into PLAYCOPY (copyid, available, playid)
values (68, 1, 188);
insert into PLAYCOPY (copyid, available, playid)
values (69, 0, 381);
insert into PLAYCOPY (copyid, available, playid)
values (70, 1, 37);
insert into PLAYCOPY (copyid, available, playid)
values (71, 0, 240);
insert into PLAYCOPY (copyid, available, playid)
values (72, 0, 251);
insert into PLAYCOPY (copyid, available, playid)
values (73, 1, 132);
insert into PLAYCOPY (copyid, available, playid)
values (74, 0, 153);
insert into PLAYCOPY (copyid, available, playid)
values (75, 1, 279);
insert into PLAYCOPY (copyid, available, playid)
values (76, 1, 373);
insert into PLAYCOPY (copyid, available, playid)
values (77, 0, 175);
insert into PLAYCOPY (copyid, available, playid)
values (78, 0, 238);
insert into PLAYCOPY (copyid, available, playid)
values (79, 0, 263);
insert into PLAYCOPY (copyid, available, playid)
values (80, 0, 247);
insert into PLAYCOPY (copyid, available, playid)
values (81, 1, 45);
insert into PLAYCOPY (copyid, available, playid)
values (82, 1, 81);
insert into PLAYCOPY (copyid, available, playid)
values (83, 0, 362);
insert into PLAYCOPY (copyid, available, playid)
values (84, 1, 330);
insert into PLAYCOPY (copyid, available, playid)
values (85, 1, 56);
insert into PLAYCOPY (copyid, available, playid)
values (86, 1, 197);
insert into PLAYCOPY (copyid, available, playid)
values (87, 1, 137);
insert into PLAYCOPY (copyid, available, playid)
values (88, 1, 349);
insert into PLAYCOPY (copyid, available, playid)
values (89, 0, 263);
insert into PLAYCOPY (copyid, available, playid)
values (90, 1, 190);
insert into PLAYCOPY (copyid, available, playid)
values (91, 0, 67);
insert into PLAYCOPY (copyid, available, playid)
values (92, 0, 122);
insert into PLAYCOPY (copyid, available, playid)
values (93, 0, 339);
insert into PLAYCOPY (copyid, available, playid)
values (94, 1, 247);
insert into PLAYCOPY (copyid, available, playid)
values (95, 1, 386);
insert into PLAYCOPY (copyid, available, playid)
values (96, 0, 316);
insert into PLAYCOPY (copyid, available, playid)
values (97, 1, 387);
insert into PLAYCOPY (copyid, available, playid)
values (98, 1, 148);
insert into PLAYCOPY (copyid, available, playid)
values (99, 1, 62);
insert into PLAYCOPY (copyid, available, playid)
values (100, 1, 325);
commit;
prompt 100 records committed...
insert into PLAYCOPY (copyid, available, playid)
values (101, 0, 275);
insert into PLAYCOPY (copyid, available, playid)
values (102, 1, 209);
insert into PLAYCOPY (copyid, available, playid)
values (103, 0, 290);
insert into PLAYCOPY (copyid, available, playid)
values (104, 1, 66);
insert into PLAYCOPY (copyid, available, playid)
values (105, 0, 293);
insert into PLAYCOPY (copyid, available, playid)
values (106, 0, 146);
insert into PLAYCOPY (copyid, available, playid)
values (107, 1, 111);
insert into PLAYCOPY (copyid, available, playid)
values (108, 1, 111);
insert into PLAYCOPY (copyid, available, playid)
values (109, 1, 334);
insert into PLAYCOPY (copyid, available, playid)
values (110, 0, 263);
insert into PLAYCOPY (copyid, available, playid)
values (111, 0, 163);
insert into PLAYCOPY (copyid, available, playid)
values (112, 1, 142);
insert into PLAYCOPY (copyid, available, playid)
values (113, 0, 8);
insert into PLAYCOPY (copyid, available, playid)
values (114, 0, 172);
insert into PLAYCOPY (copyid, available, playid)
values (115, 1, 148);
insert into PLAYCOPY (copyid, available, playid)
values (116, 1, 120);
insert into PLAYCOPY (copyid, available, playid)
values (117, 1, 72);
insert into PLAYCOPY (copyid, available, playid)
values (118, 0, 227);
insert into PLAYCOPY (copyid, available, playid)
values (119, 0, 29);
insert into PLAYCOPY (copyid, available, playid)
values (120, 0, 196);
insert into PLAYCOPY (copyid, available, playid)
values (121, 1, 388);
insert into PLAYCOPY (copyid, available, playid)
values (122, 1, 92);
insert into PLAYCOPY (copyid, available, playid)
values (123, 1, 152);
insert into PLAYCOPY (copyid, available, playid)
values (124, 0, 133);
insert into PLAYCOPY (copyid, available, playid)
values (125, 0, 11);
insert into PLAYCOPY (copyid, available, playid)
values (126, 0, 30);
insert into PLAYCOPY (copyid, available, playid)
values (127, 0, 292);
insert into PLAYCOPY (copyid, available, playid)
values (128, 1, 259);
insert into PLAYCOPY (copyid, available, playid)
values (129, 1, 190);
insert into PLAYCOPY (copyid, available, playid)
values (130, 0, 117);
insert into PLAYCOPY (copyid, available, playid)
values (131, 0, 23);
insert into PLAYCOPY (copyid, available, playid)
values (132, 1, 347);
insert into PLAYCOPY (copyid, available, playid)
values (133, 1, 311);
insert into PLAYCOPY (copyid, available, playid)
values (134, 1, 186);
insert into PLAYCOPY (copyid, available, playid)
values (135, 1, 16);
insert into PLAYCOPY (copyid, available, playid)
values (136, 0, 16);
insert into PLAYCOPY (copyid, available, playid)
values (137, 1, 348);
insert into PLAYCOPY (copyid, available, playid)
values (138, 1, 85);
insert into PLAYCOPY (copyid, available, playid)
values (139, 0, 259);
insert into PLAYCOPY (copyid, available, playid)
values (140, 0, 256);
insert into PLAYCOPY (copyid, available, playid)
values (141, 1, 249);
insert into PLAYCOPY (copyid, available, playid)
values (142, 0, 272);
insert into PLAYCOPY (copyid, available, playid)
values (143, 1, 400);
insert into PLAYCOPY (copyid, available, playid)
values (144, 1, 84);
insert into PLAYCOPY (copyid, available, playid)
values (145, 1, 247);
insert into PLAYCOPY (copyid, available, playid)
values (146, 1, 329);
insert into PLAYCOPY (copyid, available, playid)
values (147, 0, 225);
insert into PLAYCOPY (copyid, available, playid)
values (148, 1, 318);
insert into PLAYCOPY (copyid, available, playid)
values (149, 1, 90);
insert into PLAYCOPY (copyid, available, playid)
values (150, 1, 201);
insert into PLAYCOPY (copyid, available, playid)
values (151, 1, 248);
insert into PLAYCOPY (copyid, available, playid)
values (152, 0, 83);
insert into PLAYCOPY (copyid, available, playid)
values (153, 0, 1);
insert into PLAYCOPY (copyid, available, playid)
values (154, 1, 159);
insert into PLAYCOPY (copyid, available, playid)
values (155, 1, 35);
insert into PLAYCOPY (copyid, available, playid)
values (156, 1, 35);
insert into PLAYCOPY (copyid, available, playid)
values (157, 0, 163);
insert into PLAYCOPY (copyid, available, playid)
values (158, 0, 296);
insert into PLAYCOPY (copyid, available, playid)
values (159, 1, 249);
insert into PLAYCOPY (copyid, available, playid)
values (160, 1, 314);
insert into PLAYCOPY (copyid, available, playid)
values (161, 1, 324);
insert into PLAYCOPY (copyid, available, playid)
values (162, 0, 334);
insert into PLAYCOPY (copyid, available, playid)
values (163, 1, 21);
insert into PLAYCOPY (copyid, available, playid)
values (164, 0, 25);
insert into PLAYCOPY (copyid, available, playid)
values (165, 0, 336);
insert into PLAYCOPY (copyid, available, playid)
values (166, 1, 169);
insert into PLAYCOPY (copyid, available, playid)
values (167, 1, 49);
insert into PLAYCOPY (copyid, available, playid)
values (168, 0, 235);
insert into PLAYCOPY (copyid, available, playid)
values (169, 1, 8);
insert into PLAYCOPY (copyid, available, playid)
values (170, 1, 334);
insert into PLAYCOPY (copyid, available, playid)
values (171, 0, 213);
insert into PLAYCOPY (copyid, available, playid)
values (172, 1, 102);
insert into PLAYCOPY (copyid, available, playid)
values (173, 1, 294);
insert into PLAYCOPY (copyid, available, playid)
values (174, 1, 390);
insert into PLAYCOPY (copyid, available, playid)
values (175, 0, 128);
insert into PLAYCOPY (copyid, available, playid)
values (176, 1, 130);
insert into PLAYCOPY (copyid, available, playid)
values (177, 1, 197);
insert into PLAYCOPY (copyid, available, playid)
values (178, 1, 40);
insert into PLAYCOPY (copyid, available, playid)
values (179, 0, 210);
insert into PLAYCOPY (copyid, available, playid)
values (180, 1, 144);
insert into PLAYCOPY (copyid, available, playid)
values (181, 1, 209);
insert into PLAYCOPY (copyid, available, playid)
values (182, 0, 168);
insert into PLAYCOPY (copyid, available, playid)
values (183, 0, 75);
insert into PLAYCOPY (copyid, available, playid)
values (184, 0, 391);
insert into PLAYCOPY (copyid, available, playid)
values (185, 0, 262);
insert into PLAYCOPY (copyid, available, playid)
values (186, 1, 206);
insert into PLAYCOPY (copyid, available, playid)
values (187, 1, 258);
insert into PLAYCOPY (copyid, available, playid)
values (188, 1, 173);
insert into PLAYCOPY (copyid, available, playid)
values (189, 1, 218);
insert into PLAYCOPY (copyid, available, playid)
values (190, 0, 223);
insert into PLAYCOPY (copyid, available, playid)
values (191, 1, 61);
insert into PLAYCOPY (copyid, available, playid)
values (192, 1, 391);
insert into PLAYCOPY (copyid, available, playid)
values (193, 1, 75);
insert into PLAYCOPY (copyid, available, playid)
values (194, 0, 136);
insert into PLAYCOPY (copyid, available, playid)
values (195, 0, 323);
insert into PLAYCOPY (copyid, available, playid)
values (196, 0, 29);
insert into PLAYCOPY (copyid, available, playid)
values (197, 0, 298);
insert into PLAYCOPY (copyid, available, playid)
values (198, 1, 59);
insert into PLAYCOPY (copyid, available, playid)
values (199, 0, 316);
insert into PLAYCOPY (copyid, available, playid)
values (200, 0, 154);
commit;
prompt 200 records committed...
insert into PLAYCOPY (copyid, available, playid)
values (201, 1, 285);
insert into PLAYCOPY (copyid, available, playid)
values (202, 1, 157);
insert into PLAYCOPY (copyid, available, playid)
values (203, 1, 366);
insert into PLAYCOPY (copyid, available, playid)
values (204, 0, 244);
insert into PLAYCOPY (copyid, available, playid)
values (205, 0, 141);
insert into PLAYCOPY (copyid, available, playid)
values (206, 0, 44);
insert into PLAYCOPY (copyid, available, playid)
values (207, 1, 202);
insert into PLAYCOPY (copyid, available, playid)
values (208, 1, 38);
insert into PLAYCOPY (copyid, available, playid)
values (209, 0, 194);
insert into PLAYCOPY (copyid, available, playid)
values (210, 0, 94);
insert into PLAYCOPY (copyid, available, playid)
values (211, 1, 221);
insert into PLAYCOPY (copyid, available, playid)
values (212, 0, 117);
insert into PLAYCOPY (copyid, available, playid)
values (213, 1, 226);
insert into PLAYCOPY (copyid, available, playid)
values (214, 1, 281);
insert into PLAYCOPY (copyid, available, playid)
values (215, 1, 90);
insert into PLAYCOPY (copyid, available, playid)
values (216, 0, 4);
insert into PLAYCOPY (copyid, available, playid)
values (217, 1, 31);
insert into PLAYCOPY (copyid, available, playid)
values (218, 1, 146);
insert into PLAYCOPY (copyid, available, playid)
values (219, 0, 264);
insert into PLAYCOPY (copyid, available, playid)
values (220, 0, 192);
insert into PLAYCOPY (copyid, available, playid)
values (221, 1, 100);
insert into PLAYCOPY (copyid, available, playid)
values (222, 1, 285);
insert into PLAYCOPY (copyid, available, playid)
values (223, 1, 34);
insert into PLAYCOPY (copyid, available, playid)
values (224, 0, 95);
insert into PLAYCOPY (copyid, available, playid)
values (225, 1, 27);
insert into PLAYCOPY (copyid, available, playid)
values (226, 0, 164);
insert into PLAYCOPY (copyid, available, playid)
values (227, 0, 96);
insert into PLAYCOPY (copyid, available, playid)
values (228, 1, 327);
insert into PLAYCOPY (copyid, available, playid)
values (229, 1, 246);
insert into PLAYCOPY (copyid, available, playid)
values (230, 0, 257);
insert into PLAYCOPY (copyid, available, playid)
values (231, 0, 47);
insert into PLAYCOPY (copyid, available, playid)
values (232, 0, 106);
insert into PLAYCOPY (copyid, available, playid)
values (233, 0, 287);
insert into PLAYCOPY (copyid, available, playid)
values (234, 1, 117);
insert into PLAYCOPY (copyid, available, playid)
values (235, 1, 10);
insert into PLAYCOPY (copyid, available, playid)
values (236, 0, 176);
insert into PLAYCOPY (copyid, available, playid)
values (237, 1, 363);
insert into PLAYCOPY (copyid, available, playid)
values (238, 0, 360);
insert into PLAYCOPY (copyid, available, playid)
values (239, 1, 375);
insert into PLAYCOPY (copyid, available, playid)
values (240, 1, 65);
insert into PLAYCOPY (copyid, available, playid)
values (241, 1, 273);
insert into PLAYCOPY (copyid, available, playid)
values (242, 0, 179);
insert into PLAYCOPY (copyid, available, playid)
values (243, 1, 72);
insert into PLAYCOPY (copyid, available, playid)
values (244, 1, 58);
insert into PLAYCOPY (copyid, available, playid)
values (245, 0, 40);
insert into PLAYCOPY (copyid, available, playid)
values (246, 0, 391);
insert into PLAYCOPY (copyid, available, playid)
values (247, 1, 170);
insert into PLAYCOPY (copyid, available, playid)
values (248, 1, 304);
insert into PLAYCOPY (copyid, available, playid)
values (249, 1, 270);
insert into PLAYCOPY (copyid, available, playid)
values (250, 0, 393);
insert into PLAYCOPY (copyid, available, playid)
values (251, 1, 394);
insert into PLAYCOPY (copyid, available, playid)
values (252, 1, 237);
insert into PLAYCOPY (copyid, available, playid)
values (253, 1, 231);
insert into PLAYCOPY (copyid, available, playid)
values (254, 0, 260);
insert into PLAYCOPY (copyid, available, playid)
values (255, 0, 171);
insert into PLAYCOPY (copyid, available, playid)
values (256, 0, 334);
insert into PLAYCOPY (copyid, available, playid)
values (257, 1, 66);
insert into PLAYCOPY (copyid, available, playid)
values (258, 1, 354);
insert into PLAYCOPY (copyid, available, playid)
values (259, 1, 206);
insert into PLAYCOPY (copyid, available, playid)
values (260, 1, 191);
insert into PLAYCOPY (copyid, available, playid)
values (261, 0, 326);
insert into PLAYCOPY (copyid, available, playid)
values (262, 1, 65);
insert into PLAYCOPY (copyid, available, playid)
values (263, 1, 172);
insert into PLAYCOPY (copyid, available, playid)
values (264, 0, 123);
insert into PLAYCOPY (copyid, available, playid)
values (265, 1, 27);
insert into PLAYCOPY (copyid, available, playid)
values (266, 1, 79);
insert into PLAYCOPY (copyid, available, playid)
values (267, 1, 136);
insert into PLAYCOPY (copyid, available, playid)
values (268, 1, 295);
insert into PLAYCOPY (copyid, available, playid)
values (269, 1, 34);
insert into PLAYCOPY (copyid, available, playid)
values (270, 1, 163);
insert into PLAYCOPY (copyid, available, playid)
values (271, 1, 102);
insert into PLAYCOPY (copyid, available, playid)
values (272, 1, 169);
insert into PLAYCOPY (copyid, available, playid)
values (273, 1, 170);
insert into PLAYCOPY (copyid, available, playid)
values (274, 0, 85);
insert into PLAYCOPY (copyid, available, playid)
values (275, 0, 82);
insert into PLAYCOPY (copyid, available, playid)
values (276, 1, 287);
insert into PLAYCOPY (copyid, available, playid)
values (277, 1, 49);
insert into PLAYCOPY (copyid, available, playid)
values (278, 1, 48);
insert into PLAYCOPY (copyid, available, playid)
values (279, 0, 297);
insert into PLAYCOPY (copyid, available, playid)
values (280, 1, 372);
insert into PLAYCOPY (copyid, available, playid)
values (281, 1, 38);
insert into PLAYCOPY (copyid, available, playid)
values (282, 0, 261);
insert into PLAYCOPY (copyid, available, playid)
values (283, 0, 289);
insert into PLAYCOPY (copyid, available, playid)
values (284, 1, 152);
insert into PLAYCOPY (copyid, available, playid)
values (285, 1, 334);
insert into PLAYCOPY (copyid, available, playid)
values (286, 0, 24);
insert into PLAYCOPY (copyid, available, playid)
values (287, 0, 177);
insert into PLAYCOPY (copyid, available, playid)
values (288, 0, 116);
insert into PLAYCOPY (copyid, available, playid)
values (289, 0, 179);
insert into PLAYCOPY (copyid, available, playid)
values (290, 1, 347);
insert into PLAYCOPY (copyid, available, playid)
values (291, 0, 20);
insert into PLAYCOPY (copyid, available, playid)
values (292, 1, 190);
insert into PLAYCOPY (copyid, available, playid)
values (293, 0, 388);
insert into PLAYCOPY (copyid, available, playid)
values (294, 1, 84);
insert into PLAYCOPY (copyid, available, playid)
values (295, 1, 120);
insert into PLAYCOPY (copyid, available, playid)
values (296, 0, 339);
insert into PLAYCOPY (copyid, available, playid)
values (297, 0, 14);
insert into PLAYCOPY (copyid, available, playid)
values (298, 1, 6);
insert into PLAYCOPY (copyid, available, playid)
values (299, 1, 236);
insert into PLAYCOPY (copyid, available, playid)
values (300, 0, 294);
commit;
prompt 300 records committed...
insert into PLAYCOPY (copyid, available, playid)
values (301, 0, 326);
insert into PLAYCOPY (copyid, available, playid)
values (302, 1, 381);
insert into PLAYCOPY (copyid, available, playid)
values (303, 1, 137);
insert into PLAYCOPY (copyid, available, playid)
values (304, 1, 6);
insert into PLAYCOPY (copyid, available, playid)
values (305, 0, 119);
insert into PLAYCOPY (copyid, available, playid)
values (306, 0, 99);
insert into PLAYCOPY (copyid, available, playid)
values (307, 1, 268);
insert into PLAYCOPY (copyid, available, playid)
values (308, 0, 24);
insert into PLAYCOPY (copyid, available, playid)
values (309, 1, 351);
insert into PLAYCOPY (copyid, available, playid)
values (310, 0, 104);
insert into PLAYCOPY (copyid, available, playid)
values (311, 0, 148);
insert into PLAYCOPY (copyid, available, playid)
values (312, 0, 192);
insert into PLAYCOPY (copyid, available, playid)
values (313, 0, 97);
insert into PLAYCOPY (copyid, available, playid)
values (314, 0, 362);
insert into PLAYCOPY (copyid, available, playid)
values (315, 0, 92);
insert into PLAYCOPY (copyid, available, playid)
values (316, 1, 284);
insert into PLAYCOPY (copyid, available, playid)
values (317, 0, 233);
insert into PLAYCOPY (copyid, available, playid)
values (318, 0, 353);
insert into PLAYCOPY (copyid, available, playid)
values (319, 1, 255);
insert into PLAYCOPY (copyid, available, playid)
values (320, 0, 149);
insert into PLAYCOPY (copyid, available, playid)
values (321, 1, 50);
insert into PLAYCOPY (copyid, available, playid)
values (322, 1, 280);
insert into PLAYCOPY (copyid, available, playid)
values (323, 0, 205);
insert into PLAYCOPY (copyid, available, playid)
values (324, 0, 194);
insert into PLAYCOPY (copyid, available, playid)
values (325, 0, 379);
insert into PLAYCOPY (copyid, available, playid)
values (326, 1, 215);
insert into PLAYCOPY (copyid, available, playid)
values (327, 1, 219);
insert into PLAYCOPY (copyid, available, playid)
values (328, 1, 184);
insert into PLAYCOPY (copyid, available, playid)
values (329, 0, 59);
insert into PLAYCOPY (copyid, available, playid)
values (330, 0, 361);
insert into PLAYCOPY (copyid, available, playid)
values (331, 0, 302);
insert into PLAYCOPY (copyid, available, playid)
values (332, 1, 368);
insert into PLAYCOPY (copyid, available, playid)
values (333, 1, 112);
insert into PLAYCOPY (copyid, available, playid)
values (334, 1, 39);
insert into PLAYCOPY (copyid, available, playid)
values (335, 1, 135);
insert into PLAYCOPY (copyid, available, playid)
values (336, 1, 135);
insert into PLAYCOPY (copyid, available, playid)
values (337, 1, 58);
insert into PLAYCOPY (copyid, available, playid)
values (338, 1, 211);
insert into PLAYCOPY (copyid, available, playid)
values (339, 1, 345);
insert into PLAYCOPY (copyid, available, playid)
values (340, 1, 188);
insert into PLAYCOPY (copyid, available, playid)
values (341, 1, 344);
insert into PLAYCOPY (copyid, available, playid)
values (342, 1, 310);
insert into PLAYCOPY (copyid, available, playid)
values (343, 0, 303);
insert into PLAYCOPY (copyid, available, playid)
values (344, 0, 246);
insert into PLAYCOPY (copyid, available, playid)
values (345, 0, 106);
insert into PLAYCOPY (copyid, available, playid)
values (346, 0, 212);
insert into PLAYCOPY (copyid, available, playid)
values (347, 1, 44);
insert into PLAYCOPY (copyid, available, playid)
values (348, 1, 276);
insert into PLAYCOPY (copyid, available, playid)
values (349, 1, 251);
insert into PLAYCOPY (copyid, available, playid)
values (350, 1, 122);
insert into PLAYCOPY (copyid, available, playid)
values (351, 1, 311);
insert into PLAYCOPY (copyid, available, playid)
values (352, 0, 39);
insert into PLAYCOPY (copyid, available, playid)
values (353, 0, 265);
insert into PLAYCOPY (copyid, available, playid)
values (354, 1, 393);
insert into PLAYCOPY (copyid, available, playid)
values (355, 1, 329);
insert into PLAYCOPY (copyid, available, playid)
values (356, 1, 173);
insert into PLAYCOPY (copyid, available, playid)
values (357, 1, 348);
insert into PLAYCOPY (copyid, available, playid)
values (358, 0, 59);
insert into PLAYCOPY (copyid, available, playid)
values (359, 1, 100);
insert into PLAYCOPY (copyid, available, playid)
values (360, 1, 392);
insert into PLAYCOPY (copyid, available, playid)
values (361, 1, 73);
insert into PLAYCOPY (copyid, available, playid)
values (362, 0, 108);
insert into PLAYCOPY (copyid, available, playid)
values (363, 0, 26);
insert into PLAYCOPY (copyid, available, playid)
values (364, 1, 14);
insert into PLAYCOPY (copyid, available, playid)
values (365, 1, 366);
insert into PLAYCOPY (copyid, available, playid)
values (366, 0, 264);
insert into PLAYCOPY (copyid, available, playid)
values (367, 0, 249);
insert into PLAYCOPY (copyid, available, playid)
values (368, 1, 13);
insert into PLAYCOPY (copyid, available, playid)
values (369, 0, 21);
insert into PLAYCOPY (copyid, available, playid)
values (370, 1, 109);
insert into PLAYCOPY (copyid, available, playid)
values (371, 0, 131);
insert into PLAYCOPY (copyid, available, playid)
values (372, 1, 199);
insert into PLAYCOPY (copyid, available, playid)
values (373, 0, 326);
insert into PLAYCOPY (copyid, available, playid)
values (374, 1, 117);
insert into PLAYCOPY (copyid, available, playid)
values (375, 1, 242);
insert into PLAYCOPY (copyid, available, playid)
values (376, 1, 316);
insert into PLAYCOPY (copyid, available, playid)
values (377, 0, 226);
insert into PLAYCOPY (copyid, available, playid)
values (378, 0, 223);
insert into PLAYCOPY (copyid, available, playid)
values (379, 0, 87);
insert into PLAYCOPY (copyid, available, playid)
values (380, 1, 273);
insert into PLAYCOPY (copyid, available, playid)
values (381, 0, 10);
insert into PLAYCOPY (copyid, available, playid)
values (382, 1, 309);
insert into PLAYCOPY (copyid, available, playid)
values (383, 1, 348);
insert into PLAYCOPY (copyid, available, playid)
values (384, 0, 294);
insert into PLAYCOPY (copyid, available, playid)
values (385, 1, 309);
insert into PLAYCOPY (copyid, available, playid)
values (386, 0, 224);
insert into PLAYCOPY (copyid, available, playid)
values (387, 1, 57);
insert into PLAYCOPY (copyid, available, playid)
values (388, 0, 197);
insert into PLAYCOPY (copyid, available, playid)
values (389, 1, 42);
insert into PLAYCOPY (copyid, available, playid)
values (390, 0, 118);
insert into PLAYCOPY (copyid, available, playid)
values (391, 1, 292);
insert into PLAYCOPY (copyid, available, playid)
values (392, 1, 195);
insert into PLAYCOPY (copyid, available, playid)
values (393, 0, 65);
insert into PLAYCOPY (copyid, available, playid)
values (394, 0, 311);
insert into PLAYCOPY (copyid, available, playid)
values (395, 0, 399);
insert into PLAYCOPY (copyid, available, playid)
values (396, 1, 25);
insert into PLAYCOPY (copyid, available, playid)
values (397, 1, 161);
insert into PLAYCOPY (copyid, available, playid)
values (398, 1, 282);
insert into PLAYCOPY (copyid, available, playid)
values (399, 0, 335);
insert into PLAYCOPY (copyid, available, playid)
values (400, 1, 398);
commit;
prompt 400 records committed...
insert into PLAYCOPY (copyid, available, playid)
values (401, 1, 144);
insert into PLAYCOPY (copyid, available, playid)
values (402, 1, 382);
insert into PLAYCOPY (copyid, available, playid)
values (403, 1, 343);
insert into PLAYCOPY (copyid, available, playid)
values (404, 0, 378);
insert into PLAYCOPY (copyid, available, playid)
values (405, 0, 294);
insert into PLAYCOPY (copyid, available, playid)
values (406, 1, 277);
insert into PLAYCOPY (copyid, available, playid)
values (407, 0, 344);
insert into PLAYCOPY (copyid, available, playid)
values (408, 1, 285);
insert into PLAYCOPY (copyid, available, playid)
values (409, 1, 319);
insert into PLAYCOPY (copyid, available, playid)
values (410, 0, 109);
insert into PLAYCOPY (copyid, available, playid)
values (411, 1, 263);
insert into PLAYCOPY (copyid, available, playid)
values (412, 0, 121);
insert into PLAYCOPY (copyid, available, playid)
values (413, 0, 33);
insert into PLAYCOPY (copyid, available, playid)
values (414, 0, 389);
insert into PLAYCOPY (copyid, available, playid)
values (415, 0, 71);
insert into PLAYCOPY (copyid, available, playid)
values (416, 0, 322);
insert into PLAYCOPY (copyid, available, playid)
values (417, 0, 169);
insert into PLAYCOPY (copyid, available, playid)
values (418, 1, 211);
insert into PLAYCOPY (copyid, available, playid)
values (419, 0, 356);
insert into PLAYCOPY (copyid, available, playid)
values (420, 0, 36);
insert into PLAYCOPY (copyid, available, playid)
values (421, 1, 110);
insert into PLAYCOPY (copyid, available, playid)
values (422, 1, 192);
insert into PLAYCOPY (copyid, available, playid)
values (423, 0, 224);
insert into PLAYCOPY (copyid, available, playid)
values (424, 1, 126);
insert into PLAYCOPY (copyid, available, playid)
values (425, 0, 148);
insert into PLAYCOPY (copyid, available, playid)
values (426, 1, 134);
insert into PLAYCOPY (copyid, available, playid)
values (427, 1, 113);
insert into PLAYCOPY (copyid, available, playid)
values (428, 0, 96);
insert into PLAYCOPY (copyid, available, playid)
values (429, 0, 269);
insert into PLAYCOPY (copyid, available, playid)
values (430, 0, 218);
insert into PLAYCOPY (copyid, available, playid)
values (431, 1, 346);
insert into PLAYCOPY (copyid, available, playid)
values (432, 0, 146);
insert into PLAYCOPY (copyid, available, playid)
values (433, 0, 262);
insert into PLAYCOPY (copyid, available, playid)
values (434, 1, 119);
insert into PLAYCOPY (copyid, available, playid)
values (435, 1, 197);
insert into PLAYCOPY (copyid, available, playid)
values (436, 1, 344);
insert into PLAYCOPY (copyid, available, playid)
values (437, 1, 348);
insert into PLAYCOPY (copyid, available, playid)
values (438, 0, 40);
insert into PLAYCOPY (copyid, available, playid)
values (439, 0, 288);
insert into PLAYCOPY (copyid, available, playid)
values (440, 0, 135);
insert into PLAYCOPY (copyid, available, playid)
values (441, 0, 344);
insert into PLAYCOPY (copyid, available, playid)
values (442, 1, 84);
insert into PLAYCOPY (copyid, available, playid)
values (443, 0, 314);
insert into PLAYCOPY (copyid, available, playid)
values (444, 0, 164);
insert into PLAYCOPY (copyid, available, playid)
values (445, 0, 144);
insert into PLAYCOPY (copyid, available, playid)
values (446, 1, 339);
insert into PLAYCOPY (copyid, available, playid)
values (447, 0, 84);
insert into PLAYCOPY (copyid, available, playid)
values (448, 1, 29);
insert into PLAYCOPY (copyid, available, playid)
values (449, 1, 329);
insert into PLAYCOPY (copyid, available, playid)
values (450, 1, 94);
insert into PLAYCOPY (copyid, available, playid)
values (451, 0, 294);
insert into PLAYCOPY (copyid, available, playid)
values (452, 1, 359);
insert into PLAYCOPY (copyid, available, playid)
values (453, 0, 99);
insert into PLAYCOPY (copyid, available, playid)
values (454, 0, 182);
insert into PLAYCOPY (copyid, available, playid)
values (455, 0, 225);
insert into PLAYCOPY (copyid, available, playid)
values (456, 0, 16);
insert into PLAYCOPY (copyid, available, playid)
values (457, 1, 130);
insert into PLAYCOPY (copyid, available, playid)
values (458, 1, 39);
insert into PLAYCOPY (copyid, available, playid)
values (459, 1, 361);
insert into PLAYCOPY (copyid, available, playid)
values (460, 0, 23);
insert into PLAYCOPY (copyid, available, playid)
values (461, 0, 364);
insert into PLAYCOPY (copyid, available, playid)
values (462, 1, 300);
insert into PLAYCOPY (copyid, available, playid)
values (463, 0, 337);
insert into PLAYCOPY (copyid, available, playid)
values (464, 1, 215);
insert into PLAYCOPY (copyid, available, playid)
values (465, 1, 311);
insert into PLAYCOPY (copyid, available, playid)
values (466, 0, 108);
insert into PLAYCOPY (copyid, available, playid)
values (467, 1, 210);
insert into PLAYCOPY (copyid, available, playid)
values (468, 1, 217);
insert into PLAYCOPY (copyid, available, playid)
values (469, 1, 284);
insert into PLAYCOPY (copyid, available, playid)
values (470, 1, 358);
insert into PLAYCOPY (copyid, available, playid)
values (471, 0, 253);
insert into PLAYCOPY (copyid, available, playid)
values (472, 1, 349);
insert into PLAYCOPY (copyid, available, playid)
values (473, 1, 362);
insert into PLAYCOPY (copyid, available, playid)
values (474, 0, 61);
insert into PLAYCOPY (copyid, available, playid)
values (475, 1, 81);
insert into PLAYCOPY (copyid, available, playid)
values (476, 0, 48);
insert into PLAYCOPY (copyid, available, playid)
values (477, 0, 266);
insert into PLAYCOPY (copyid, available, playid)
values (478, 0, 234);
insert into PLAYCOPY (copyid, available, playid)
values (479, 0, 291);
insert into PLAYCOPY (copyid, available, playid)
values (480, 1, 224);
insert into PLAYCOPY (copyid, available, playid)
values (481, 0, 176);
insert into PLAYCOPY (copyid, available, playid)
values (482, 1, 111);
insert into PLAYCOPY (copyid, available, playid)
values (483, 1, 237);
insert into PLAYCOPY (copyid, available, playid)
values (484, 1, 337);
insert into PLAYCOPY (copyid, available, playid)
values (485, 0, 57);
insert into PLAYCOPY (copyid, available, playid)
values (486, 1, 90);
insert into PLAYCOPY (copyid, available, playid)
values (487, 0, 324);
insert into PLAYCOPY (copyid, available, playid)
values (488, 1, 199);
insert into PLAYCOPY (copyid, available, playid)
values (489, 1, 324);
insert into PLAYCOPY (copyid, available, playid)
values (490, 0, 192);
insert into PLAYCOPY (copyid, available, playid)
values (491, 0, 33);
insert into PLAYCOPY (copyid, available, playid)
values (492, 0, 100);
insert into PLAYCOPY (copyid, available, playid)
values (493, 0, 219);
insert into PLAYCOPY (copyid, available, playid)
values (494, 1, 53);
insert into PLAYCOPY (copyid, available, playid)
values (495, 1, 62);
insert into PLAYCOPY (copyid, available, playid)
values (496, 1, 62);
insert into PLAYCOPY (copyid, available, playid)
values (497, 0, 327);
insert into PLAYCOPY (copyid, available, playid)
values (498, 1, 38);
insert into PLAYCOPY (copyid, available, playid)
values (499, 1, 199);
insert into PLAYCOPY (copyid, available, playid)
values (500, 1, 218);
commit;
prompt 500 records committed...
insert into PLAYCOPY (copyid, available, playid)
values (501, 0, 2);
insert into PLAYCOPY (copyid, available, playid)
values (502, 0, 282);
insert into PLAYCOPY (copyid, available, playid)
values (503, 1, 119);
insert into PLAYCOPY (copyid, available, playid)
values (504, 0, 309);
insert into PLAYCOPY (copyid, available, playid)
values (505, 0, 133);
insert into PLAYCOPY (copyid, available, playid)
values (506, 1, 55);
insert into PLAYCOPY (copyid, available, playid)
values (507, 1, 307);
insert into PLAYCOPY (copyid, available, playid)
values (508, 1, 317);
insert into PLAYCOPY (copyid, available, playid)
values (509, 1, 22);
insert into PLAYCOPY (copyid, available, playid)
values (510, 1, 251);
insert into PLAYCOPY (copyid, available, playid)
values (511, 0, 297);
insert into PLAYCOPY (copyid, available, playid)
values (512, 1, 214);
insert into PLAYCOPY (copyid, available, playid)
values (513, 0, 395);
insert into PLAYCOPY (copyid, available, playid)
values (514, 0, 201);
insert into PLAYCOPY (copyid, available, playid)
values (515, 0, 251);
insert into PLAYCOPY (copyid, available, playid)
values (516, 0, 40);
insert into PLAYCOPY (copyid, available, playid)
values (517, 1, 134);
insert into PLAYCOPY (copyid, available, playid)
values (518, 1, 17);
insert into PLAYCOPY (copyid, available, playid)
values (519, 1, 252);
insert into PLAYCOPY (copyid, available, playid)
values (520, 0, 306);
insert into PLAYCOPY (copyid, available, playid)
values (521, 1, 338);
insert into PLAYCOPY (copyid, available, playid)
values (522, 1, 55);
insert into PLAYCOPY (copyid, available, playid)
values (523, 1, 122);
insert into PLAYCOPY (copyid, available, playid)
values (524, 1, 322);
insert into PLAYCOPY (copyid, available, playid)
values (525, 0, 107);
insert into PLAYCOPY (copyid, available, playid)
values (526, 1, 303);
insert into PLAYCOPY (copyid, available, playid)
values (527, 1, 175);
insert into PLAYCOPY (copyid, available, playid)
values (528, 1, 46);
insert into PLAYCOPY (copyid, available, playid)
values (529, 0, 44);
insert into PLAYCOPY (copyid, available, playid)
values (530, 1, 97);
insert into PLAYCOPY (copyid, available, playid)
values (531, 0, 81);
insert into PLAYCOPY (copyid, available, playid)
values (532, 1, 265);
insert into PLAYCOPY (copyid, available, playid)
values (533, 1, 299);
insert into PLAYCOPY (copyid, available, playid)
values (534, 0, 163);
insert into PLAYCOPY (copyid, available, playid)
values (535, 1, 265);
insert into PLAYCOPY (copyid, available, playid)
values (536, 0, 297);
insert into PLAYCOPY (copyid, available, playid)
values (537, 0, 319);
insert into PLAYCOPY (copyid, available, playid)
values (538, 1, 179);
insert into PLAYCOPY (copyid, available, playid)
values (539, 0, 232);
insert into PLAYCOPY (copyid, available, playid)
values (540, 0, 16);
insert into PLAYCOPY (copyid, available, playid)
values (541, 0, 335);
insert into PLAYCOPY (copyid, available, playid)
values (542, 0, 266);
insert into PLAYCOPY (copyid, available, playid)
values (543, 1, 206);
insert into PLAYCOPY (copyid, available, playid)
values (544, 0, 206);
insert into PLAYCOPY (copyid, available, playid)
values (545, 0, 170);
insert into PLAYCOPY (copyid, available, playid)
values (546, 1, 2);
insert into PLAYCOPY (copyid, available, playid)
values (547, 0, 104);
insert into PLAYCOPY (copyid, available, playid)
values (548, 0, 37);
insert into PLAYCOPY (copyid, available, playid)
values (549, 0, 176);
insert into PLAYCOPY (copyid, available, playid)
values (550, 1, 165);
insert into PLAYCOPY (copyid, available, playid)
values (551, 1, 236);
insert into PLAYCOPY (copyid, available, playid)
values (552, 0, 71);
insert into PLAYCOPY (copyid, available, playid)
values (553, 0, 285);
insert into PLAYCOPY (copyid, available, playid)
values (554, 1, 393);
insert into PLAYCOPY (copyid, available, playid)
values (555, 1, 120);
insert into PLAYCOPY (copyid, available, playid)
values (556, 0, 384);
insert into PLAYCOPY (copyid, available, playid)
values (557, 1, 400);
insert into PLAYCOPY (copyid, available, playid)
values (558, 0, 376);
insert into PLAYCOPY (copyid, available, playid)
values (559, 0, 231);
insert into PLAYCOPY (copyid, available, playid)
values (560, 1, 223);
insert into PLAYCOPY (copyid, available, playid)
values (561, 1, 100);
insert into PLAYCOPY (copyid, available, playid)
values (562, 1, 175);
insert into PLAYCOPY (copyid, available, playid)
values (563, 0, 272);
insert into PLAYCOPY (copyid, available, playid)
values (564, 1, 380);
insert into PLAYCOPY (copyid, available, playid)
values (565, 0, 73);
insert into PLAYCOPY (copyid, available, playid)
values (566, 0, 52);
insert into PLAYCOPY (copyid, available, playid)
values (567, 1, 371);
insert into PLAYCOPY (copyid, available, playid)
values (568, 1, 296);
insert into PLAYCOPY (copyid, available, playid)
values (569, 1, 79);
insert into PLAYCOPY (copyid, available, playid)
values (570, 1, 246);
insert into PLAYCOPY (copyid, available, playid)
values (571, 1, 400);
insert into PLAYCOPY (copyid, available, playid)
values (572, 0, 290);
insert into PLAYCOPY (copyid, available, playid)
values (573, 0, 227);
insert into PLAYCOPY (copyid, available, playid)
values (574, 1, 255);
insert into PLAYCOPY (copyid, available, playid)
values (575, 0, 222);
insert into PLAYCOPY (copyid, available, playid)
values (576, 1, 107);
insert into PLAYCOPY (copyid, available, playid)
values (577, 1, 389);
insert into PLAYCOPY (copyid, available, playid)
values (578, 1, 53);
insert into PLAYCOPY (copyid, available, playid)
values (579, 1, 63);
insert into PLAYCOPY (copyid, available, playid)
values (580, 0, 199);
insert into PLAYCOPY (copyid, available, playid)
values (581, 1, 132);
insert into PLAYCOPY (copyid, available, playid)
values (582, 1, 34);
insert into PLAYCOPY (copyid, available, playid)
values (583, 1, 207);
insert into PLAYCOPY (copyid, available, playid)
values (584, 0, 125);
insert into PLAYCOPY (copyid, available, playid)
values (585, 1, 374);
insert into PLAYCOPY (copyid, available, playid)
values (586, 0, 68);
insert into PLAYCOPY (copyid, available, playid)
values (587, 0, 18);
insert into PLAYCOPY (copyid, available, playid)
values (588, 1, 81);
insert into PLAYCOPY (copyid, available, playid)
values (589, 1, 372);
insert into PLAYCOPY (copyid, available, playid)
values (590, 0, 100);
insert into PLAYCOPY (copyid, available, playid)
values (591, 1, 283);
insert into PLAYCOPY (copyid, available, playid)
values (592, 1, 350);
insert into PLAYCOPY (copyid, available, playid)
values (593, 0, 28);
insert into PLAYCOPY (copyid, available, playid)
values (594, 1, 259);
insert into PLAYCOPY (copyid, available, playid)
values (595, 1, 90);
insert into PLAYCOPY (copyid, available, playid)
values (596, 1, 281);
insert into PLAYCOPY (copyid, available, playid)
values (597, 1, 323);
insert into PLAYCOPY (copyid, available, playid)
values (598, 0, 101);
insert into PLAYCOPY (copyid, available, playid)
values (599, 1, 215);
insert into PLAYCOPY (copyid, available, playid)
values (600, 0, 389);
commit;
prompt 600 records committed...
insert into PLAYCOPY (copyid, available, playid)
values (601, 0, 274);
insert into PLAYCOPY (copyid, available, playid)
values (602, 0, 170);
insert into PLAYCOPY (copyid, available, playid)
values (603, 1, 251);
insert into PLAYCOPY (copyid, available, playid)
values (604, 0, 384);
insert into PLAYCOPY (copyid, available, playid)
values (605, 1, 22);
insert into PLAYCOPY (copyid, available, playid)
values (606, 1, 294);
insert into PLAYCOPY (copyid, available, playid)
values (607, 1, 250);
insert into PLAYCOPY (copyid, available, playid)
values (608, 1, 325);
insert into PLAYCOPY (copyid, available, playid)
values (609, 1, 36);
insert into PLAYCOPY (copyid, available, playid)
values (610, 1, 193);
insert into PLAYCOPY (copyid, available, playid)
values (611, 0, 94);
insert into PLAYCOPY (copyid, available, playid)
values (612, 1, 94);
insert into PLAYCOPY (copyid, available, playid)
values (613, 1, 49);
insert into PLAYCOPY (copyid, available, playid)
values (614, 1, 25);
insert into PLAYCOPY (copyid, available, playid)
values (615, 1, 194);
insert into PLAYCOPY (copyid, available, playid)
values (616, 0, 1);
insert into PLAYCOPY (copyid, available, playid)
values (617, 1, 116);
insert into PLAYCOPY (copyid, available, playid)
values (618, 1, 45);
insert into PLAYCOPY (copyid, available, playid)
values (619, 1, 308);
insert into PLAYCOPY (copyid, available, playid)
values (620, 0, 108);
insert into PLAYCOPY (copyid, available, playid)
values (621, 1, 196);
insert into PLAYCOPY (copyid, available, playid)
values (622, 1, 199);
insert into PLAYCOPY (copyid, available, playid)
values (623, 0, 87);
insert into PLAYCOPY (copyid, available, playid)
values (624, 1, 286);
insert into PLAYCOPY (copyid, available, playid)
values (625, 1, 265);
insert into PLAYCOPY (copyid, available, playid)
values (626, 0, 39);
insert into PLAYCOPY (copyid, available, playid)
values (627, 1, 151);
insert into PLAYCOPY (copyid, available, playid)
values (628, 0, 189);
insert into PLAYCOPY (copyid, available, playid)
values (629, 1, 145);
insert into PLAYCOPY (copyid, available, playid)
values (630, 0, 160);
insert into PLAYCOPY (copyid, available, playid)
values (631, 1, 77);
insert into PLAYCOPY (copyid, available, playid)
values (632, 1, 357);
insert into PLAYCOPY (copyid, available, playid)
values (633, 1, 265);
insert into PLAYCOPY (copyid, available, playid)
values (634, 0, 365);
insert into PLAYCOPY (copyid, available, playid)
values (635, 0, 128);
insert into PLAYCOPY (copyid, available, playid)
values (636, 0, 43);
insert into PLAYCOPY (copyid, available, playid)
values (637, 1, 143);
insert into PLAYCOPY (copyid, available, playid)
values (638, 1, 160);
insert into PLAYCOPY (copyid, available, playid)
values (639, 0, 293);
insert into PLAYCOPY (copyid, available, playid)
values (640, 0, 168);
insert into PLAYCOPY (copyid, available, playid)
values (641, 0, 197);
insert into PLAYCOPY (copyid, available, playid)
values (642, 1, 361);
insert into PLAYCOPY (copyid, available, playid)
values (643, 1, 264);
insert into PLAYCOPY (copyid, available, playid)
values (644, 1, 195);
insert into PLAYCOPY (copyid, available, playid)
values (645, 1, 76);
insert into PLAYCOPY (copyid, available, playid)
values (646, 1, 240);
insert into PLAYCOPY (copyid, available, playid)
values (647, 1, 326);
insert into PLAYCOPY (copyid, available, playid)
values (648, 0, 131);
insert into PLAYCOPY (copyid, available, playid)
values (649, 1, 321);
insert into PLAYCOPY (copyid, available, playid)
values (650, 1, 187);
insert into PLAYCOPY (copyid, available, playid)
values (651, 0, 381);
insert into PLAYCOPY (copyid, available, playid)
values (652, 1, 60);
insert into PLAYCOPY (copyid, available, playid)
values (653, 0, 145);
insert into PLAYCOPY (copyid, available, playid)
values (654, 0, 301);
insert into PLAYCOPY (copyid, available, playid)
values (655, 0, 297);
insert into PLAYCOPY (copyid, available, playid)
values (656, 0, 388);
insert into PLAYCOPY (copyid, available, playid)
values (657, 1, 147);
insert into PLAYCOPY (copyid, available, playid)
values (658, 1, 104);
insert into PLAYCOPY (copyid, available, playid)
values (659, 0, 371);
insert into PLAYCOPY (copyid, available, playid)
values (660, 1, 24);
insert into PLAYCOPY (copyid, available, playid)
values (661, 1, 339);
insert into PLAYCOPY (copyid, available, playid)
values (662, 0, 181);
insert into PLAYCOPY (copyid, available, playid)
values (663, 0, 336);
insert into PLAYCOPY (copyid, available, playid)
values (664, 0, 83);
insert into PLAYCOPY (copyid, available, playid)
values (665, 0, 312);
insert into PLAYCOPY (copyid, available, playid)
values (666, 1, 145);
insert into PLAYCOPY (copyid, available, playid)
values (667, 1, 71);
insert into PLAYCOPY (copyid, available, playid)
values (668, 0, 312);
insert into PLAYCOPY (copyid, available, playid)
values (669, 0, 313);
insert into PLAYCOPY (copyid, available, playid)
values (670, 1, 129);
insert into PLAYCOPY (copyid, available, playid)
values (671, 1, 57);
insert into PLAYCOPY (copyid, available, playid)
values (672, 1, 243);
insert into PLAYCOPY (copyid, available, playid)
values (673, 1, 58);
insert into PLAYCOPY (copyid, available, playid)
values (674, 0, 195);
insert into PLAYCOPY (copyid, available, playid)
values (675, 0, 340);
insert into PLAYCOPY (copyid, available, playid)
values (676, 1, 269);
insert into PLAYCOPY (copyid, available, playid)
values (677, 0, 62);
insert into PLAYCOPY (copyid, available, playid)
values (678, 0, 80);
insert into PLAYCOPY (copyid, available, playid)
values (679, 0, 32);
insert into PLAYCOPY (copyid, available, playid)
values (680, 1, 249);
insert into PLAYCOPY (copyid, available, playid)
values (681, 1, 300);
insert into PLAYCOPY (copyid, available, playid)
values (682, 0, 58);
insert into PLAYCOPY (copyid, available, playid)
values (683, 0, 131);
insert into PLAYCOPY (copyid, available, playid)
values (684, 0, 32);
insert into PLAYCOPY (copyid, available, playid)
values (685, 0, 192);
insert into PLAYCOPY (copyid, available, playid)
values (686, 1, 131);
insert into PLAYCOPY (copyid, available, playid)
values (687, 1, 66);
insert into PLAYCOPY (copyid, available, playid)
values (688, 1, 312);
insert into PLAYCOPY (copyid, available, playid)
values (689, 1, 308);
insert into PLAYCOPY (copyid, available, playid)
values (690, 1, 341);
insert into PLAYCOPY (copyid, available, playid)
values (691, 1, 369);
insert into PLAYCOPY (copyid, available, playid)
values (692, 1, 205);
insert into PLAYCOPY (copyid, available, playid)
values (693, 0, 203);
insert into PLAYCOPY (copyid, available, playid)
values (694, 0, 215);
insert into PLAYCOPY (copyid, available, playid)
values (695, 1, 271);
insert into PLAYCOPY (copyid, available, playid)
values (696, 1, 350);
insert into PLAYCOPY (copyid, available, playid)
values (697, 1, 376);
insert into PLAYCOPY (copyid, available, playid)
values (698, 1, 123);
insert into PLAYCOPY (copyid, available, playid)
values (699, 0, 224);
insert into PLAYCOPY (copyid, available, playid)
values (700, 1, 335);
commit;
prompt 700 records committed...
insert into PLAYCOPY (copyid, available, playid)
values (701, 1, 356);
insert into PLAYCOPY (copyid, available, playid)
values (702, 0, 176);
insert into PLAYCOPY (copyid, available, playid)
values (703, 0, 145);
insert into PLAYCOPY (copyid, available, playid)
values (704, 0, 57);
insert into PLAYCOPY (copyid, available, playid)
values (705, 0, 104);
insert into PLAYCOPY (copyid, available, playid)
values (706, 0, 233);
insert into PLAYCOPY (copyid, available, playid)
values (707, 0, 189);
insert into PLAYCOPY (copyid, available, playid)
values (708, 1, 188);
insert into PLAYCOPY (copyid, available, playid)
values (709, 1, 353);
insert into PLAYCOPY (copyid, available, playid)
values (710, 0, 245);
insert into PLAYCOPY (copyid, available, playid)
values (711, 0, 42);
insert into PLAYCOPY (copyid, available, playid)
values (712, 0, 186);
insert into PLAYCOPY (copyid, available, playid)
values (713, 1, 264);
insert into PLAYCOPY (copyid, available, playid)
values (714, 0, 122);
insert into PLAYCOPY (copyid, available, playid)
values (715, 1, 348);
insert into PLAYCOPY (copyid, available, playid)
values (716, 1, 219);
insert into PLAYCOPY (copyid, available, playid)
values (717, 1, 10);
insert into PLAYCOPY (copyid, available, playid)
values (718, 0, 315);
insert into PLAYCOPY (copyid, available, playid)
values (719, 0, 249);
insert into PLAYCOPY (copyid, available, playid)
values (720, 1, 217);
insert into PLAYCOPY (copyid, available, playid)
values (721, 0, 284);
insert into PLAYCOPY (copyid, available, playid)
values (722, 0, 340);
insert into PLAYCOPY (copyid, available, playid)
values (723, 0, 260);
insert into PLAYCOPY (copyid, available, playid)
values (724, 1, 53);
insert into PLAYCOPY (copyid, available, playid)
values (725, 0, 334);
insert into PLAYCOPY (copyid, available, playid)
values (726, 0, 13);
insert into PLAYCOPY (copyid, available, playid)
values (727, 0, 63);
insert into PLAYCOPY (copyid, available, playid)
values (728, 1, 39);
insert into PLAYCOPY (copyid, available, playid)
values (729, 0, 118);
insert into PLAYCOPY (copyid, available, playid)
values (730, 1, 213);
insert into PLAYCOPY (copyid, available, playid)
values (731, 1, 28);
insert into PLAYCOPY (copyid, available, playid)
values (732, 1, 159);
insert into PLAYCOPY (copyid, available, playid)
values (733, 0, 193);
insert into PLAYCOPY (copyid, available, playid)
values (734, 0, 379);
insert into PLAYCOPY (copyid, available, playid)
values (735, 0, 62);
insert into PLAYCOPY (copyid, available, playid)
values (736, 1, 17);
insert into PLAYCOPY (copyid, available, playid)
values (737, 1, 120);
insert into PLAYCOPY (copyid, available, playid)
values (738, 1, 315);
insert into PLAYCOPY (copyid, available, playid)
values (739, 1, 176);
insert into PLAYCOPY (copyid, available, playid)
values (740, 1, 320);
insert into PLAYCOPY (copyid, available, playid)
values (741, 0, 198);
insert into PLAYCOPY (copyid, available, playid)
values (742, 0, 338);
insert into PLAYCOPY (copyid, available, playid)
values (743, 1, 385);
insert into PLAYCOPY (copyid, available, playid)
values (744, 1, 274);
insert into PLAYCOPY (copyid, available, playid)
values (745, 0, 123);
insert into PLAYCOPY (copyid, available, playid)
values (746, 1, 141);
insert into PLAYCOPY (copyid, available, playid)
values (747, 0, 324);
insert into PLAYCOPY (copyid, available, playid)
values (748, 1, 115);
insert into PLAYCOPY (copyid, available, playid)
values (749, 0, 172);
insert into PLAYCOPY (copyid, available, playid)
values (750, 0, 380);
insert into PLAYCOPY (copyid, available, playid)
values (751, 1, 201);
insert into PLAYCOPY (copyid, available, playid)
values (752, 1, 361);
insert into PLAYCOPY (copyid, available, playid)
values (753, 0, 112);
insert into PLAYCOPY (copyid, available, playid)
values (754, 0, 189);
insert into PLAYCOPY (copyid, available, playid)
values (755, 0, 262);
insert into PLAYCOPY (copyid, available, playid)
values (756, 1, 188);
insert into PLAYCOPY (copyid, available, playid)
values (757, 1, 230);
insert into PLAYCOPY (copyid, available, playid)
values (758, 1, 226);
insert into PLAYCOPY (copyid, available, playid)
values (759, 1, 389);
insert into PLAYCOPY (copyid, available, playid)
values (760, 0, 134);
insert into PLAYCOPY (copyid, available, playid)
values (761, 1, 97);
insert into PLAYCOPY (copyid, available, playid)
values (762, 0, 29);
insert into PLAYCOPY (copyid, available, playid)
values (763, 0, 225);
insert into PLAYCOPY (copyid, available, playid)
values (764, 0, 327);
insert into PLAYCOPY (copyid, available, playid)
values (765, 0, 248);
insert into PLAYCOPY (copyid, available, playid)
values (766, 0, 112);
insert into PLAYCOPY (copyid, available, playid)
values (767, 1, 212);
insert into PLAYCOPY (copyid, available, playid)
values (768, 0, 232);
insert into PLAYCOPY (copyid, available, playid)
values (769, 0, 392);
insert into PLAYCOPY (copyid, available, playid)
values (770, 1, 379);
insert into PLAYCOPY (copyid, available, playid)
values (771, 0, 371);
insert into PLAYCOPY (copyid, available, playid)
values (772, 1, 337);
insert into PLAYCOPY (copyid, available, playid)
values (773, 1, 145);
insert into PLAYCOPY (copyid, available, playid)
values (774, 0, 60);
insert into PLAYCOPY (copyid, available, playid)
values (775, 0, 390);
insert into PLAYCOPY (copyid, available, playid)
values (776, 1, 146);
insert into PLAYCOPY (copyid, available, playid)
values (777, 0, 288);
insert into PLAYCOPY (copyid, available, playid)
values (778, 1, 381);
insert into PLAYCOPY (copyid, available, playid)
values (779, 0, 251);
insert into PLAYCOPY (copyid, available, playid)
values (780, 0, 116);
insert into PLAYCOPY (copyid, available, playid)
values (781, 1, 152);
insert into PLAYCOPY (copyid, available, playid)
values (782, 1, 351);
insert into PLAYCOPY (copyid, available, playid)
values (783, 1, 175);
insert into PLAYCOPY (copyid, available, playid)
values (784, 1, 299);
insert into PLAYCOPY (copyid, available, playid)
values (785, 1, 326);
insert into PLAYCOPY (copyid, available, playid)
values (786, 0, 78);
insert into PLAYCOPY (copyid, available, playid)
values (787, 0, 290);
insert into PLAYCOPY (copyid, available, playid)
values (788, 1, 129);
insert into PLAYCOPY (copyid, available, playid)
values (789, 0, 290);
insert into PLAYCOPY (copyid, available, playid)
values (790, 0, 6);
insert into PLAYCOPY (copyid, available, playid)
values (791, 1, 30);
insert into PLAYCOPY (copyid, available, playid)
values (792, 1, 117);
insert into PLAYCOPY (copyid, available, playid)
values (793, 1, 175);
insert into PLAYCOPY (copyid, available, playid)
values (794, 1, 84);
insert into PLAYCOPY (copyid, available, playid)
values (795, 1, 56);
insert into PLAYCOPY (copyid, available, playid)
values (796, 0, 284);
insert into PLAYCOPY (copyid, available, playid)
values (797, 0, 245);
insert into PLAYCOPY (copyid, available, playid)
values (798, 0, 53);
insert into PLAYCOPY (copyid, available, playid)
values (799, 0, 300);
insert into PLAYCOPY (copyid, available, playid)
values (800, 1, 108);
commit;
prompt 800 records loaded
prompt Loading PLAYLENDING...
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (293, to_date('20-06-2010', 'dd-mm-yyyy'), to_date('01-07-2019', 'dd-mm-yyyy'), null, 140, '577720618', '856216050');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (294, to_date('04-09-2004', 'dd-mm-yyyy'), to_date('03-08-2011', 'dd-mm-yyyy'), null, 682, '013427448', '978514891');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (295, to_date('30-04-2008', 'dd-mm-yyyy'), to_date('02-02-2017', 'dd-mm-yyyy'), null, 777, '402909496', '165906299');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (296, to_date('05-12-2019', 'dd-mm-yyyy'), to_date('19-12-2019', 'dd-mm-yyyy'), null, 344, '659345030', '014082919');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (297, to_date('03-07-2012', 'dd-mm-yyyy'), to_date('15-08-2016', 'dd-mm-yyyy'), null, 206, '377017130', '784609914');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (298, to_date('20-11-2003', 'dd-mm-yyyy'), to_date('22-08-2016', 'dd-mm-yyyy'), null, 552, '137607044', '136019878');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (299, to_date('05-11-2016', 'dd-mm-yyyy'), to_date('03-09-2021', 'dd-mm-yyyy'), null, 114, '487301584', '173956351');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (300, to_date('07-07-2020', 'dd-mm-yyyy'), to_date('21-07-2020', 'dd-mm-yyyy'), null, 797, '113036851', '146137062');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (301, to_date('29-06-2022', 'dd-mm-yyyy'), to_date('13-07-2022', 'dd-mm-yyyy'), null, 184, '797864475', '738373379');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (302, to_date('27-12-2015', 'dd-mm-yyyy'), to_date('10-01-2016', 'dd-mm-yyyy'), null, 768, '145366143', '978514891');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (303, to_date('22-12-2010', 'dd-mm-yyyy'), to_date('26-07-2020', 'dd-mm-yyyy'), null, 195, '163506853', '479610161');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (304, to_date('17-07-2012', 'dd-mm-yyyy'), to_date('17-08-2020', 'dd-mm-yyyy'), null, 114, '783918714', '659345030');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (305, to_date('16-09-2019', 'dd-mm-yyyy'), to_date('30-09-2019', 'dd-mm-yyyy'), null, 164, '688337870', '913760353');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (306, to_date('11-02-2001', 'dd-mm-yyyy'), to_date('16-12-2013', 'dd-mm-yyyy'), null, 769, '770572515', '653774196');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (307, to_date('29-08-2015', 'dd-mm-yyyy'), to_date('12-09-2015', 'dd-mm-yyyy'), null, 19, '271730213', '849628298');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (308, to_date('01-03-2018', 'dd-mm-yyyy'), to_date('15-03-2018', 'dd-mm-yyyy'), null, 236, '187429687', '771616343');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (309, to_date('17-04-2002', 'dd-mm-yyyy'), to_date('17-10-2010', 'dd-mm-yyyy'), null, 429, '749084891', '523070923');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (310, to_date('15-01-2021', 'dd-mm-yyyy'), to_date('29-01-2021', 'dd-mm-yyyy'), null, 598, '066613546', '176288723');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (311, to_date('03-09-2005', 'dd-mm-yyyy'), to_date('17-04-2020', 'dd-mm-yyyy'), null, 604, '668963614', '843169084');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (312, to_date('28-07-2012', 'dd-mm-yyyy'), to_date('11-08-2012', 'dd-mm-yyyy'), null, 626, '659345030', '891562139');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (313, to_date('08-11-2016', 'dd-mm-yyyy'), to_date('22-11-2016', 'dd-mm-yyyy'), null, 440, '126770208', '090094931');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (314, to_date('25-11-2020', 'dd-mm-yyyy'), to_date('09-12-2020', 'dd-mm-yyyy'), null, 110, '766927859', '220633642');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (315, to_date('02-09-2013', 'dd-mm-yyyy'), to_date('05-06-2016', 'dd-mm-yyyy'), null, 531, '077468421', '464019730');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (316, to_date('24-09-2022', 'dd-mm-yyyy'), to_date('08-10-2022', 'dd-mm-yyyy'), null, 38, '266684771', '046657439');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (317, to_date('29-06-2002', 'dd-mm-yyyy'), to_date('03-02-2018', 'dd-mm-yyyy'), null, 747, '735540984', '891562139');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (318, to_date('24-01-2022', 'dd-mm-yyyy'), to_date('07-02-2022', 'dd-mm-yyyy'), null, 789, '170713739', '120287546');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (319, to_date('12-06-2019', 'dd-mm-yyyy'), to_date('13-08-2023', 'dd-mm-yyyy'), null, 363, '585575998', '177382748');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (320, to_date('02-04-2006', 'dd-mm-yyyy'), to_date('12-08-2015', 'dd-mm-yyyy'), null, 694, '992475501', '012259052');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (321, to_date('03-05-2008', 'dd-mm-yyyy'), to_date('31-01-2012', 'dd-mm-yyyy'), null, 171, '680540698', '888279161');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (322, to_date('18-09-2023', 'dd-mm-yyyy'), to_date('02-10-2023', 'dd-mm-yyyy'), null, 41, '830383231', '950424090');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (323, to_date('09-07-2002', 'dd-mm-yyyy'), to_date('11-01-2017', 'dd-mm-yyyy'), null, 775, '432425942', '226545801');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (324, to_date('08-02-2011', 'dd-mm-yyyy'), to_date('29-04-2014', 'dd-mm-yyyy'), null, 72, '275681892', '840162098');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (325, to_date('27-09-2005', 'dd-mm-yyyy'), to_date('20-08-2023', 'dd-mm-yyyy'), null, 799, '766927859', '545327628');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (326, to_date('25-10-2020', 'dd-mm-yyyy'), to_date('06-04-2024', 'dd-mm-yyyy'), null, 64, '488229246', '187515796');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (327, to_date('24-03-2018', 'dd-mm-yyyy'), to_date('07-04-2018', 'dd-mm-yyyy'), null, 236, '322854435', '226545801');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (328, to_date('02-10-2018', 'dd-mm-yyyy'), to_date('08-07-2019', 'dd-mm-yyyy'), null, 481, '783055575', '596690563');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (329, to_date('22-03-2010', 'dd-mm-yyyy'), to_date('04-01-2011', 'dd-mm-yyyy'), null, 711, '163506853', '701862029');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (330, to_date('31-01-2000', 'dd-mm-yyyy'), to_date('02-06-2014', 'dd-mm-yyyy'), null, 780, '164868085', '113439011');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (331, to_date('01-05-2019', 'dd-mm-yyyy'), to_date('15-05-2019', 'dd-mm-yyyy'), null, 685, '566478959', '214713146');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (332, to_date('01-05-2007', 'dd-mm-yyyy'), to_date('22-04-2013', 'dd-mm-yyyy'), null, 412, '311514630', '498584448');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (333, to_date('08-05-2010', 'dd-mm-yyyy'), to_date('30-04-2021', 'dd-mm-yyyy'), null, 206, '666467223', '625529602');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (334, to_date('14-07-2021', 'dd-mm-yyyy'), to_date('28-07-2021', 'dd-mm-yyyy'), null, 111, '776528409', '701862029');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (335, to_date('26-05-2015', 'dd-mm-yyyy'), to_date('15-01-2017', 'dd-mm-yyyy'), null, 219, '034411863', '279175065');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (336, to_date('07-07-2009', 'dd-mm-yyyy'), to_date('17-01-2022', 'dd-mm-yyyy'), null, 669, '029466664', '653774196');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (337, to_date('12-08-2022', 'dd-mm-yyyy'), to_date('26-08-2022', 'dd-mm-yyyy'), null, 226, '697531067', '029695329');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (338, to_date('25-04-2019', 'dd-mm-yyyy'), to_date('05-07-2021', 'dd-mm-yyyy'), null, 291, '241206486', '527971188');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (339, to_date('27-12-2015', 'dd-mm-yyyy'), to_date('03-05-2018', 'dd-mm-yyyy'), null, 62, '402909496', '025815914');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (340, to_date('11-09-2017', 'dd-mm-yyyy'), to_date('26-01-2018', 'dd-mm-yyyy'), null, 32, '356235416', '186328775');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (341, to_date('14-06-2021', 'dd-mm-yyyy'), to_date('28-06-2021', 'dd-mm-yyyy'), null, 763, '911294712', '758867042');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (342, to_date('19-05-2017', 'dd-mm-yyyy'), to_date('02-06-2017', 'dd-mm-yyyy'), null, 699, '107093007', '000677810');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (343, to_date('17-10-2001', 'dd-mm-yyyy'), to_date('10-11-2020', 'dd-mm-yyyy'), null, 419, '043939492', '856216050');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (344, to_date('26-01-2003', 'dd-mm-yyyy'), to_date('13-05-2019', 'dd-mm-yyyy'), null, 286, '218117404', '528625739');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (345, to_date('28-07-2003', 'dd-mm-yyyy'), to_date('01-09-2012', 'dd-mm-yyyy'), null, 734, '322295223', '189152630');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (346, to_date('05-09-2021', 'dd-mm-yyyy'), to_date('19-09-2021', 'dd-mm-yyyy'), null, 310, '342761949', '206148591');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (347, to_date('25-11-2005', 'dd-mm-yyyy'), to_date('28-06-2010', 'dd-mm-yyyy'), null, 79, '034411863', '628942053');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (348, to_date('22-04-2009', 'dd-mm-yyyy'), to_date('18-12-2023', 'dd-mm-yyyy'), null, 556, '830383231', '986715923');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (349, to_date('18-08-2019', 'dd-mm-yyyy'), to_date('01-09-2019', 'dd-mm-yyyy'), null, 308, '267137605', '555012645');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (350, to_date('01-06-2008', 'dd-mm-yyyy'), to_date('08-11-2012', 'dd-mm-yyyy'), null, 232, '446332100', '917208879');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (351, to_date('20-03-2009', 'dd-mm-yyyy'), to_date('13-11-2021', 'dd-mm-yyyy'), null, 386, '831042091', '526716833');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (352, to_date('16-05-2023', 'dd-mm-yyyy'), to_date('30-05-2023', 'dd-mm-yyyy'), null, 377, '327179287', '811052060');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (353, to_date('24-06-2012', 'dd-mm-yyyy'), to_date('07-11-2018', 'dd-mm-yyyy'), null, 395, '187429687', '831042091');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (354, to_date('15-02-2002', 'dd-mm-yyyy'), to_date('01-02-2023', 'dd-mm-yyyy'), null, 238, '520822644', '188284365');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (355, to_date('08-04-2008', 'dd-mm-yyyy'), to_date('18-03-2013', 'dd-mm-yyyy'), null, 32, '311690756', '143520341');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (356, to_date('03-03-2004', 'dd-mm-yyyy'), to_date('20-09-2022', 'dd-mm-yyyy'), null, 655, '418350339', '840162098');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (357, to_date('17-01-2003', 'dd-mm-yyyy'), to_date('10-04-2019', 'dd-mm-yyyy'), null, 639, '432425942', '017605424');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (358, to_date('13-01-2003', 'dd-mm-yyyy'), to_date('18-05-2010', 'dd-mm-yyyy'), null, 165, '055249826', '800071003');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (359, to_date('15-06-2019', 'dd-mm-yyyy'), to_date('29-06-2019', 'dd-mm-yyyy'), null, 91, '053078260', '780840485');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (360, to_date('15-08-2023', 'dd-mm-yyyy'), to_date('29-08-2023', 'dd-mm-yyyy'), null, 729, '176375614', '805665451');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (361, to_date('16-12-2018', 'dd-mm-yyyy'), to_date('06-12-2020', 'dd-mm-yyyy'), null, 659, '061215635', '783918714');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (362, to_date('26-06-2009', 'dd-mm-yyyy'), to_date('15-03-2015', 'dd-mm-yyyy'), null, 474, '329948220', '913760353');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (363, to_date('08-11-2005', 'dd-mm-yyyy'), to_date('25-05-2010', 'dd-mm-yyyy'), null, 549, '093818015', '821726553');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (364, to_date('07-10-2000', 'dd-mm-yyyy'), to_date('01-01-2012', 'dd-mm-yyyy'), null, 300, '847250676', '311246059');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (365, to_date('09-02-2007', 'dd-mm-yyyy'), to_date('12-05-2018', 'dd-mm-yyyy'), null, 677, '064598882', '886474743');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (366, to_date('03-12-2002', 'dd-mm-yyyy'), to_date('29-07-2014', 'dd-mm-yyyy'), null, 463, '186328775', '551736818');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (367, to_date('18-10-2006', 'dd-mm-yyyy'), to_date('11-11-2016', 'dd-mm-yyyy'), null, 157, '998214636', '019362397');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (368, to_date('07-08-2003', 'dd-mm-yyyy'), to_date('31-12-2016', 'dd-mm-yyyy'), null, 43, '725276037', '081383228');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (369, to_date('23-03-2001', 'dd-mm-yyyy'), to_date('29-05-2021', 'dd-mm-yyyy'), null, 254, '653774196', '553241085');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (370, to_date('01-03-2009', 'dd-mm-yyyy'), to_date('10-05-2011', 'dd-mm-yyyy'), null, 3, '886314861', '600730948');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (371, to_date('25-03-2012', 'dd-mm-yyyy'), to_date('21-09-2021', 'dd-mm-yyyy'), null, 443, '342761949', '810869456');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (372, to_date('19-02-2011', 'dd-mm-yyyy'), to_date('03-04-2020', 'dd-mm-yyyy'), null, 454, '770600157', '315275105');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (373, to_date('03-08-2005', 'dd-mm-yyyy'), to_date('01-09-2018', 'dd-mm-yyyy'), null, 493, '090465425', '310404144');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (374, to_date('07-07-2019', 'dd-mm-yyyy'), to_date('21-11-2019', 'dd-mm-yyyy'), null, 513, '901820276', '128447737');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (375, to_date('20-01-2018', 'dd-mm-yyyy'), to_date('03-02-2018', 'dd-mm-yyyy'), null, 537, '301487527', '312108840');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (376, to_date('28-06-2002', 'dd-mm-yyyy'), to_date('13-09-2011', 'dd-mm-yyyy'), null, 358, '446920114', '612825720');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (377, to_date('07-01-2022', 'dd-mm-yyyy'), to_date('21-01-2022', 'dd-mm-yyyy'), null, 29, '050573245', '555012645');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (378, to_date('12-05-2017', 'dd-mm-yyyy'), to_date('14-07-2022', 'dd-mm-yyyy'), null, 230, '613155757', '315680603');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (379, to_date('25-07-2008', 'dd-mm-yyyy'), to_date('16-09-2013', 'dd-mm-yyyy'), null, 16, '972588444', '423509159');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (380, to_date('10-06-2021', 'dd-mm-yyyy'), to_date('24-06-2021', 'dd-mm-yyyy'), null, 626, '604788032', '275004714');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (381, to_date('11-04-2005', 'dd-mm-yyyy'), to_date('09-02-2016', 'dd-mm-yyyy'), null, 162, '602220915', '527971188');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (382, to_date('07-12-2001', 'dd-mm-yyyy'), to_date('12-05-2018', 'dd-mm-yyyy'), null, 684, '520422787', '245422235');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (383, to_date('25-01-2002', 'dd-mm-yyyy'), to_date('19-11-2016', 'dd-mm-yyyy'), null, 44, '130330261', '950424090');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (384, to_date('21-03-2015', 'dd-mm-yyyy'), to_date('29-01-2017', 'dd-mm-yyyy'), null, 525, '887892305', '905167354');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (385, to_date('19-12-2017', 'dd-mm-yyyy'), to_date('02-01-2018', 'dd-mm-yyyy'), null, 246, '783546244', '464019730');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (386, to_date('03-10-2002', 'dd-mm-yyyy'), to_date('07-04-2015', 'dd-mm-yyyy'), null, 664, '507745420', '173956351');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (387, to_date('15-11-2013', 'dd-mm-yyyy'), to_date('01-03-2024', 'dd-mm-yyyy'), null, 413, '652120441', '093818015');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (388, to_date('24-01-2020', 'dd-mm-yyyy'), to_date('07-02-2020', 'dd-mm-yyyy'), null, 664, '723375847', '402909496');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (389, to_date('10-02-2022', 'dd-mm-yyyy'), to_date('24-02-2022', 'dd-mm-yyyy'), null, 693, '464050791', '230944652');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (390, to_date('22-06-2012', 'dd-mm-yyyy'), to_date('26-12-2021', 'dd-mm-yyyy'), null, 539, '811052060', '611574934');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (391, to_date('21-09-2012', 'dd-mm-yyyy'), to_date('10-02-2017', 'dd-mm-yyyy'), null, 734, '356235416', '853341811');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (392, to_date('05-04-2000', 'dd-mm-yyyy'), to_date('20-07-2016', 'dd-mm-yyyy'), null, 331, '082415344', '713944647');
commit;
prompt 100 records committed...
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (393, to_date('25-06-2022', 'dd-mm-yyyy'), to_date('09-07-2022', 'dd-mm-yyyy'), null, 722, '577720618', '718788104');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (394, to_date('20-09-2011', 'dd-mm-yyyy'), to_date('03-09-2013', 'dd-mm-yyyy'), null, 59, '136074808', '526829293');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (395, to_date('19-10-2000', 'dd-mm-yyyy'), to_date('19-03-2010', 'dd-mm-yyyy'), null, 628, '186328775', '432090220');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (396, to_date('03-03-2021', 'dd-mm-yyyy'), to_date('17-03-2021', 'dd-mm-yyyy'), null, 410, '180966239', '878867388');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (397, to_date('31-10-2010', 'dd-mm-yyyy'), to_date('14-11-2010', 'dd-mm-yyyy'), null, 586, '064598882', '531653197');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (398, to_date('09-07-2001', 'dd-mm-yyyy'), to_date('05-03-2021', 'dd-mm-yyyy'), null, 92, '585575998', '180966239');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (399, to_date('22-06-2017', 'dd-mm-yyyy'), to_date('20-07-2021', 'dd-mm-yyyy'), null, 330, '446332100', '348723377');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (400, to_date('29-12-2002', 'dd-mm-yyyy'), to_date('25-11-2013', 'dd-mm-yyyy'), null, 69, '176375614', '983815148');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (401, to_date('27-02-2006', 'dd-mm-yyyy'), to_date('20-02-2023', 'dd-mm-yyyy'), null, 623, '230944652', '014082919');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (402, to_date('07-01-2013', 'dd-mm-yyyy'), to_date('12-05-2022', 'dd-mm-yyyy'), null, 598, '805127954', '154465176');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (403, to_date('10-11-2016', 'dd-mm-yyyy'), to_date('24-11-2016', 'dd-mm-yyyy'), null, 162, '221505949', '668963614');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (404, to_date('18-10-2011', 'dd-mm-yyyy'), to_date('03-09-2013', 'dd-mm-yyyy'), null, 393, '304620961', '297681984');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (405, to_date('09-02-2012', 'dd-mm-yyyy'), to_date('12-12-2013', 'dd-mm-yyyy'), null, 58, '464019730', '720106083');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (406, to_date('06-01-2022', 'dd-mm-yyyy'), to_date('28-04-2023', 'dd-mm-yyyy'), null, 127, '826540393', '028369330');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (407, to_date('10-05-2007', 'dd-mm-yyyy'), to_date('20-06-2011', 'dd-mm-yyyy'), null, 706, '273149266', '219278525');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (408, to_date('03-07-2010', 'dd-mm-yyyy'), to_date('18-05-2015', 'dd-mm-yyyy'), null, 366, '180191326', '971707537');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (409, to_date('28-08-2006', 'dd-mm-yyyy'), to_date('02-06-2020', 'dd-mm-yyyy'), null, 305, '022601726', '731223212');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (410, to_date('07-01-2014', 'dd-mm-yyyy'), to_date('02-01-2015', 'dd-mm-yyyy'), null, 726, '725276037', '141166296');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (411, to_date('26-03-2007', 'dd-mm-yyyy'), to_date('30-12-2016', 'dd-mm-yyyy'), null, 119, '871507308', '696456011');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (412, to_date('01-06-2014', 'dd-mm-yyyy'), to_date('02-09-2015', 'dd-mm-yyyy'), null, 379, '290488254', '837162122');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (413, to_date('09-03-2013', 'dd-mm-yyyy'), to_date('07-06-2022', 'dd-mm-yyyy'), null, 101, '735540984', '066163526');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (414, to_date('03-06-2019', 'dd-mm-yyyy'), to_date('17-06-2019', 'dd-mm-yyyy'), null, 749, '526829293', '172290645');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (415, to_date('28-06-2000', 'dd-mm-yyyy'), to_date('18-07-2021', 'dd-mm-yyyy'), null, 416, '644249525', '856216050');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (416, to_date('05-12-2017', 'dd-mm-yyyy'), to_date('19-12-2017', 'dd-mm-yyyy'), null, 654, '423593942', '805665451');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (417, to_date('03-02-2020', 'dd-mm-yyyy'), to_date('17-02-2020', 'dd-mm-yyyy'), null, 404, '972588444', '899786232');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (418, to_date('21-05-2016', 'dd-mm-yyyy'), to_date('03-07-2017', 'dd-mm-yyyy'), null, 640, '414863719', '386768609');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (419, to_date('31-12-2010', 'dd-mm-yyyy'), to_date('13-11-2015', 'dd-mm-yyyy'), null, 371, '066613546', '507560616');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (420, to_date('13-01-2001', 'dd-mm-yyyy'), to_date('21-02-2010', 'dd-mm-yyyy'), null, 572, '001709568', '168438555');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (421, to_date('11-01-2002', 'dd-mm-yyyy'), to_date('28-10-2015', 'dd-mm-yyyy'), null, 407, '782812737', '668963614');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (422, to_date('26-02-2013', 'dd-mm-yyyy'), to_date('02-05-2021', 'dd-mm-yyyy'), null, 604, '963083303', '155248136');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (423, to_date('13-02-2011', 'dd-mm-yyyy'), to_date('27-01-2018', 'dd-mm-yyyy'), null, 71, '614784421', '738373379');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (424, to_date('13-04-2018', 'dd-mm-yyyy'), to_date('10-05-2024', 'dd-mm-yyyy'), null, 293, '591957858', '527971188');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (425, to_date('08-12-2013', 'dd-mm-yyyy'), to_date('11-04-2014', 'dd-mm-yyyy'), null, 584, '137842810', '442298493');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (426, to_date('15-04-2003', 'dd-mm-yyyy'), to_date('15-12-2011', 'dd-mm-yyyy'), null, 423, '022601726', '487301584');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (427, to_date('05-12-2010', 'dd-mm-yyyy'), to_date('23-09-2012', 'dd-mm-yyyy'), null, 754, '195785327', '666153997');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (428, to_date('03-10-2018', 'dd-mm-yyyy'), to_date('17-10-2018', 'dd-mm-yyyy'), null, 656, '793092711', '127352453');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (429, to_date('17-12-2022', 'dd-mm-yyyy'), to_date('31-12-2022', 'dd-mm-yyyy'), null, 131, '252004653', '614782689');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (430, to_date('24-07-2021', 'dd-mm-yyyy'), to_date('07-08-2021', 'dd-mm-yyyy'), null, 733, '591957858', '498584448');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (431, to_date('10-02-2008', 'dd-mm-yyyy'), to_date('03-05-2019', 'dd-mm-yyyy'), null, 573, '776528409', '029124580');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (432, to_date('10-10-2011', 'dd-mm-yyyy'), to_date('05-03-2023', 'dd-mm-yyyy'), null, 745, '311690756', '000677810');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (433, to_date('24-05-2013', 'dd-mm-yyyy'), to_date('05-08-2015', 'dd-mm-yyyy'), null, 320, '531653197', '418345089');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (434, to_date('04-02-2006', 'dd-mm-yyyy'), to_date('01-08-2021', 'dd-mm-yyyy'), null, 428, '613155757', '485100893');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (435, to_date('26-09-2012', 'dd-mm-yyyy'), to_date('10-10-2012', 'dd-mm-yyyy'), null, 727, '874481938', '543044858');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (436, to_date('10-11-2022', 'dd-mm-yyyy'), to_date('24-11-2022', 'dd-mm-yyyy'), null, 703, '241206486', '541714008');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (437, to_date('16-10-2017', 'dd-mm-yyyy'), to_date('30-10-2017', 'dd-mm-yyyy'), null, 710, '185553927', '831042091');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (438, to_date('07-05-2018', 'dd-mm-yyyy'), to_date('21-05-2018', 'dd-mm-yyyy'), null, 288, '436366104', '801792400');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (439, to_date('19-12-2006', 'dd-mm-yyyy'), to_date('19-08-2011', 'dd-mm-yyyy'), null, 590, '226545801', '684705736');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (440, to_date('26-08-2010', 'dd-mm-yyyy'), to_date('03-06-2022', 'dd-mm-yyyy'), null, 798, '396904603', '551736818');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (441, to_date('22-04-2021', 'dd-mm-yyyy'), to_date('21-06-2022', 'dd-mm-yyyy'), null, 152, '789950829', '419340592');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (442, to_date('06-08-2010', 'dd-mm-yyyy'), to_date('11-07-2016', 'dd-mm-yyyy'), null, 719, '821726553', '527971188');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (443, to_date('07-11-2017', 'dd-mm-yyyy'), to_date('21-11-2017', 'dd-mm-yyyy'), null, 678, '911294712', '146137062');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (444, to_date('20-05-2017', 'dd-mm-yyyy'), to_date('29-08-2018', 'dd-mm-yyyy'), null, 711, '414863719', '275681892');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (445, to_date('25-06-2004', 'dd-mm-yyyy'), to_date('21-07-2011', 'dd-mm-yyyy'), null, 329, '310404144', '272137266');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (446, to_date('19-07-2016', 'dd-mm-yyyy'), to_date('05-07-2020', 'dd-mm-yyyy'), null, 89, '255474214', '939973048');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (447, to_date('09-05-2007', 'dd-mm-yyyy'), to_date('19-01-2021', 'dd-mm-yyyy'), null, 491, '334283784', '417953406');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (448, to_date('08-07-2015', 'dd-mm-yyyy'), to_date('20-05-2019', 'dd-mm-yyyy'), null, 41, '353506388', '729801502');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (449, to_date('14-07-2011', 'dd-mm-yyyy'), to_date('22-11-2018', 'dd-mm-yyyy'), null, 165, '766598824', '701919398');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (450, to_date('07-09-2014', 'dd-mm-yyyy'), to_date('25-12-2014', 'dd-mm-yyyy'), null, 352, '264847178', '418345089');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (451, to_date('05-09-2009', 'dd-mm-yyyy'), to_date('09-11-2023', 'dd-mm-yyyy'), null, 74, '053166731', '336288257');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (452, to_date('16-03-2023', 'dd-mm-yyyy'), to_date('30-03-2023', 'dd-mm-yyyy'), null, 412, '350849342', '878867388');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (453, to_date('08-04-2017', 'dd-mm-yyyy'), to_date('22-04-2017', 'dd-mm-yyyy'), null, 39, '275681892', '140829165');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (454, to_date('22-12-2015', 'dd-mm-yyyy'), to_date('05-01-2016', 'dd-mm-yyyy'), null, 439, '898194084', '675987499');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (455, to_date('09-02-2016', 'dd-mm-yyyy'), to_date('31-01-2024', 'dd-mm-yyyy'), null, 721, '464050791', '054248733');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (456, to_date('01-03-2011', 'dd-mm-yyyy'), to_date('05-08-2011', 'dd-mm-yyyy'), null, 182, '887892305', '432090220');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (457, to_date('02-11-2019', 'dd-mm-yyyy'), to_date('13-04-2024', 'dd-mm-yyyy'), null, 542, '013427448', '032555609');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (458, to_date('29-07-2021', 'dd-mm-yyyy'), to_date('12-08-2021', 'dd-mm-yyyy'), null, 514, '238684624', '701862029');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (459, to_date('15-05-2001', 'dd-mm-yyyy'), to_date('17-07-2019', 'dd-mm-yyyy'), null, 471, '677905366', '965000417');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (460, to_date('11-08-2017', 'dd-mm-yyyy'), to_date('25-08-2017', 'dd-mm-yyyy'), null, 113, '659345030', '971707537');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (461, to_date('21-04-2000', 'dd-mm-yyyy'), to_date('03-04-2014', 'dd-mm-yyyy'), null, 723, '874481938', '928095860');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (462, to_date('01-03-2006', 'dd-mm-yyyy'), to_date('02-11-2012', 'dd-mm-yyyy'), null, 379, '562094648', '610867226');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (463, to_date('05-10-2011', 'dd-mm-yyyy'), to_date('27-12-2013', 'dd-mm-yyyy'), null, 231, '175188743', '206148591');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (464, to_date('22-11-2005', 'dd-mm-yyyy'), to_date('21-01-2014', 'dd-mm-yyyy'), null, 227, '446920114', '281102853');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (465, to_date('19-04-2020', 'dd-mm-yyyy'), to_date('03-05-2020', 'dd-mm-yyyy'), null, 147, '922607270', '664089285');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (466, to_date('30-06-2016', 'dd-mm-yyyy'), to_date('09-07-2019', 'dd-mm-yyyy'), null, 308, '260510850', '853596678');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (467, to_date('29-01-2001', 'dd-mm-yyyy'), to_date('05-04-2017', 'dd-mm-yyyy'), null, 563, '770600157', '918067269');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (468, to_date('20-05-2013', 'dd-mm-yyyy'), to_date('25-01-2018', 'dd-mm-yyyy'), null, 199, '055249826', '798632254');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (469, to_date('19-10-2014', 'dd-mm-yyyy'), to_date('02-11-2014', 'dd-mm-yyyy'), null, 514, '602220915', '880659583');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (470, to_date('04-11-2000', 'dd-mm-yyyy'), to_date('21-10-2010', 'dd-mm-yyyy'), null, 7, '454626264', '301487527');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (471, to_date('16-07-2018', 'dd-mm-yyyy'), to_date('06-04-2021', 'dd-mm-yyyy'), null, 563, '874481938', '176375614');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (472, to_date('10-05-2018', 'dd-mm-yyyy'), to_date('07-09-2019', 'dd-mm-yyyy'), null, 702, '984268974', '398373857');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (473, to_date('07-03-2019', 'dd-mm-yyyy'), to_date('21-03-2019', 'dd-mm-yyyy'), null, 373, '770600157', '541714008');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (474, to_date('28-11-2022', 'dd-mm-yyyy'), to_date('12-12-2022', 'dd-mm-yyyy'), null, 388, '915372180', '967478251');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (475, to_date('29-09-2014', 'dd-mm-yyyy'), to_date('13-10-2014', 'dd-mm-yyyy'), null, 93, '446920114', '560046205');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (476, to_date('15-05-2013', 'dd-mm-yyyy'), to_date('22-08-2016', 'dd-mm-yyyy'), null, 79, '141519886', '217140305');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (477, to_date('03-09-2015', 'dd-mm-yyyy'), to_date('17-09-2015', 'dd-mm-yyyy'), null, 665, '652120441', '257484513');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (478, to_date('15-11-2007', 'dd-mm-yyyy'), to_date('22-08-2010', 'dd-mm-yyyy'), null, 232, '130330261', '984268974');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (479, to_date('24-11-2001', 'dd-mm-yyyy'), to_date('17-02-2016', 'dd-mm-yyyy'), null, 373, '327375753', '668963614');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (480, to_date('14-11-2011', 'dd-mm-yyyy'), to_date('21-04-2018', 'dd-mm-yyyy'), null, 125, '563934878', '386518366');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (481, to_date('01-05-2006', 'dd-mm-yyyy'), to_date('14-04-2019', 'dd-mm-yyyy'), null, 635, '423593942', '301595276');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (482, to_date('08-03-2022', 'dd-mm-yyyy'), to_date('22-03-2022', 'dd-mm-yyyy'), null, 45, '498584448', '701389269');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (483, to_date('03-05-2014', 'dd-mm-yyyy'), to_date('26-07-2023', 'dd-mm-yyyy'), null, 601, '697846160', '141519886');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (484, to_date('26-07-2008', 'dd-mm-yyyy'), to_date('22-04-2012', 'dd-mm-yyyy'), null, 584, '169511260', '701389269');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (485, to_date('04-09-2013', 'dd-mm-yyyy'), to_date('18-09-2013', 'dd-mm-yyyy'), null, 659, '140122154', '837162122');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (486, to_date('13-09-2006', 'dd-mm-yyyy'), to_date('14-01-2017', 'dd-mm-yyyy'), null, 786, '097482024', '120938383');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (487, to_date('10-07-2017', 'dd-mm-yyyy'), to_date('24-07-2017', 'dd-mm-yyyy'), null, 414, '158263429', '559859523');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (488, to_date('05-04-2016', 'dd-mm-yyyy'), to_date('20-07-2016', 'dd-mm-yyyy'), null, 529, '129715075', '849628298');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (489, to_date('29-01-2004', 'dd-mm-yyyy'), to_date('23-07-2016', 'dd-mm-yyyy'), null, 706, '175978110', '566197144');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (490, to_date('31-10-2000', 'dd-mm-yyyy'), to_date('26-04-2010', 'dd-mm-yyyy'), null, 547, '064598882', '584118594');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (491, to_date('21-08-2015', 'dd-mm-yyyy'), to_date('30-07-2022', 'dd-mm-yyyy'), null, 636, '260510850', '878867388');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (492, to_date('15-09-2019', 'dd-mm-yyyy'), to_date('29-09-2019', 'dd-mm-yyyy'), null, 220, '677905366', '096353906');
commit;
prompt 200 records committed...
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (493, to_date('20-01-2023', 'dd-mm-yyyy'), to_date('03-02-2023', 'dd-mm-yyyy'), null, 185, '645106048', '191792029');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (494, to_date('25-04-2005', 'dd-mm-yyyy'), to_date('26-10-2016', 'dd-mm-yyyy'), null, 490, '494302245', '798274104');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (495, to_date('08-11-2013', 'dd-mm-yyyy'), to_date('22-11-2013', 'dd-mm-yyyy'), null, 565, '028369330', '077412256');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (496, to_date('04-03-2005', 'dd-mm-yyyy'), to_date('09-06-2015', 'dd-mm-yyyy'), null, 438, '456794713', '697846160');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (497, to_date('08-08-2021', 'dd-mm-yyyy'), to_date('22-08-2021', 'dd-mm-yyyy'), null, 315, '086072867', '063300220');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (498, to_date('13-03-2005', 'dd-mm-yyyy'), to_date('28-06-2012', 'dd-mm-yyyy'), null, 317, '141796209', '377113286');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (499, to_date('30-06-2001', 'dd-mm-yyyy'), to_date('23-12-2021', 'dd-mm-yyyy'), null, 604, '136074808', '731223212');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (500, to_date('21-04-2014', 'dd-mm-yyyy'), to_date('05-05-2014', 'dd-mm-yyyy'), null, 461, '454626264', '143520341');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (1, to_date('20-09-2000', 'dd-mm-yyyy'), to_date('20-11-2021', 'dd-mm-yyyy'), null, 479, '214713146', '297681984');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (2, to_date('04-04-2014', 'dd-mm-yyyy'), to_date('30-10-2022', 'dd-mm-yyyy'), null, 553, '978514891', '066516192');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (3, to_date('23-10-2004', 'dd-mm-yyyy'), to_date('01-04-2012', 'dd-mm-yyyy'), null, 124, '046657439', '917208879');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (4, to_date('29-04-2010', 'dd-mm-yyyy'), to_date('06-01-2019', 'dd-mm-yyyy'), null, 289, '897822661', '998214636');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (5, to_date('14-08-2013', 'dd-mm-yyyy'), to_date('16-09-2014', 'dd-mm-yyyy'), null, 287, '681877198', '909087863');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (6, to_date('05-12-2022', 'dd-mm-yyyy'), to_date('24-08-2023', 'dd-mm-yyyy'), null, 25, '978612834', '668963614');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (7, to_date('02-04-2017', 'dd-mm-yyyy'), to_date('16-04-2017', 'dd-mm-yyyy'), null, 23, '158263429', '279175065');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (8, to_date('22-10-2014', 'dd-mm-yyyy'), to_date('17-10-2019', 'dd-mm-yyyy'), null, 685, '617082575', '403239539');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (9, to_date('03-03-2000', 'dd-mm-yyyy'), to_date('24-04-2016', 'dd-mm-yyyy'), null, 444, '195785327', '279175065');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (10, to_date('28-05-2010', 'dd-mm-yyyy'), to_date('11-07-2014', 'dd-mm-yyyy'), null, 501, '141376208', '701389269');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (11, to_date('15-07-2016', 'dd-mm-yyyy'), to_date('29-07-2016', 'dd-mm-yyyy'), null, 346, '086072867', '828869477');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (12, to_date('06-03-2001', 'dd-mm-yyyy'), to_date('08-06-2020', 'dd-mm-yyyy'), null, 461, '070289159', '061215635');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (13, to_date('30-06-2002', 'dd-mm-yyyy'), to_date('20-08-2012', 'dd-mm-yyyy'), null, 536, '175188743', '370469772');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (14, to_date('04-01-2005', 'dd-mm-yyyy'), to_date('26-07-2023', 'dd-mm-yyyy'), null, 185, '066516192', '419340592');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (15, to_date('06-02-2000', 'dd-mm-yyyy'), to_date('27-09-2019', 'dd-mm-yyyy'), null, 179, '545636009', '269524383');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (16, to_date('24-11-2018', 'dd-mm-yyyy'), to_date('08-12-2018', 'dd-mm-yyyy'), null, 301, '039153067', '644249525');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (17, to_date('29-05-2002', 'dd-mm-yyyy'), to_date('10-06-2018', 'dd-mm-yyyy'), null, 515, '130330261', '798632254');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (18, to_date('23-04-2011', 'dd-mm-yyyy'), to_date('16-09-2022', 'dd-mm-yyyy'), null, 291, '310404144', '909087863');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (19, to_date('26-07-2001', 'dd-mm-yyyy'), to_date('10-11-2013', 'dd-mm-yyyy'), null, 707, '696182052', '928264310');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (20, to_date('23-04-2004', 'dd-mm-yyyy'), to_date('08-03-2023', 'dd-mm-yyyy'), null, 587, '446332100', '713944647');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (21, to_date('16-03-2016', 'dd-mm-yyyy'), to_date('30-03-2016', 'dd-mm-yyyy'), null, 747, '140122154', '983492574');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (22, to_date('31-05-2003', 'dd-mm-yyyy'), to_date('15-10-2014', 'dd-mm-yyyy'), null, 565, '574465011', '257490434');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (23, to_date('18-01-2012', 'dd-mm-yyyy'), to_date('17-12-2014', 'dd-mm-yyyy'), null, 310, '115243063', '090465425');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (24, to_date('19-05-2012', 'dd-mm-yyyy'), to_date('02-06-2012', 'dd-mm-yyyy'), null, 405, '766927859', '830383231');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (25, to_date('02-02-2004', 'dd-mm-yyyy'), to_date('01-01-2010', 'dd-mm-yyyy'), null, 34, '805127954', '545327628');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (26, to_date('15-10-2008', 'dd-mm-yyyy'), to_date('19-08-2017', 'dd-mm-yyyy'), null, 620, '801792400', '054248733');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (27, to_date('01-07-2017', 'dd-mm-yyyy'), to_date('15-07-2017', 'dd-mm-yyyy'), null, 4, '559859523', '054807164');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (28, to_date('20-12-2000', 'dd-mm-yyyy'), to_date('16-08-2014', 'dd-mm-yyyy'), null, 477, '563934878', '407435967');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (29, to_date('28-12-2016', 'dd-mm-yyyy'), to_date('03-05-2017', 'dd-mm-yyyy'), null, 274, '305084973', '621314773');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (30, to_date('05-03-2006', 'dd-mm-yyyy'), to_date('19-04-2023', 'dd-mm-yyyy'), null, 762, '329948220', '219278525');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (31, to_date('13-04-2000', 'dd-mm-yyyy'), to_date('04-03-2010', 'dd-mm-yyyy'), null, 648, '107093007', '677097969');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (32, to_date('18-04-2022', 'dd-mm-yyyy'), to_date('02-05-2022', 'dd-mm-yyyy'), null, 611, '226545801', '791299463');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (33, to_date('11-12-2011', 'dd-mm-yyyy'), to_date('03-06-2012', 'dd-mm-yyyy'), null, 485, '569056506', '983815148');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (34, to_date('25-03-2015', 'dd-mm-yyyy'), to_date('08-04-2015', 'dd-mm-yyyy'), null, 209, '851304587', '028592641');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (35, to_date('05-02-2023', 'dd-mm-yyyy'), to_date('19-02-2023', 'dd-mm-yyyy'), null, 774, '338766535', '442298493');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (36, to_date('10-03-2002', 'dd-mm-yyyy'), to_date('15-05-2018', 'dd-mm-yyyy'), null, 54, '464019730', '180191326');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (37, to_date('22-01-2021', 'dd-mm-yyyy'), to_date('05-02-2021', 'dd-mm-yyyy'), null, 742, '758867042', '967478251');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (38, to_date('23-07-2017', 'dd-mm-yyyy'), to_date('16-03-2020', 'dd-mm-yyyy'), null, 381, '613155757', '918067269');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (39, to_date('06-05-2015', 'dd-mm-yyyy'), to_date('29-12-2022', 'dd-mm-yyyy'), null, 60, '783546244', '971662190');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (40, to_date('18-10-2021', 'dd-mm-yyyy'), to_date('01-11-2021', 'dd-mm-yyyy'), null, 537, '809030912', '600730948');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (41, to_date('24-04-2021', 'dd-mm-yyyy'), to_date('08-05-2021', 'dd-mm-yyyy'), null, 753, '680606541', '840162098');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (42, to_date('02-10-2002', 'dd-mm-yyyy'), to_date('17-10-2018', 'dd-mm-yyyy'), null, 343, '094482935', '853596678');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (43, to_date('26-01-2016', 'dd-mm-yyyy'), to_date('01-08-2018', 'dd-mm-yyyy'), null, 96, '162991219', '553241085');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (44, to_date('03-05-2006', 'dd-mm-yyyy'), to_date('26-02-2010', 'dd-mm-yyyy'), null, 799, '801462183', '847250676');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (45, to_date('21-03-2010', 'dd-mm-yyyy'), to_date('08-03-2022', 'dd-mm-yyyy'), null, 419, '524440107', '217140305');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (46, to_date('28-12-2006', 'dd-mm-yyyy'), to_date('08-06-2013', 'dd-mm-yyyy'), null, 504, '090465425', '086072867');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (47, to_date('26-08-2001', 'dd-mm-yyyy'), to_date('02-10-2012', 'dd-mm-yyyy'), null, 675, '275681892', '432090220');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (48, to_date('03-07-2011', 'dd-mm-yyyy'), to_date('18-12-2012', 'dd-mm-yyyy'), null, 377, '142861817', '424018298');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (49, to_date('09-07-2006', 'dd-mm-yyyy'), to_date('09-05-2019', 'dd-mm-yyyy'), null, 314, '035510904', '978514891');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (50, to_date('11-12-2017', 'dd-mm-yyyy'), to_date('25-12-2017', 'dd-mm-yyyy'), null, 451, '918067269', '776528409');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (51, to_date('20-04-2016', 'dd-mm-yyyy'), to_date('28-11-2017', 'dd-mm-yyyy'), null, 445, '441785402', '973642055');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (52, to_date('21-03-2000', 'dd-mm-yyyy'), to_date('09-12-2021', 'dd-mm-yyyy'), null, 250, '274585073', '176375614');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (53, to_date('12-01-2013', 'dd-mm-yyyy'), to_date('17-01-2021', 'dd-mm-yyyy'), null, 224, '432884692', '266091930');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (54, to_date('05-07-2009', 'dd-mm-yyyy'), to_date('19-11-2017', 'dd-mm-yyyy'), null, 196, '275681892', '584514179');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (55, to_date('08-07-2009', 'dd-mm-yyyy'), to_date('31-07-2012', 'dd-mm-yyyy'), null, 566, '126770208', '545498579');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (56, to_date('19-04-2000', 'dd-mm-yyyy'), to_date('28-10-2013', 'dd-mm-yyyy'), null, 126, '651528067', '485100893');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (57, to_date('07-10-2008', 'dd-mm-yyyy'), to_date('25-07-2012', 'dd-mm-yyyy'), null, 476, '115243063', '185553927');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (58, to_date('19-01-2016', 'dd-mm-yyyy'), to_date('20-06-2022', 'dd-mm-yyyy'), null, 747, '840998924', '633954768');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (59, to_date('27-08-2014', 'dd-mm-yyyy'), to_date('07-01-2019', 'dd-mm-yyyy'), null, 600, '022601726', '370469772');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (60, to_date('27-08-2003', 'dd-mm-yyyy'), to_date('13-05-2016', 'dd-mm-yyyy'), null, 353, '136074808', '824236874');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (61, to_date('12-06-2019', 'dd-mm-yyyy'), to_date('26-06-2019', 'dd-mm-yyyy'), null, 604, '311690756', '701919398');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (62, to_date('28-09-2017', 'dd-mm-yyyy'), to_date('31-03-2019', 'dd-mm-yyyy'), null, 66, '652120441', '696456011');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (63, to_date('30-08-2012', 'dd-mm-yyyy'), to_date('02-12-2013', 'dd-mm-yyyy'), null, 80, '420027444', '269524383');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (64, to_date('10-09-2005', 'dd-mm-yyyy'), to_date('23-12-2023', 'dd-mm-yyyy'), null, 653, '793092711', '246071605');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (65, to_date('14-07-2009', 'dd-mm-yyyy'), to_date('25-11-2021', 'dd-mm-yyyy'), null, 477, '515228364', '094482935');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (66, to_date('06-09-2014', 'dd-mm-yyyy'), to_date('14-07-2020', 'dd-mm-yyyy'), null, 714, '129715075', '551736818');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (67, to_date('19-03-2007', 'dd-mm-yyyy'), to_date('28-06-2012', 'dd-mm-yyyy'), null, 194, '636976970', '984268974');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (68, to_date('14-07-2013', 'dd-mm-yyyy'), to_date('15-06-2021', 'dd-mm-yyyy'), null, 57, '545636009', '886474743');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (69, to_date('07-12-2016', 'dd-mm-yyyy'), to_date('21-12-2016', 'dd-mm-yyyy'), null, 444, '348351561', '053166731');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (70, to_date('02-05-2001', 'dd-mm-yyyy'), to_date('03-01-2018', 'dd-mm-yyyy'), null, 77, '830383231', '687142530');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (71, to_date('26-03-2003', 'dd-mm-yyyy'), to_date('07-03-2021', 'dd-mm-yyyy'), null, 216, '045601319', '697531067');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (72, to_date('15-08-2001', 'dd-mm-yyyy'), to_date('17-10-2022', 'dd-mm-yyyy'), null, 227, '725276037', '086072867');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (73, to_date('15-06-2021', 'dd-mm-yyyy'), to_date('29-06-2021', 'dd-mm-yyyy'), null, 417, '255474214', '032555609');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (74, to_date('03-01-2015', 'dd-mm-yyyy'), to_date('07-03-2019', 'dd-mm-yyyy'), null, 639, '464050791', '942977640');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (75, to_date('21-01-2019', 'dd-mm-yyyy'), to_date('20-03-2019', 'dd-mm-yyyy'), null, 325, '766927859', '113036851');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (76, to_date('04-06-2015', 'dd-mm-yyyy'), to_date('25-04-2021', 'dd-mm-yyyy'), null, 165, '136473730', '485100893');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (77, to_date('24-02-2004', 'dd-mm-yyyy'), to_date('11-04-2011', 'dd-mm-yyyy'), null, 438, '066516192', '855053927');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (78, to_date('28-11-2005', 'dd-mm-yyyy'), to_date('27-11-2023', 'dd-mm-yyyy'), null, 412, '230944652', '688973370');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (79, to_date('19-04-2004', 'dd-mm-yyyy'), to_date('15-04-2017', 'dd-mm-yyyy'), null, 255, '625324658', '850334182');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (80, to_date('15-10-2005', 'dd-mm-yyyy'), to_date('08-04-2010', 'dd-mm-yyyy'), null, 83, '957911531', '279175065');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (81, to_date('20-09-2012', 'dd-mm-yyyy'), to_date('14-12-2022', 'dd-mm-yyyy'), null, 662, '128447737', '090465425');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (82, to_date('21-06-2002', 'dd-mm-yyyy'), to_date('19-08-2022', 'dd-mm-yyyy'), null, 600, '490830032', '758867042');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (83, to_date('11-07-2021', 'dd-mm-yyyy'), to_date('25-07-2021', 'dd-mm-yyyy'), null, 204, '677905366', '934564949');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (84, to_date('17-08-2014', 'dd-mm-yyyy'), to_date('29-07-2020', 'dd-mm-yyyy'), null, 430, '819874679', '180191326');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (85, to_date('16-01-2006', 'dd-mm-yyyy'), to_date('25-04-2010', 'dd-mm-yyyy'), null, 505, '175978110', '175375438');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (86, to_date('12-07-2019', 'dd-mm-yyyy'), to_date('26-07-2019', 'dd-mm-yyyy'), null, 580, '376247399', '983815148');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (87, to_date('28-11-2023', 'dd-mm-yyyy'), to_date('12-12-2023', 'dd-mm-yyyy'), null, 242, '128447737', '145366143');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (88, to_date('30-06-2018', 'dd-mm-yyyy'), to_date('14-07-2018', 'dd-mm-yyyy'), null, 654, '754857377', '171756391');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (89, to_date('19-12-2000', 'dd-mm-yyyy'), to_date('05-04-2022', 'dd-mm-yyyy'), null, 78, '555012645', '216475555');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (90, to_date('27-12-2002', 'dd-mm-yyyy'), to_date('23-03-2024', 'dd-mm-yyyy'), null, 103, '555398022', '230944652');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (91, to_date('24-12-2006', 'dd-mm-yyyy'), to_date('20-07-2010', 'dd-mm-yyyy'), null, 264, '809030912', '336576783');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (92, to_date('07-10-2014', 'dd-mm-yyyy'), to_date('01-05-2023', 'dd-mm-yyyy'), null, 106, '097482024', '971662190');
commit;
prompt 300 records committed...
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (93, to_date('11-07-2018', 'dd-mm-yyyy'), to_date('25-07-2018', 'dd-mm-yyyy'), null, 56, '386518366', '798632254');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (94, to_date('20-08-2014', 'dd-mm-yyyy'), to_date('22-08-2021', 'dd-mm-yyyy'), null, 779, '348351561', '424018298');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (95, to_date('24-07-2022', 'dd-mm-yyyy'), to_date('07-08-2022', 'dd-mm-yyyy'), null, 311, '725276037', '560046205');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (96, to_date('14-12-2004', 'dd-mm-yyyy'), to_date('11-07-2019', 'dd-mm-yyyy'), null, 441, '121923546', '699698977');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (97, to_date('28-08-2004', 'dd-mm-yyyy'), to_date('24-11-2015', 'dd-mm-yyyy'), null, 323, '507745420', '280673575');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (98, to_date('26-08-2002', 'dd-mm-yyyy'), to_date('29-04-2010', 'dd-mm-yyyy'), null, 764, '562094648', '697531067');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (99, to_date('26-01-2005', 'dd-mm-yyyy'), to_date('04-08-2014', 'dd-mm-yyyy'), null, 513, '511449615', '729801502');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (100, to_date('11-11-2015', 'dd-mm-yyyy'), to_date('25-11-2015', 'dd-mm-yyyy'), null, 345, '272137266', '257490434');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (101, to_date('04-08-2002', 'dd-mm-yyyy'), to_date('26-01-2011', 'dd-mm-yyyy'), null, 312, '666467223', '657588520');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (102, to_date('08-07-2021', 'dd-mm-yyyy'), to_date('22-07-2021', 'dd-mm-yyyy'), null, 705, '454626264', '499584708');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (103, to_date('03-04-2014', 'dd-mm-yyyy'), to_date('25-08-2014', 'dd-mm-yyyy'), null, 71, '754857377', '177382748');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (104, to_date('19-02-2017', 'dd-mm-yyyy'), to_date('03-07-2023', 'dd-mm-yyyy'), null, 735, '348351561', '267137605');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (105, to_date('26-12-2019', 'dd-mm-yyyy'), to_date('09-05-2023', 'dd-mm-yyyy'), null, 197, '136074808', '335765816');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (106, to_date('04-12-2018', 'dd-mm-yyyy'), to_date('18-12-2018', 'dd-mm-yyyy'), null, 52, '783918714', '937829536');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (107, to_date('07-07-2016', 'dd-mm-yyyy'), to_date('09-08-2021', 'dd-mm-yyyy'), null, 540, '085170682', '805665451');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (108, to_date('29-11-2007', 'dd-mm-yyyy'), to_date('17-04-2019', 'dd-mm-yyyy'), null, 447, '840998924', '766598824');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (109, to_date('22-12-2023', 'dd-mm-yyyy'), to_date('05-01-2024', 'dd-mm-yyyy'), null, 669, '668963614', '315275105');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (110, to_date('03-04-2017', 'dd-mm-yyyy'), to_date('17-04-2017', 'dd-mm-yyyy'), null, 616, '806629624', '164868085');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (111, to_date('22-12-2012', 'dd-mm-yyyy'), to_date('05-01-2013', 'dd-mm-yyyy'), null, 428, '271730213', '302857054');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (112, to_date('02-02-2023', 'dd-mm-yyyy'), to_date('16-02-2023', 'dd-mm-yyyy'), null, 190, '064598882', '025274453');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (113, to_date('02-04-2023', 'dd-mm-yyyy'), to_date('16-04-2023', 'dd-mm-yyyy'), null, 24, '191792029', '874752399');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (114, to_date('12-05-2011', 'dd-mm-yyyy'), to_date('26-03-2013', 'dd-mm-yyyy'), null, 66, '723375847', '602505536');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (115, to_date('04-05-2008', 'dd-mm-yyyy'), to_date('02-06-2012', 'dd-mm-yyyy'), null, 367, '107455196', '584118594');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (116, to_date('19-12-2007', 'dd-mm-yyyy'), to_date('14-10-2013', 'dd-mm-yyyy'), null, 754, '531653197', '913760353');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (117, to_date('10-04-2010', 'dd-mm-yyyy'), to_date('16-02-2014', 'dd-mm-yyyy'), null, 318, '856216050', '644249525');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (118, to_date('02-03-2014', 'dd-mm-yyyy'), to_date('19-03-2019', 'dd-mm-yyyy'), null, 641, '984268974', '545327628');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (119, to_date('28-09-2016', 'dd-mm-yyyy'), to_date('17-03-2021', 'dd-mm-yyyy'), null, 674, '878867388', '348723377');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (120, to_date('05-10-2019', 'dd-mm-yyyy'), to_date('19-10-2019', 'dd-mm-yyyy'), null, 53, '847593760', '054248733');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (121, to_date('08-10-2022', 'dd-mm-yyyy'), to_date('22-10-2022', 'dd-mm-yyyy'), null, 103, '376247399', '953469588');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (122, to_date('18-10-2015', 'dd-mm-yyyy'), to_date('01-11-2015', 'dd-mm-yyyy'), null, 179, '160685460', '247748869');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (123, to_date('01-09-2018', 'dd-mm-yyyy'), to_date('21-08-2023', 'dd-mm-yyyy'), null, 559, '082415344', '553241085');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (124, to_date('16-09-2020', 'dd-mm-yyyy'), to_date('23-09-2021', 'dd-mm-yyyy'), null, 205, '265747418', '275004714');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (125, to_date('10-08-2013', 'dd-mm-yyyy'), to_date('09-03-2016', 'dd-mm-yyyy'), null, 311, '376247399', '110778805');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (126, to_date('12-10-2011', 'dd-mm-yyyy'), to_date('09-11-2015', 'dd-mm-yyyy'), null, 741, '897822661', '688569966');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (127, to_date('03-02-2005', 'dd-mm-yyyy'), to_date('09-03-2020', 'dd-mm-yyyy'), null, 407, '498584448', '086072867');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (128, to_date('04-05-2021', 'dd-mm-yyyy'), to_date('18-05-2021', 'dd-mm-yyyy'), null, 27, '480612577', '551736818');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (129, to_date('30-03-2016', 'dd-mm-yyyy'), to_date('13-04-2016', 'dd-mm-yyyy'), null, 394, '235099187', '905167354');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (130, to_date('18-01-2022', 'dd-mm-yyyy'), to_date('22-01-2024', 'dd-mm-yyyy'), null, 719, '240939313', '407435967');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (131, to_date('18-12-2010', 'dd-mm-yyyy'), to_date('15-10-2012', 'dd-mm-yyyy'), null, 771, '417953406', '528625739');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (132, to_date('16-07-2018', 'dd-mm-yyyy'), to_date('20-03-2019', 'dd-mm-yyyy'), null, 529, '129715075', '950424090');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (133, to_date('30-09-2018', 'dd-mm-yyyy'), to_date('26-09-2019', 'dd-mm-yyyy'), null, 479, '828869477', '701763678');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (134, to_date('05-04-2004', 'dd-mm-yyyy'), to_date('01-06-2012', 'dd-mm-yyyy'), null, 520, '487301584', '559859523');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (135, to_date('14-02-2022', 'dd-mm-yyyy'), to_date('28-02-2022', 'dd-mm-yyyy'), null, 718, '082415344', '280673575');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (136, to_date('27-01-2019', 'dd-mm-yyyy'), to_date('10-02-2019', 'dd-mm-yyyy'), null, 4, '766927859', '660975076');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (137, to_date('01-09-2021', 'dd-mm-yyyy'), to_date('15-09-2021', 'dd-mm-yyyy'), null, 663, '235099187', '490830032');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (138, to_date('19-02-2003', 'dd-mm-yyyy'), to_date('13-03-2015', 'dd-mm-yyyy'), null, 106, '396904603', '219278525');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (139, to_date('29-10-2005', 'dd-mm-yyyy'), to_date('22-04-2023', 'dd-mm-yyyy'), null, 760, '699698977', '054807164');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (140, to_date('18-02-2013', 'dd-mm-yyyy'), to_date('26-04-2018', 'dd-mm-yyyy'), null, 296, '266684771', '245272383');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (141, to_date('03-10-2016', 'dd-mm-yyyy'), to_date('10-07-2018', 'dd-mm-yyyy'), null, 796, '699698977', '655586968');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (142, to_date('25-05-2019', 'dd-mm-yyyy'), to_date('08-06-2019', 'dd-mm-yyyy'), null, 487, '699698977', '545327628');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (143, to_date('26-12-2008', 'dd-mm-yyyy'), to_date('13-03-2013', 'dd-mm-yyyy'), null, 616, '081383228', '591957858');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (144, to_date('06-08-2008', 'dd-mm-yyyy'), to_date('06-08-2023', 'dd-mm-yyyy'), null, 433, '745504002', '025953504');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (145, to_date('19-09-2013', 'dd-mm-yyyy'), to_date('26-02-2021', 'dd-mm-yyyy'), null, 275, '376247399', '653774196');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (146, to_date('18-12-2023', 'dd-mm-yyyy'), to_date('01-01-2024', 'dd-mm-yyyy'), null, 640, '666467223', '001852633');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (147, to_date('24-03-2010', 'dd-mm-yyyy'), to_date('05-06-2015', 'dd-mm-yyyy'), null, 634, '271730213', '252004653');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (148, to_date('19-07-2002', 'dd-mm-yyyy'), to_date('07-07-2023', 'dd-mm-yyyy'), null, 415, '311514630', '798632254');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (149, to_date('17-02-2008', 'dd-mm-yyyy'), to_date('28-11-2013', 'dd-mm-yyyy'), null, 1, '905167354', '035510904');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (150, to_date('06-01-2021', 'dd-mm-yyyy'), to_date('28-04-2024', 'dd-mm-yyyy'), null, 765, '348351561', '120938383');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (151, to_date('01-12-2009', 'dd-mm-yyyy'), to_date('28-01-2022', 'dd-mm-yyyy'), null, 712, '519792429', '090094931');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (152, to_date('07-10-2012', 'dd-mm-yyyy'), to_date('21-10-2012', 'dd-mm-yyyy'), null, 544, '697531067', '316852675');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (153, to_date('15-08-2005', 'dd-mm-yyyy'), to_date('20-11-2012', 'dd-mm-yyyy'), null, 32, '739670228', '831042091');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (154, to_date('15-07-2021', 'dd-mm-yyyy'), to_date('29-07-2021', 'dd-mm-yyyy'), null, 534, '811048828', '561919139');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (155, to_date('15-04-2008', 'dd-mm-yyyy'), to_date('14-05-2011', 'dd-mm-yyyy'), null, 362, '195785327', '600730948');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (156, to_date('08-10-2009', 'dd-mm-yyyy'), to_date('17-10-2017', 'dd-mm-yyyy'), null, 282, '195785327', '066163526');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (157, to_date('13-06-2007', 'dd-mm-yyyy'), to_date('19-05-2014', 'dd-mm-yyyy'), null, 261, '776528409', '772907524');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (158, to_date('22-12-2010', 'dd-mm-yyyy'), to_date('27-11-2019', 'dd-mm-yyyy'), null, 453, '191792029', '844554382');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (159, to_date('01-10-2007', 'dd-mm-yyyy'), to_date('08-12-2014', 'dd-mm-yyyy'), null, 545, '260510850', '119362966');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (160, to_date('28-12-2003', 'dd-mm-yyyy'), to_date('15-04-2014', 'dd-mm-yyyy'), null, 25, '555398022', '746109991');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (161, to_date('02-08-2012', 'dd-mm-yyyy'), to_date('16-08-2012', 'dd-mm-yyyy'), null, 471, '737691770', '776528409');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (162, to_date('29-08-2000', 'dd-mm-yyyy'), to_date('27-01-2016', 'dd-mm-yyyy'), null, 200, '723375847', '685213103');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (163, to_date('22-07-2013', 'dd-mm-yyyy'), to_date('10-09-2021', 'dd-mm-yyyy'), null, 124, '432425942', '694117241');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (164, to_date('26-10-2020', 'dd-mm-yyyy'), to_date('30-09-2021', 'dd-mm-yyyy'), null, 580, '797864475', '798632254');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (165, to_date('01-07-2001', 'dd-mm-yyyy'), to_date('07-10-2010', 'dd-mm-yyyy'), null, 291, '141376208', '513366861');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (166, to_date('01-08-2018', 'dd-mm-yyyy'), to_date('23-09-2019', 'dd-mm-yyyy'), null, 39, '001709568', '784609914');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (167, to_date('03-12-2012', 'dd-mm-yyyy'), to_date('11-09-2018', 'dd-mm-yyyy'), null, 763, '740708570', '245272383');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (168, to_date('14-01-2014', 'dd-mm-yyyy'), to_date('08-02-2024', 'dd-mm-yyyy'), null, 140, '932959604', '765668671');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (169, to_date('25-08-2016', 'dd-mm-yyyy'), to_date('08-09-2016', 'dd-mm-yyyy'), null, 602, '332572816', '176375614');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (170, to_date('22-02-2021', 'dd-mm-yyyy'), to_date('08-03-2021', 'dd-mm-yyyy'), null, 390, '680540698', '682014481');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (171, to_date('30-09-2014', 'dd-mm-yyyy'), to_date('14-10-2014', 'dd-mm-yyyy'), null, 718, '266091930', '180966239');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (172, to_date('25-04-2014', 'dd-mm-yyyy'), to_date('05-11-2023', 'dd-mm-yyyy'), null, 725, '718788104', '312108840');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (173, to_date('06-12-2004', 'dd-mm-yyyy'), to_date('29-07-2013', 'dd-mm-yyyy'), null, 120, '175188743', '608394597');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (174, to_date('26-07-2001', 'dd-mm-yyyy'), to_date('08-01-2011', 'dd-mm-yyyy'), null, 456, '526716833', '141376208');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (175, to_date('03-01-2022', 'dd-mm-yyyy'), to_date('17-01-2022', 'dd-mm-yyyy'), null, 552, '731223212', '066163526');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (176, to_date('23-05-2023', 'dd-mm-yyyy'), to_date('06-06-2023', 'dd-mm-yyyy'), null, 306, '688337870', '287066393');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (177, to_date('07-02-2005', 'dd-mm-yyyy'), to_date('08-05-2016', 'dd-mm-yyyy'), null, 301, '053166731', '402909496');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (178, to_date('02-07-2000', 'dd-mm-yyyy'), to_date('18-12-2016', 'dd-mm-yyyy'), null, 175, '783055575', '602220915');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (179, to_date('13-01-2007', 'dd-mm-yyyy'), to_date('04-02-2012', 'dd-mm-yyyy'), null, 15, '367706464', '783918714');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (180, to_date('21-07-2010', 'dd-mm-yyyy'), to_date('28-06-2012', 'dd-mm-yyyy'), null, 566, '226545801', '682262028');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (181, to_date('24-05-2021', 'dd-mm-yyyy'), to_date('21-10-2022', 'dd-mm-yyyy'), null, 707, '911294712', '086121419');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (182, to_date('14-07-2018', 'dd-mm-yyyy'), to_date('30-09-2021', 'dd-mm-yyyy'), null, 399, '978612834', '168438555');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (183, to_date('17-09-2013', 'dd-mm-yyyy'), to_date('23-12-2022', 'dd-mm-yyyy'), null, 719, '731223212', '275681892');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (184, to_date('22-01-2014', 'dd-mm-yyyy'), to_date('10-09-2014', 'dd-mm-yyyy'), null, 516, '092438204', '402100119');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (185, to_date('12-05-2010', 'dd-mm-yyyy'), to_date('26-05-2010', 'dd-mm-yyyy'), null, 755, '524440107', '418350339');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (186, to_date('28-02-2004', 'dd-mm-yyyy'), to_date('20-02-2019', 'dd-mm-yyyy'), null, 384, '409480749', '524896676');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (187, to_date('16-10-2012', 'dd-mm-yyyy'), to_date('01-01-2018', 'dd-mm-yyyy'), null, 662, '770600157', '122728860');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (188, to_date('03-02-2020', 'dd-mm-yyyy'), to_date('24-05-2023', 'dd-mm-yyyy'), null, 733, '266684771', '305084973');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (189, to_date('02-03-2006', 'dd-mm-yyyy'), to_date('27-08-2016', 'dd-mm-yyyy'), null, 11, '555012645', '849628298');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (190, to_date('25-11-2000', 'dd-mm-yyyy'), to_date('29-05-2012', 'dd-mm-yyyy'), null, 679, '029124580', '499600585');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (191, to_date('27-05-2006', 'dd-mm-yyyy'), to_date('24-05-2010', 'dd-mm-yyyy'), null, 416, '454626264', '703815502');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (192, to_date('30-11-2017', 'dd-mm-yyyy'), to_date('23-07-2023', 'dd-mm-yyyy'), null, 13, '591957858', '837162122');
commit;
prompt 400 records committed...
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (193, to_date('12-05-2007', 'dd-mm-yyyy'), to_date('24-02-2012', 'dd-mm-yyyy'), null, 548, '273149266', '523070923');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (194, to_date('24-02-2015', 'dd-mm-yyyy'), to_date('10-03-2015', 'dd-mm-yyyy'), null, 492, '855053927', '309732749');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (195, to_date('20-11-2019', 'dd-mm-yyyy'), to_date('04-12-2019', 'dd-mm-yyyy'), null, 238, '334283784', '077055177');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (196, to_date('27-10-2011', 'dd-mm-yyyy'), to_date('04-12-2014', 'dd-mm-yyyy'), null, 35, '175978110', '053166731');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (197, to_date('25-04-2022', 'dd-mm-yyyy'), to_date('09-05-2022', 'dd-mm-yyyy'), null, 707, '031510193', '756952320');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (198, to_date('17-05-2012', 'dd-mm-yyyy'), to_date('15-11-2020', 'dd-mm-yyyy'), null, 441, '238684624', '766598824');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (199, to_date('13-02-2009', 'dd-mm-yyyy'), to_date('09-07-2022', 'dd-mm-yyyy'), null, 324, '806629624', '424762764');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (200, to_date('05-07-2016', 'dd-mm-yyyy'), to_date('19-07-2016', 'dd-mm-yyyy'), null, 210, '934564949', '192192535');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (201, to_date('12-06-2004', 'dd-mm-yyyy'), to_date('14-09-2016', 'dd-mm-yyyy'), null, 210, '064598882', '302857054');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (202, to_date('02-05-2023', 'dd-mm-yyyy'), to_date('16-05-2023', 'dd-mm-yyyy'), null, 153, '766598824', '619459411');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (203, to_date('31-05-2005', 'dd-mm-yyyy'), to_date('22-01-2024', 'dd-mm-yyyy'), null, 659, '751666263', '655586968');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (204, to_date('15-07-2020', 'dd-mm-yyyy'), to_date('29-07-2020', 'dd-mm-yyyy'), null, 311, '081383228', '279593900');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (205, to_date('27-04-2014', 'dd-mm-yyyy'), to_date('11-05-2014', 'dd-mm-yyyy'), null, 750, '731223212', '934564949');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (206, to_date('20-11-2011', 'dd-mm-yyyy'), to_date('06-10-2012', 'dd-mm-yyyy'), null, 420, '515228364', '348723377');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (207, to_date('06-02-2010', 'dd-mm-yyyy'), to_date('09-02-2024', 'dd-mm-yyyy'), null, 283, '855053927', '939973048');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (208, to_date('02-06-2004', 'dd-mm-yyyy'), to_date('22-05-2010', 'dd-mm-yyyy'), null, 668, '136473730', '464019730');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (209, to_date('10-10-2015', 'dd-mm-yyyy'), to_date('24-10-2015', 'dd-mm-yyyy'), null, 5, '978612834', '866701211');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (210, to_date('28-01-2002', 'dd-mm-yyyy'), to_date('16-06-2018', 'dd-mm-yyyy'), null, 586, '913760353', '033035228');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (211, to_date('27-12-2020', 'dd-mm-yyyy'), to_date('10-01-2021', 'dd-mm-yyyy'), null, 32, '261535229', '468380581');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (212, to_date('17-01-2010', 'dd-mm-yyyy'), to_date('01-12-2013', 'dd-mm-yyyy'), null, 324, '647332571', '691006719');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (213, to_date('22-03-2015', 'dd-mm-yyyy'), to_date('05-04-2015', 'dd-mm-yyyy'), null, 399, '511449615', '942242894');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (214, to_date('18-01-2008', 'dd-mm-yyyy'), to_date('08-09-2013', 'dd-mm-yyyy'), null, 455, '348877136', '939973048');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (215, to_date('09-10-2002', 'dd-mm-yyyy'), to_date('05-11-2010', 'dd-mm-yyyy'), null, 168, '562094648', '316852675');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (216, to_date('20-01-2000', 'dd-mm-yyyy'), to_date('20-12-2011', 'dd-mm-yyyy'), null, 118, '886314861', '691197193');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (217, to_date('10-03-2011', 'dd-mm-yyyy'), to_date('27-11-2018', 'dd-mm-yyyy'), null, 575, '555012645', '530838321');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (218, to_date('22-06-2012', 'dd-mm-yyyy'), to_date('06-07-2012', 'dd-mm-yyyy'), null, 212, '911294712', '915567582');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (219, to_date('02-07-2003', 'dd-mm-yyyy'), to_date('28-06-2020', 'dd-mm-yyyy'), null, 558, '441785402', '781417795');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (220, to_date('16-09-2019', 'dd-mm-yyyy'), to_date('30-09-2019', 'dd-mm-yyyy'), null, 313, '562094648', '029695329');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (221, to_date('08-04-2019', 'dd-mm-yyyy'), to_date('22-04-2019', 'dd-mm-yyyy'), null, 78, '350849342', '226545801');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (222, to_date('09-02-2005', 'dd-mm-yyyy'), to_date('13-01-2019', 'dd-mm-yyyy'), null, 45, '555398022', '531109735');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (223, to_date('17-04-2001', 'dd-mm-yyyy'), to_date('11-09-2012', 'dd-mm-yyyy'), null, 22, '464019730', '751858214');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (224, to_date('02-01-2004', 'dd-mm-yyyy'), to_date('22-03-2017', 'dd-mm-yyyy'), null, 130, '311514630', '917208879');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (225, to_date('11-08-2011', 'dd-mm-yyyy'), to_date('24-12-2011', 'dd-mm-yyyy'), null, 31, '625324658', '315275105');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (226, to_date('19-01-2003', 'dd-mm-yyyy'), to_date('25-09-2012', 'dd-mm-yyyy'), null, 542, '958525594', '214713146');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (227, to_date('15-05-2007', 'dd-mm-yyyy'), to_date('14-10-2016', 'dd-mm-yyyy'), null, 492, '675892635', '981531119');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (228, to_date('16-07-2018', 'dd-mm-yyyy'), to_date('07-05-2020', 'dd-mm-yyyy'), null, 390, '645919226', '217140305');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (229, to_date('15-01-2000', 'dd-mm-yyyy'), to_date('20-09-2015', 'dd-mm-yyyy'), null, 296, '856216050', '507560616');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (230, to_date('31-05-2004', 'dd-mm-yyyy'), to_date('07-10-2012', 'dd-mm-yyyy'), null, 369, '639941357', '831042091');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (231, to_date('20-07-2021', 'dd-mm-yyyy'), to_date('07-07-2022', 'dd-mm-yyyy'), null, 233, '847593760', '658307215');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (232, to_date('06-11-2000', 'dd-mm-yyyy'), to_date('09-04-2012', 'dd-mm-yyyy'), null, 245, '831042091', '691197193');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (233, to_date('12-12-2017', 'dd-mm-yyyy'), to_date('26-12-2017', 'dd-mm-yyyy'), null, 296, '843169084', '011679094');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (234, to_date('14-12-2000', 'dd-mm-yyyy'), to_date('16-06-2016', 'dd-mm-yyyy'), null, 707, '740708570', '781417795');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (235, to_date('02-05-2018', 'dd-mm-yyyy'), to_date('16-05-2018', 'dd-mm-yyyy'), null, 540, '163506853', '853341811');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (236, to_date('10-10-2018', 'dd-mm-yyyy'), to_date('24-10-2018', 'dd-mm-yyyy'), null, 790, '137607044', '177902350');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (237, to_date('07-02-2002', 'dd-mm-yyyy'), to_date('12-12-2011', 'dd-mm-yyyy'), null, 412, '398898388', '235761739');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (238, to_date('04-05-2013', 'dd-mm-yyyy'), to_date('03-02-2023', 'dd-mm-yyyy'), null, 536, '499600585', '011679094');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (239, to_date('10-09-2003', 'dd-mm-yyyy'), to_date('20-10-2022', 'dd-mm-yyyy'), null, 168, '090465425', '176375614');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (240, to_date('04-07-2004', 'dd-mm-yyyy'), to_date('20-02-2018', 'dd-mm-yyyy'), null, 541, '896401490', '668963614');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (241, to_date('18-06-2013', 'dd-mm-yyyy'), to_date('02-07-2013', 'dd-mm-yyyy'), null, 297, '191792029', '186164668');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (242, to_date('28-08-2022', 'dd-mm-yyyy'), to_date('11-09-2022', 'dd-mm-yyyy'), null, 651, '273149266', '849628298');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (243, to_date('12-09-2020', 'dd-mm-yyyy'), to_date('26-09-2020', 'dd-mm-yyyy'), null, 721, '569056506', '217140305');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (244, to_date('17-12-2016', 'dd-mm-yyyy'), to_date('31-12-2016', 'dd-mm-yyyy'), null, 766, '126770208', '280673575');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (245, to_date('23-02-2018', 'dd-mm-yyyy'), to_date('08-12-2019', 'dd-mm-yyyy'), null, 256, '464019730', '124207649');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (246, to_date('08-10-2013', 'dd-mm-yyyy'), to_date('22-10-2013', 'dd-mm-yyyy'), null, 105, '244652438', '301595276');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (247, to_date('15-02-2012', 'dd-mm-yyyy'), to_date('05-03-2024', 'dd-mm-yyyy'), null, 47, '602220915', '847250676');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (248, to_date('17-01-2003', 'dd-mm-yyyy'), to_date('05-08-2011', 'dd-mm-yyyy'), null, 460, '830383231', '633954768');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (249, to_date('05-09-2015', 'dd-mm-yyyy'), to_date('10-09-2023', 'dd-mm-yyyy'), null, 8, '398898388', '983492574');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (250, to_date('07-03-2016', 'dd-mm-yyyy'), to_date('04-10-2022', 'dd-mm-yyyy'), null, 162, '031510193', '950424090');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (251, to_date('07-02-2006', 'dd-mm-yyyy'), to_date('05-12-2014', 'dd-mm-yyyy'), null, 466, '244652438', '257490434');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (252, to_date('10-07-2002', 'dd-mm-yyyy'), to_date('17-07-2023', 'dd-mm-yyyy'), null, 142, '939973048', '864337815');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (253, to_date('17-08-2011', 'dd-mm-yyyy'), to_date('13-10-2020', 'dd-mm-yyyy'), null, 593, '391006246', '740708570');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (254, to_date('10-01-2010', 'dd-mm-yyyy'), to_date('26-08-2011', 'dd-mm-yyyy'), null, 641, '793092711', '972588444');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (255, to_date('14-01-2017', 'dd-mm-yyyy'), to_date('28-01-2017', 'dd-mm-yyyy'), null, 478, '651528067', '805665451');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (256, to_date('07-01-2019', 'dd-mm-yyyy'), to_date('10-10-2019', 'dd-mm-yyyy'), null, 279, '039153067', '682014481');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (257, to_date('06-10-2009', 'dd-mm-yyyy'), to_date('06-06-2012', 'dd-mm-yyyy'), null, 139, '684705736', '086121419');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (258, to_date('11-10-2002', 'dd-mm-yyyy'), to_date('15-08-2013', 'dd-mm-yyyy'), null, 158, '697846160', '130969218');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (259, to_date('19-10-2019', 'dd-mm-yyyy'), to_date('20-10-2019', 'dd-mm-yyyy'), null, 378, '559859523', '279593900');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (260, to_date('06-11-2009', 'dd-mm-yyyy'), to_date('27-10-2014', 'dd-mm-yyyy'), null, 306, '566478959', '219278525');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (261, to_date('21-11-2012', 'dd-mm-yyyy'), to_date('24-03-2017', 'dd-mm-yyyy'), null, 41, '158263429', '251574841');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (262, to_date('04-05-2012', 'dd-mm-yyyy'), to_date('03-10-2017', 'dd-mm-yyyy'), null, 727, '664089285', '000677810');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (263, to_date('04-06-2001', 'dd-mm-yyyy'), to_date('20-09-2021', 'dd-mm-yyyy'), null, 432, '898194084', '810869456');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (264, to_date('15-04-2021', 'dd-mm-yyyy'), to_date('29-04-2021', 'dd-mm-yyyy'), null, 438, '699698977', '025815914');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (265, to_date('03-06-2003', 'dd-mm-yyyy'), to_date('16-10-2022', 'dd-mm-yyyy'), null, 683, '915701674', '332935578');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (266, to_date('19-02-2010', 'dd-mm-yyyy'), to_date('15-03-2020', 'dd-mm-yyyy'), null, 628, '574465011', '355658237');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (267, to_date('23-05-2004', 'dd-mm-yyyy'), to_date('22-05-2024', 'dd-mm-yyyy'), null, 31, '934564949', '191188653');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (268, to_date('11-11-2021', 'dd-mm-yyyy'), to_date('25-11-2021', 'dd-mm-yyyy'), null, 664, '396904603', '911294712');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (269, to_date('05-11-2000', 'dd-mm-yyyy'), to_date('16-02-2024', 'dd-mm-yyyy'), null, 440, '000677810', '055249826');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (270, to_date('17-10-2003', 'dd-mm-yyyy'), to_date('20-05-2019', 'dd-mm-yyyy'), null, 425, '028369330', '830383231');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (271, to_date('03-08-2009', 'dd-mm-yyyy'), to_date('21-08-2012', 'dd-mm-yyyy'), null, 77, '043493500', '526716833');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (272, to_date('10-05-2000', 'dd-mm-yyyy'), to_date('10-10-2020', 'dd-mm-yyyy'), null, 308, '141519886', '628942053');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (273, to_date('12-04-2011', 'dd-mm-yyyy'), to_date('28-08-2011', 'dd-mm-yyyy'), null, 704, '186328775', '319029281');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (274, to_date('04-02-2013', 'dd-mm-yyyy'), to_date('05-02-2022', 'dd-mm-yyyy'), null, 11, '567000152', '551736818');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (275, to_date('19-02-2017', 'dd-mm-yyyy'), to_date('05-03-2017', 'dd-mm-yyyy'), null, 630, '571326720', '346411238');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (276, to_date('07-02-2013', 'dd-mm-yyyy'), to_date('12-07-2020', 'dd-mm-yyyy'), null, 136, '614784421', '272137266');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (277, to_date('28-01-2002', 'dd-mm-yyyy'), to_date('16-04-2020', 'dd-mm-yyyy'), null, 665, '582783692', '531653197');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (278, to_date('12-10-2010', 'dd-mm-yyyy'), to_date('01-04-2016', 'dd-mm-yyyy'), null, 787, '494129418', '973642055');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (279, to_date('01-03-2017', 'dd-mm-yyyy'), to_date('09-05-2023', 'dd-mm-yyyy'), null, 455, '812794163', '625324658');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (280, to_date('16-03-2015', 'dd-mm-yyyy'), to_date('28-01-2017', 'dd-mm-yyyy'), null, 417, '806629624', '821726553');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (281, to_date('16-10-2016', 'dd-mm-yyyy'), to_date('21-04-2023', 'dd-mm-yyyy'), null, 183, '511449615', '780840485');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (282, to_date('04-11-2001', 'dd-mm-yyyy'), to_date('15-06-2013', 'dd-mm-yyyy'), null, 38, '448707100', '310404144');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (283, to_date('05-09-2004', 'dd-mm-yyyy'), to_date('12-07-2016', 'dd-mm-yyyy'), null, 511, '332533380', '257484513');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (284, to_date('24-04-2012', 'dd-mm-yyyy'), to_date('30-04-2012', 'dd-mm-yyyy'), null, 502, '050573245', '360641780');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (285, to_date('29-06-2023', 'dd-mm-yyyy'), to_date('13-07-2023', 'dd-mm-yyyy'), null, 497, '391352233', '106927049');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (286, to_date('14-12-2012', 'dd-mm-yyyy'), to_date('29-07-2023', 'dd-mm-yyyy'), null, 18, '240939313', '025274453');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (287, to_date('19-08-2006', 'dd-mm-yyyy'), to_date('12-05-2010', 'dd-mm-yyyy'), null, 11, '244652438', '240939313');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (288, to_date('06-08-2019', 'dd-mm-yyyy'), to_date('20-08-2019', 'dd-mm-yyyy'), null, 125, '488229246', '392278651');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (289, to_date('13-08-2007', 'dd-mm-yyyy'), to_date('23-11-2021', 'dd-mm-yyyy'), null, 705, '821726553', '206148591');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (290, to_date('11-08-2009', 'dd-mm-yyyy'), to_date('30-01-2014', 'dd-mm-yyyy'), null, 13, '145366143', '801792400');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (291, to_date('03-05-2023', 'dd-mm-yyyy'), to_date('11-12-2023', 'dd-mm-yyyy'), null, 300, '958886144', '386768609');
insert into PLAYLENDING (lendingid, lendingdate, duedate, returndate, copyid, clientid, librarianid)
values (292, to_date('30-06-2016', 'dd-mm-yyyy'), to_date('16-10-2016', 'dd-mm-yyyy'), null, 405, '797864475', '246071605');
commit;
prompt 500 records loaded
prompt Enabling foreign key constraints for BOOK...
alter table BOOK enable constraint SYS_C009920;
alter table BOOK enable constraint SYS_C009921;
prompt Enabling foreign key constraints for BOOKCOPY...
alter table BOOKCOPY enable constraint SYS_C009928;
prompt Enabling foreign key constraints for CLIENT...
alter table CLIENT enable constraint SYS_C009939;
prompt Enabling foreign key constraints for LIBRARIAN...
alter table LIBRARIAN enable constraint SYS_C009945;
prompt Enabling foreign key constraints for BOOKLENDING...
alter table BOOKLENDING enable constraint SYS_C009953;
alter table BOOKLENDING enable constraint SYS_C009954;
alter table BOOKLENDING enable constraint SYS_C009955;
prompt Enabling foreign key constraints for BOOK_AUTHOR...
alter table BOOK_AUTHOR enable constraint SYS_C009959;
prompt Enabling foreign key constraints for FINES...
alter table FINES enable constraint SYS_C0010043;
prompt Enabling foreign key constraints for NOTIFICATIONS...
alter table NOTIFICATIONS enable constraint SYS_C0010049;
prompt Enabling foreign key constraints for PLAY...
alter table PLAY enable constraint SYS_C009971;
alter table PLAY enable constraint SYS_C009972;
prompt Enabling foreign key constraints for PLAYCOPY...
alter table PLAYCOPY enable constraint SYS_C009977;
prompt Enabling foreign key constraints for PLAYLENDING...
alter table PLAYLENDING enable constraint SYS_C009985;
alter table PLAYLENDING enable constraint SYS_C009986;
alter table PLAYLENDING enable constraint SYS_C009987;
prompt Enabling triggers for BOOKCATEGORY...
alter table BOOKCATEGORY enable all triggers;
prompt Enabling triggers for BOOKPUBLISHER...
alter table BOOKPUBLISHER enable all triggers;
prompt Enabling triggers for BOOK...
alter table BOOK enable all triggers;
prompt Enabling triggers for BOOKCOPY...
alter table BOOKCOPY enable all triggers;
prompt Enabling triggers for PERSON...
alter table PERSON enable all triggers;
prompt Enabling triggers for CLIENT...
alter table CLIENT enable all triggers;
prompt Enabling triggers for LIBRARIAN...
alter table LIBRARIAN enable all triggers;
prompt Enabling triggers for BOOKLENDING...
alter table BOOKLENDING enable all triggers;
prompt Enabling triggers for BOOK_AUTHOR...
alter table BOOK_AUTHOR enable all triggers;
prompt Enabling triggers for FINES...
alter table FINES enable all triggers;
prompt Enabling triggers for NOTIFICATIONS...
alter table NOTIFICATIONS enable all triggers;
prompt Enabling triggers for PLAYCATEGORY...
alter table PLAYCATEGORY enable all triggers;
prompt Enabling triggers for PLAYPUBLISHER...
alter table PLAYPUBLISHER enable all triggers;
prompt Enabling triggers for PLAY...
alter table PLAY enable all triggers;
prompt Enabling triggers for PLAYCOPY...
alter table PLAYCOPY enable all triggers;
prompt Enabling triggers for PLAYLENDING...
alter table PLAYLENDING enable all triggers;

set feedback on
set define on
prompt Done
