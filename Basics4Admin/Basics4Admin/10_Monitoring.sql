--Live...

/*
TaskManager
Ist es wirklich der SQL Server?
Reicht der Speicher aus: Max Arbeitssatz...im Vergl zu akt Arbeitssatz
 Ressourcemonitor: in welche Ressource (HDD) findet die Traffic statt



 Tools zum Aufzeichnen:

Windows perfmon
SQL Instanzen integrieren ca 2900 Insikatoren..
Perfmon Aufzeichnung: Lieber etwas zuviel als zuwenig
	grafische Auswertung 


 Profiler.. hat eigtl ausgedient.. depricated
	Vergeich mit Perfmon möglich

 Xtended Events  das moderene Tool, aber nicht alle Fäfigkeiten des Profiler
				dafür genauer, merh Möglichekeiten der Aufzeichnung
				dafür weniger Vergelich mit Perfmon möglich


 manuell DMVS Ergebisse regelmäßig sichern (inkl Zeitstenmpel)

 
 Datensammlung  automatisiert
 
 QueryStore
 Abfragespeicher pro DB ..muss gestartet werden




 --DMVs =  Datamanagement Views
--System = OS = SQL Server

--Wichtige Systemsicht: os_wait_Stats

--die Wartezeiten sind kummilierend seit Neustart
select * into wartezeiten 
from sys.dm_os_wait_stats order by 3 desc


--Starte nie neu, weil sonst die Messung auf 0 resettet werden

--was muss zur Interpretation nicht dabei sein..
-- alles mit Sleep, Lazy, Queue..
--Idee: Wartezeit in Summe im Verh zum einz Wert
--Idee: Signalzeit muss unter 25% der Wartezeit sein

--Alle Systemsichten beginnen mit sys und sind in allen DB gleichermassen vertreten
-- guggste Sichten- Systemsichten

--nicht alle beginnen mit sys.dm_os (SQL System)
--						  sys.dm_db (Datenbankinfos)




*/


--Monitoring von Tabellen Sichten Proz F()
--DML Trigger CREATE ALTER DROP
--DDL Trigger für INS UP DEL

--Monitoring der Datensätze
--Überwachung...
--Profiler

update orders set Freight = Freight *1.10
rollback
--Xvents
CREATE EVENT SESSION [OrdersNwind2] ON SERVER 
ADD EVENT sqlserver.module_end(
    ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.server_instance_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'orders'))),
ADD EVENT sqlserver.module_start(
    ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.server_instance_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'orders'))),
ADD EVENT sqlserver.rpc_starting(
    ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.server_instance_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%orders%'))),
ADD EVENT sqlserver.sp_statement_starting(
    ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.server_instance_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%orders%'))),
ADD EVENT sqlserver.sql_batch_starting(
    ACTION(sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.server_instance_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%orders%')))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO


