/*

Tabelle bestehen aus Seiten

Datensätze kommen in Seiten . Ein Seite hat 8192bytes. Nur ca 8072 Nutzlast. 1 DS kann nur max 8060bytes
Eine Seite hat Slots, nicht mehr als 700.

8 Seiten am Stück werden Block genannt.
SQL Server leist gern blockweise.

DS werden immer von HDD in RAM geladen und dann erst kann erst User
Daten lesen

IO müssen reduziert werden..

Seiten werden 1:1 in RAM geladen

1 DS muss in eine Seite passen. Wenn ein DS nicht mehr reinpasst, dann bliebt die Lücken.


1 MIO DS . Jeder DS hat 4100 bytes. Seiten: 1 Mio . MB: 8 GB auf  HDD und RAM. Eigtl mur 4,1GB Daten
wenn 100 bytes weggebracht werden könnten

1 MIO DS 4000bytes  .. 500.000 Seiten... 4 GB HDD und RAM


Kann man feststellen wie groß der Verscheliss meiner Tabellen ist


*/

dbcc showcontig('t1')
--- Gescannte Seiten.............................: 30000
--- Mittlere Seitendichte (voll).....................: 50.79%  krank !!!!.. der müsste bei 98%

--id int identity, spx char(4100)     XY
--Wie verbessern: statt char ein varchar...aber die Anw geht nicht !










