/*

master
Kernstück des SQL Server
	Login, DB, Settings des Servers
Backup?
ja.. bei Änderungen!

model
Vorlage für neue DBs..
create database (Kopie der Model)

Backup der Model?
bei Änderungen ja...Tipp: Script erstellen (Doku und Restore in einem)#

msdb
Db für den Agent (jobs, Zeitpläne, Emailsystem, Warnungen)
Backup der msdb?
bei Änderungen!

--tut evtl am meisten weh, weil das Widerherstellen sehr aufwendig sein kann




--Wartungsplan... Backup der SystemDBs

tempdb
..temporäre Dinge: #t ##t, Zeilenversionierung, Auslagerung
..IX Wartung
Backup:
nee warum..macht keinen Sinn..

*/