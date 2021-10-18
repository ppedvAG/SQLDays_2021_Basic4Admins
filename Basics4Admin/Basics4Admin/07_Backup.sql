/*

Was kann passieren?

1. Logfile defekt
   Datendatei ist defekt	
2. HDD mit DB ist weg/defekt...
3. jemand manipuliert versehentlich Daten
4. SQL Server ist defekt, aber die HDD sind noch da..
5. Wenn man weiss, dass gleich was passieren kann..?
	Bei SP oder UP Installationen 
	wird oft auf ein Backup hingewiesen
6: DB Defekt.. korrupt (fehlerverdächtig)


Welche Sicherungen gibts denn?

Vollsicherung  V

Differentielle Sicherung  D

Transaktionsprotokollsicherung  T


Warum kann ich aber bei einer meiner DB keine T Sicherung machen..?
Weil es ein sog Wiederherstellungsmodel gibt...


pro DB 

Einfach
protokolliert INS UP DEL
werden TX nach Commit aus dem LOG gelöscht...es gibt nichts vernünftiges 
zu sichern

--> keine Logfile Sicherung
protokolliert auch INS UP DEL
aber massenoperation werden nicht exakt protokolliert

Massenprotkolliert

protokolliert INS UP DEL
aber massenoperation werden nicht exakt protokolliert

aber es wird nichts aus dem LOG entfernt


Vollständig
alles exakt protokollieren, was Änderungen in der DB stattfindet
wächst deutlich mehr
es löscht auch nichts aus dem Log

man kann hiermit auf Sekunde restoren....!


Wieviel Datenverlust in Zeit darf ich haben? 15min, 30min, 1h, aber auch 0
Wieviel zeit habe ich zum Restoren? 
-- wie lange darf einen DB ausfallen in Zeit?

diese Fragen ergeben die Sicherungsstrategie?


V
sichert die DB zu einem Zeitpukt, also auch nur diesen Zeitpubkt restoren
sichert die Dateien (nur Daten aber keine Leerräume)
auch Pfade und derern Dateinamen, auch Größenangaben

Differentielle 
sichert nur geänderte Seiten seit dem letzte V
Diff Sicherung ist auch wiedder nur ein Zeitpunkt

T
sichert wie ein Makro. Es werden alle Statements , die irgendwie "ändern"
protokoliert mit Zeitstempel
nur mit Hife des Logifles kann man auf Sekunde restoren

6 Uhr   V!
6:15	T
6:30	T
6:45    T
7 Uhr	D
		T
		T
	XXXX
		T
		T
		T
		T
12:00	D
		T!
		T!
12:30	T!

--Jetzt wissen wir folgendes:
Was ist der schnellste Restore , den man haben kann?
nur das V--> so oft wie möglich V Sicherung



Wie lange braucht man um ein T zu restoren?
so lange wie die darin befindlichen Aktionen dauerten.. in Summe
--> wir wollen nicht viele Ts und auch keinen großen Zeitumfang 
in den Ts haben
--> T sind oft nur im 15min Takt oder 30min


Wie oft mache ich dann eine D Sicherung?
ca alle 3 oder 4 T einen D Sicherung
Weil das D verkürzt sehr stark die restore Dauern
und sichert unseren Restore


Wir machen das T so häufig wie der max Datenverlust sein darf... zb 15min

Nur mit Hilfe der T Sicherung ist ein Sekundengenauer Restore möglich
Allerdings muss das Wiederherstellungsm iodel auf Voll gesetzt sein.




*/

--VOLLSICHERUNG
BACKUP DATABASE [Kurs2014DB] TO  DISK = N'D:\_BACKUP\Kurs2014DB.bak' 
	WITH NOFORMAT, NOINIT,  NAME = N'Kurs2014DB-Voll',
	SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

--DIFF
BACKUP DATABASE [Kurs2014DB] TO  DISK = N'D:\_BACKUP\Kurs2014DB.bak'
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  
NAME = N'Kurs2014DB-DIFF',
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO


--TLOG
BACKUP LOG [Kurs2014DB] TO  
DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH NOFORMAT, 
NOINIT,  NAME = N'Kurs2014DB-TLOG', SKIP, NOREWIND, 
NOUNLOAD,  STATS = 10
GO


---V TTT D TTT D TTT

--Fall 6:
--DB über das Menü restoren...
USE [master]
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 1, ,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5

GO




---RESTORE
--Fall 3 :  jemand manipuliert versehentlich Daten
--DB restoren, aber unter anderern Namen.
--Wenn man die Chance und die Infos besitzt, die versehentlich veränderten
--Daten zu korrigieren...
--Korrektur per TSQL



--11:31 problem .. wann ... 11:29 (9Uhr)
--Workaround: unter einen anderen Namen restoren
--und anschlissend per TSQL irgendwie die Daten korrigieren in der OrgDB

--V letzte D und alle nachfolgenden Ts

USE [master]
RESTORE DATABASE [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 1,  MOVE N'Kurs2014DB' TO N'D:\_SQLDB\Kurs2014DBxxALT.mdf',  MOVE N'Kurs2014DB_log' TO N'D:\_SQLDB\Kurs2014DBAxxLT_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DBALT] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5

GO


--FALL 6: DB fehlerverdächtig.. Sie 
--muss zum letztmöglichen Zeitpukt restored werden



--möglichst ohne Datenverlust:
--V  D TTT

--Restore geht nur wenn keine Verbidungen auf der DB sind..


/*
alle Verbindungen schliessen.. Aktivitätsmonitr oder Kill Prozessnummer
Backup LOG
restore V
Restore D
Restore aller Ts.  (Zeitpunkt 11:27:39
--jetzt 11:50 ..also würde alles, was seit 11:27 I U D war weg sein...


jetzt nochmal einen T Sicherung 11:50:00
Restore von 11:34:13

Protokollfragment= der ungesichterte teil des Logfiles



*/

--Resore ohne Datenverlust
--Allerdings sind neuere Daten im Backup und nicht in der DB..
--Die Fragmentsicherung sichert vor dem Restore automatisch den Teil des
--Protokolls, der noch nicht gesichert wurde...

USE [master]
ALTER DATABASE [Kurs2014DB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
BACKUP LOG [Kurs2014DB] TO  DISK = N'D:\_BACKUP\Kurs2014DB_LogBackup_2021-02-23_11-54-09.bak' WITH NOFORMAT, NOINIT,  NAME = N'Kurs2014DB_LogBackup_2021-02-23_11-54-09', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_BACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5
ALTER DATABASE [Kurs2014DB] SET MULTI_USER

GO


USE [master]
GO
ALTER DATABASE [KursDB] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'KursDB'
GO

-----Fall 1---------------------------------------
--Wenn das Logfile weg oder defekt ist
USE [master]
GO
CREATE DATABASE [KursDB] ON 
( FILENAME = N'D:\_SQLDB\KursDB.mdf' )
 FOR ATTACH
GO

USE [master]
GO
CREATE DATABASE [KursDB] ON 
( FILENAME = N'D:\_SQLDB\KursDB.mdf' ),
( FILENAME = N'D:\_SQLDB\KursDB_log.ldf' )
 FOR ATTACH
GO

--resore aus Backup auf anderen server
USE [master]
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 1,  MOVE N'Kurs2014DB' TO N'D:\_HRDB\Kurs2014DB.mdf',  MOVE N'Kurs2014DB_log' TO N'D:\_HRDB\Kurs2014DB_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 9,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 10,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 11,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [Kurs2014DB] FROM  DISK = N'D:\_HRBACKUP\Kurs2014DB.bak' WITH  FILE = 12,  NOUNLOAD,  STATS = 5

GO


--Fall 5: Wir wissen, dass etwas gleich passieren kann
--SP Installation


--der Snapshot kopiert Seiten vor Änderungen in die Snapshotdatei
USE master
GO

-- Create the database snapshot..nur lesbar, daher keine Tlog
CREATE DATABASE SN_KursDb2014_1330 ON
(	NAME = Kurs2014DB, --logischer Dateiname der OriginalDB
	FILENAME = 'D:\_SQLDB\SN_KursDb2014_1330.mdf' )--der Name der Datendatei des Snapshot
AS SNAPSHOT OF Kurs2014DB;
GO

--Mit Hilfe des Snapshot wollen wir Restoren

--1: Alle User müssen von der SnapshotDB runter
---- und auch von der OrigDB

use master -- am besten selbst nicht auf einer der DB sein;-)
select * from sysprocesses where dbid in (DB_ID('northwind'),db_id('snnwind')
KILL 72
KILL 77


--dauert 1 Sekunde....Obwohl die DB 1 GB groß war....!!
restore database Kurs2014DB
from database_snapshot='SN_KursDb2014_1330'

--es ersetzt keine normale Sicherung...

--man kann nur den Zeitpunkt restoren, zu dem man den Snapshot machte

--Kann man einen Snapshot sichern.. ?
--Nein

--Kann man eine DB sichern, die einen Snapshot besitzt.. ?
--Ja klar

--Kann man einen Snapshot restoren?
--Hä?  Ohne Sicherung kein restore .. 


--Kann man einen DB  restoren, die einen Snapshot besitzt?
--Leider nein, aber falls alle Snapshots gelöscht werden, geht auch der Restore wieder
--Ein Snapshot kann keine Garantie haben, was die Lebensdauer betrifft
--EIN DB kann aber durchaus mehrer Snapshots haben

--Wie kann User von der DB werfen...
--aber sollte man das so tun...? ;-)

USE [master]
GO
ALTER DATABASE Kurs2014DB SET  MULTI_USER WITH NO_WAIT
GO

select * from sysprocesses where dbid = db_id('Kurs2014DB')


--NUR DIE SICHERUNG DES TLOGS LEERT DAS TLOG!!!!!!!!

---ALSO Sicherungsstrategie

--20 GB
--Arbeitszeiten: Mo bis Fr  7 Uhr  bis 18 Uhr
--DB Ausfallszeit: 30min (Reaktionszeit+Restorezeit)
--Maximaler Verlust in Zeit ausgedrückt  15min

--Was wäre , wenn Verlust in Zeit = 0 sein soll==> Hochverfügbarkeit (Cluster, Spiegeln, AVG))
--Was wäre, wenn ich das mit dderDB zeitlich hinbringe

/*
V  jeden Tag     (Mo bis Fr) abends um 19
D  alle 4 T oder eben jede Stunde (Mo bis Fr 8:20  - bis 18:20)
T  alle 15min nur Mo bis Fr (7:15 - 18:15)


Sicherungsintegrität, Prüfsummen bei Fehler fortsetzen

*/


