/*

master
Kernst�ck des SQL Server
	Login, DB, Settings des Servers
Backup?
ja.. bei �nderungen!

model
Vorlage f�r neue DBs..
create database (Kopie der Model)

Backup der Model?
bei �nderungen ja...Tipp: Script erstellen (Doku und Restore in einem)#

msdb
Db f�r den Agent (jobs, Zeitpl�ne, Emailsystem, Warnungen)
Backup der msdb?
bei �nderungen!

--tut evtl am meisten weh, weil das Widerherstellen sehr aufwendig sein kann




--Wartungsplan... Backup der SystemDBs

tempdb
..tempor�re Dinge: #t ##t, Zeilenversionierung, Auslagerung
..IX Wartung
Backup:
nee warum..macht keinen Sinn..

*/