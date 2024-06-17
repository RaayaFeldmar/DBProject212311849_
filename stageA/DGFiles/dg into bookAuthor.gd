
[General]
Version=1

[Preferences]
Username=
Password=2771
Database=
DateFormat=
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=LAX
Name=BOOK_AUTHOR
Count=700

[Record]
Name=AUTHOR
Type=VARCHAR2
Size=100
Data=firstName'-'lastName'
Master=

[Record]
Name=BOOKID
Type=NUMBER
Size=6
Data=list(select bookId from book)
Master=

