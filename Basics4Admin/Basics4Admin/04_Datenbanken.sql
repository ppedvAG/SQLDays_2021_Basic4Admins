drop database testdb

/*
mdf und ldf Datei



*/

use master;
GO

create database demodb;
GO

/*
viele Fehler...

wo sind deine mdf und ldf Dateien.. in Standardpfaden

wie groß sind die Datein bzw wie groß ist die DB? 16MB
mdf 8 MB
ldf 8 MB

Wachstumraten: pro Datei 64MB
--immer noch verdammt klein

Tipp: wie lange lebt deine Hardware.. als Faktor für Größe der DB
keine Angst Luft wird nicht mitgesichert

Logfile: ca 25% der Datendatei
Ziel: Logfile sollte nie wachsen: durch regel. Backup des Logfiles
Sicherung des Logfiles leert das Logfile

Wo liegen die Dateien...



bis SQL 2014: 
5 MB /Daten; 1MB und 
Log 2 MB; 10%






*/

USE [demodb]
GO
DBCC SHRINKFILE (N'demodb' , 1)
GO
USE [demodb]
GO
DBCC SHRINKFILE (N'demodb_log' , 1)
GO
USE [master]
GO
ALTER DATABASE [demodb] MODIFY FILE ( NAME = N'demodb', FILEGROWTH = 1024KB )
GO
ALTER DATABASE [demodb] MODIFY FILE ( NAME = N'demodb_log', FILEGROWTH = 10%)
GO



CREATE DATABASE [demodb2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'demodb2', FILENAME = N'D:\_SQLDB\demodb2.mdf' , 
	SIZE = 614400KB , FILEGROWTH = 1024000KB )
 LOG ON 
( NAME = N'demodb2_log', 
FILENAME = N'D:\_SQLDB\demodb2_log.ldf' , SIZE = 204800KB , FILEGROWTH = 1024000KB )
GO


use demodb;
GO

create table t1 
		(id int identity,
		 spx char(4100));--immer 4100byte 
GO


insert into t1
select 'XY'
GO 20000 --20 Sekunden.. ca 55 sekunden.. theoretisch 4Kb * 20000 = 80MB


--DB wurde auf 160MB vergrößert... Logfile 21 MB

--Einfache KOntrolle durch Berichte der DB .. Datenträgerverwendung
--es dürften nicht sehr viele Vergrößerung stattgefunden haben .. oder kein


create table t2 
(id int identity,
		 spx char(4100));--immer 4100byte 
GO


insert into t2
select 'XY'
GO 20000


--4 Sekunden besser..... keine Fragmentierung ...




