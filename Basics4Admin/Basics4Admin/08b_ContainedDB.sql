/*

http://blog.fumus.de/sql-server/contained-databasedie-eigenstndige-datenbank

Contained DB ist die eigenst�ndige DB

nur teilweise eigenst, was bedeutet: 
man sich an der DB Anmeldung ohne ein Login zu haben
daf�r muss man sich an der DB anmelden

es heisst nicht, dass Eintr�ge in der msdb mitgenmommen werden (Jobs etc)



Der Server muss unter Eigenschaften Erweitert die option Eigenst�ndigkeit 
erlaubt haben

Auch die DB muss das erlauben: Eiegnschaften der DB.. Optionen... 
Eigenst�ndigkeit: teilweise

Ich w�rde das DB 2.0 bezeichnen, denn die DB hat schlichtweg mehr Features als eine 
normale DB, aber nicht weniger...
Es gibt allerdings ein paar kleine Einschr�nkungen
	Crossabfragen
	Replikation Problem



*/


