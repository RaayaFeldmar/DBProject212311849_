
[General]
Version=1

[Preferences]
Username=
Password=2614
Database=
DateFormat=
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=LAX
Name=CLIENT
Count=500

[Record]
Name=CLIENTID
Type=VARCHAR2
Size=9
Data=List(select personId from person)
Master=

[Record]
Name=ACTIVE
Type=NUMBER
Size=1
Data=Random(0, 1)
Master=

[Record]
Name=MAXBOOKS
Type=NUMBER
Size=2
Data=Random(1, 12)
Master=

