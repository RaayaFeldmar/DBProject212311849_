
[General]
Version=1

[Preferences]
Username=
Password=2724
Database=
DateFormat=
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=LAX
Name=BOOKCOPY
Count=1000

[Record]
Name=COPYID
Type=NUMBER
Size=8
Data=sequence(1)
Master=

[Record]
Name=AVAILABLE
Type=NUMBER
Size=1
Data=random(0, 1)
Master=

[Record]
Name=YEARPUBLISHED
Type=NUMBER
Size=4
Data=random(1980, 2024)
Master=

[Record]
Name=EDITION
Type=NUMBER
Size=3
Data=random(1, 4)
Master=

[Record]
Name=BOOKID
Type=NUMBER
Size=6
Data=list(select bookId from book)
Master=

