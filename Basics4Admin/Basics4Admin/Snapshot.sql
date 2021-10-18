create database sn_testdb_1402
on  (name=testdb, filename='D:\testdbdaten2.mdf'),
	 (name=Stamm_datenxx, filename='d:\stammdatenxxsn2.ndf'),
	 (name=Umsatz_datenxx, filename='d:\umsatzdatensn2.ndf')
as snapshot of testdb


-- master verwenden
use master
restore database testdb from 
	database_snapshot='sn_testdb_1402'