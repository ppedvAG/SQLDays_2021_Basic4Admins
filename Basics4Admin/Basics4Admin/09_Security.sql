/*


Login: Betreten des SQL Servers
User: Rechte in einer DB

Login und User sind zwei getrennt zu betrachtende Dinge

Innerhalb der DB:

Schema entspricht Ordner
Rollen entspricht Gruppen


Auf Schemas können Rechte vergeben werden wie etwa Select 
damit kann der Benutzer alles Lesen , was innerhalb des Schemas liegt
*/


USE [master]
GO
CREATE LOGIN [EVI] WITH PASSWORD=N'123', DEFAULT_DATABASE=[Northwind], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

USE [Northwind]
GO
CREATE USER [EVI] FOR LOGIN [EVI]
GO

USE [Northwind]
GO
CREATE SCHEMA [MA] AUTHORIZATION [dbo]
GO

USE [Northwind]
GO
CREATE SCHEMA [IT] AUTHORIZATION [dbo]
GO

USE [Northwind]
GO
ALTER USER [EVI] WITH DEFAULT_SCHEMA=[MA]
GO
ALTER USER OTTO WITH DEFAULT_SCHEMA=IT
GO

--Recht auf Tabelle direkt vergeben
GRANT SELECT ON [IT].[kst] TO [Otto]
GO

--Leichter wird es mit Rollen
USE Northwind
GO
CREATE ROLE ITROLLE AUTHORIZATION [dbo]
GO
USE Northwind
GO
ALTER ROLE ITROLLE ADD MEMBER OTTO
GO



/*Serverrollen
eigenen sich dazu best Personen Administrationsrechte zu geben...

entweder verwendet man die vorgegebenen Serverrollen
oder man macht eig. Der Vorteil von selbsterstellten Serverrollen ist der, dass man die Rechte einzelen 
konfigurieren kann und nicht gleich zB alle Sicherheitsrechte bekommt..

*/

CREATE SERVER ROLE [KursDBSecurityRolle]
GO

ALTER SERVER ROLE [KursDBSecurityRolle] ADD MEMBER [Max]

GO

use [master]

GO

GRANT ALTER ON LOGIN::OTTO TO [KursDBSecurityRolle]

GO


USE [Northwind]
GO
CREATE ROLE [ITGruppe] AUTHORIZATION [dbo]
GO
USE [Northwind]
GO
ALTER ROLE [ITGruppe] ADD MEMBER [Otto]
GO


--Ein neuer Mitarbeiter Fritz kommt in die Firma..
--und soll dasselbe tun dürfen, was Otto macht

/*
1.Login anlegen
2.Benutzer anlegen passend zum Login (Usermapping)
3.In DBRolle ITGruppe mitaufnehmen

--> geht alles bereits beim Login anlegen..:-)




*/

USE [master]

GO

CREATE SERVER ROLE [SecondLevel] AUTHORIZATION [sa]

GO

ALTER SERVER ROLE [FirstLevelSupport] ADD MEMBER [SecondLevel]

GO

use [master]

GO

GRANT SHUTDOWN TO [SecondLevel]

GO



--PUBLIC = JEDER
--am besten nix damit tun.. alles was man damit tut+
--gilt für jeden..

--GUEST... am besten deaktiviert lassen
--ZUgriff auf DB ohne als Benutzer enthalten zu sein

--Solange man keine Rechte vergibt, bekommt man auch keine
--

