/*
INDIZES

Gruppierten IX (Clustered) x = Tabelle nur 1mal pro Tabelle 
Nicht gruppierter IX (NON CL) x ca 1000mal pro Tabelle (Telefonbuch)
---------------------------------
zusammengesetzter IX ..besteht aus mehr als 1 Spalte
IX mit eingeschl Spalten ...Am Ende des IX Baums sind die eing. Spalten zusätzlich vorhanden
	..ohne den Baum selbst zu belasten..
je weniger Ebenen desto besser

eindeutigen IX x
gefilterter IX..nicht alle DS müssen im IX enthalten sein
abdeckenden IX  ..idealer IX zur Abfrage: reiner Seek ohne Lookup: ZIEL!!!!!!
ind Sicht
part Index
reale hypothetische IX
---------------------------------
Columnstore IX




*/

--zuerst die SPalte für den CL IX raussuchen, dann PK und Rest
--Strategie


select * into o1 from orders
set statistics io , time on
select * from orders where OrderID = 10260

select 49044*8--1:1 in RAM --ohne IX 600ms mit IX 0 ms

select * into c1 from customers

insert into c1 (CustomerID, CompanyName) values ('ppedv', 'Fa ppedv')

select * from customers





--ist die Tabelle ein HEAP oder ein CL IX?
-- CL IX

select * from best --kein TABL SCAN weil CL IX

--war das jetzt ok.. das Tab Design?

--CL IX wg PK
--Aufgabe des PK: ref. Int herstellen 1:N mit FK
--dafür muss er aber bei PK ne eindeutigkeit erreichen
--Eindeutig mit IX , ob mit N GR oder GR... egal
--wg PK auf ID ein CL IX auf ID




SELECT        Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.City, Customers.Country, Orders.EmployeeID, Orders.OrderDate, Orders.Freight, Orders.ShipCity, 
                         Orders.ShipCountry, Employees.LastName, Employees.FirstName, Employees.BirthDate, [Order Details].OrderID, [Order Details].ProductID, [Order Details].UnitPrice, [Order Details].Quantity, Products.ProductName, 
                         Products.UnitsInStock
INTO KU
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID


insert into ku
select * from ku


------welche Spalte sollte den CL IX haben: orderDate
select top 3 * from ku

select * into ku1 from ku

--neue Spalte mit ID Wert
alter table ku1 add ID int identity


set statistics io, time on --Messung von Seiten und CPU und Gesamtdauer in ms

select ID from ku1 where ID=100 --PLAN: TABLE SCAN weil HEAP.60323 300ms

--besser mit: NIX_ID eindeutig(weil GR IX eh schon weg für BDatum)
select ID from ku1 where ID=100 --Plan: IX Seek 0ms 3 Seiten

select ID, freight from ku1 where ID= 100--IX SEEK + Lookup(50)..4 Seiten oms

select ID, freight from ku1 where ID<11000--104 Seiten...99% für Lookup
--ab 12000 bereits Table SCAN

--Strategie: Vermeide Lookups..
-------      durch Aufnahme der fehlende Info in IX
--NIX_ID_FR
select ID, freight from ku1 where ID<820000 --auch hier noch IX Seek

--und jetzt
select ID, freight, city from ku1 where ID<100 --Lookup. idee alle Spalte in IX

--zusammengesetzter kann nur max 16 Spalten enthalten.. max 900byte für Schlüssel


select ID, freight, city from ku1 where ID<100



select companyname, SUM(unitprice*quantity) from 
	ku1 where Freight <=0.02 and Country = 'UK'
		group by CompanyName


--where Bedingungen ergeben die Schlüsselspalten
--select SPalten ergeben die eingeschlossenen Spalten


--bei oder sollten es eigtl 2 IX sein, aber SQL Server schlägt keinen mehr vor
select companyname, SUM(unitprice*quantity) from 
	ku1 where EmployeeID = 2 or ShipCountry = 'Germany'
		group by CompanyName


		--gefilterter IX: nicht mehr alle DS sind im IX vorhanden
select companyname, SUM(unitprice*quantity) from 
	ku1 where ShipCountry = 'Germany'
		group by CompanyName


--hat das was gebracht... ? vs IX ohne Landfilter




--Aufgaben für ADMin /DEV
--nur IX haben, die man braucht (Verwendet)
--die sollten rel ideal angelegt worden sein (abdeckend)
--fehlende IX und überflüssige IX

--woher weiss ich das..

select * from sys.dm_db_index_usage_stats where database_id = DB_ID()
--0 = HEAP
--1=CL IX
-->1 n gr IX





--PLAN: das Hilen der Daten: 
--SEEK herauspicken
--SCAN  A bis Z

--TABLE SCAN vs CL IX SCAN .. eigtl identisch
--CL IX SCAN vs IX SCAN    .. IX SCAN besser
--IX SEEK vs IX SCAN	   .. IX SEEK
--IX SEEK vs CL IX SEEK    .. eigtl identisch (die Ebenen zählen)


set statistics io, time on

select * into ku2 from ku

alter table ku2 add id int identity

select * from ku2 where ID= 100 --TAB SCAN

--DB Design: Seiten.. Füllgrad der Seiten

dbcc showcontig('ku2')
--- Gescannte Seiten.............................: 44217
--- Mittlere Seitendichte (voll).....................: 97.97%

--aber bei Table scan : 60320.. wir haben keine IX Strukturen

--Was passierte: neue Seiten angehängt mit IDs
--scheisse gelaufen


--einziger Weg: daten physikalisch neu schön ablegen
--Woher weiss ich das..?
--forward record count: zus. Seiten.. eigtl sollte das immer 0 sein
select * from sys.dm_db_index_physical_stats(db_id(),object_id('ku2'),NULL, NULL, 'detailed')

--es dürfte eigtl keinen HEAP geben

--vielen INS , dann besser mit HEAP (ID GUID + CL IX)

select newid()

--Latch: nur ein Thread kann auf eine Seite zugreifen





select * into ku3 from ku2

select * from ku3 where ID=17 --1 

select * from ku3 where CITY = 'London'

select * from ku3 where Country = 'UK'

select * from ku3 where Freight = 0.02 and EmployeeID = 2

--STAT aktualiesieren sich alle 20% Anderungen plus 500 + Abfrage


--select * into ku3 from ku1
---Abfrage : where aggregate
--Umsatz pro  Produkt aber nur für 'Rössle Sauerkraut' Ipoh Coffee
select top 3 * from ku1

--idealer IX: NIX_PN_i_upqu

select productname, SUM(unitprice*quantity) from ku1
where ProductName in ('Rössle Sauerkraut' ,'Ipoh Coffee')
Group by Productname

USE [Northwind]
GO
CREATE NONCLUSTERED INDEX NIXXY
ON [dbo].[ku1] ([ProductName])
INCLUDE ([UnitPrice],[Quantity])
GO

set statistics io, time on

--350MB Daten plus 360MB IX
select productname, SUM(unitprice*quantity) from ku1
where ProductName in ('Rössle Sauerkraut' ,'Ipoh Coffee')
Group by Productname

--schneller .. 3,5MB Daten.. real!.. Kompression.. it Archiv KOmression 3 MB auf HDD und in RAM
select productname, SUM(unitprice*quantity) from ku3
where EmployeeID = 3
Group by Productname

--Beste Idee für Columnstore: Archivtabellen, Stammtabellen,, je größer desto besser

--Prüfen der Columnstore Strukturen und deren Segmente:
select * from sys.dm_db_column_store_row_group_physical_stats







