
[General]
Version=1

[Preferences]
Username=
Password=2595
Database=
DateFormat=dd/mm/yyyy
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=LAX
Name=LIBRARIAN
Count=500

[Record]
Name=LIBRARIANID
Type=VARCHAR2
Size=9
Data=List(select personId from person)
Master=

[Record]
Name=STARTDATE
Type=DATE
Size=
Data=Random(1/1/2000, 1/5/2024)
Master=

[Record]
Name=USERNAME
Type=VARCHAR2
Size=50
Data=FirstName+[111]
Master=

[Record]
Name=USERPASSWORD
Type=VARCHAR2
Size=50
Data=[##########]
Master=

