
[General]
Version=1

[Preferences]
Username=
Password=2016
Database=
DateFormat=
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=LAX
Name=PLAYCOPY
Count=800

[Record]
Name=COPYID
Type=NUMBER
Size=8
Data=Sequence(1)
Master=

[Record]
Name=AVAILABLE
Type=NUMBER
Size=1
Data=Random(0, 1)
Master=

[Record]
Name=PLAYID
Type=NUMBER
Size=6
Data=List(select playId from play)
Master=

