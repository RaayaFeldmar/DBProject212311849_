
[General]
Version=1

[Preferences]
Username=
Password=2720
Database=
DateFormat=dd-mm-yyyy
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=LAX
Name=PLAYLENDING
Count=500

[Record]
Name=LENDINGID
Type=NUMBER
Size=
Data=Sequence(1)
Master=

[Record]
Name=LENDINGDATE
Type=DATE
Size=
Data=Random(1-1-2000, 1-1-2024)
Master=

[Record]
Name=DUEDATE
Type=DATE
Size=
Data=Random(1-1-2010, 29-5-2024)
Master=

[Record]
Name=RETURNDATE
Type=DATE
Size=
Data=
Master=

[Record]
Name=COPYID
Type=NUMBER
Size=8
Data=List(select copyId from playCopy)
Master=

[Record]
Name=CLIENTID
Type=VARCHAR2
Size=9
Data=List(select clientId from client)
Master=

[Record]
Name=LIBRARIANID
Type=VARCHAR2
Size=9
Data=List(select librarianId from librarian)
Master=

