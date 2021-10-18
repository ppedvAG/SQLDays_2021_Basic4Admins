/*

Installation 

Security
Authentifizierung

NT only: sicherer und weniger komplex (Migration  und Verwaltung)
gemischte Auth: NT + SQL Auth (eig Logins im SQL Server)
--> SA Konto (Vollzugriff)..komplexes Kennwort 17 Stellen.. später deaktvieren und Ersatzkonto

Wer soll aus NT der SQL Admin sein? 
also keine Windows Admin = SQL Admin !!
der muss definiert werden


Pfade
Db besteht aus: .mdf (Daten)  + .ldf (LogdataFile) Transaktionsprotokoll

jedes I U D schreibt immer zuerst in das ldf und synchron in RAM
Trenne daher Log und Daten physikalisch (per HDD).. je meher HDD desto schneller

Pfad für Backup



Dienstkonten
Datenbankmodul (SQLSERVR)
SQL AGENT (JOBS) .. immer wenn eteas per Zeitplan läuft
Browser Dienst .. für Instanzen. Teilt dem Client mit welchen Port er verwenden muss
	--> per default deaktiviert
	--> braucht Port UDP 1434
Volltextsuche: Volltextkatalog


Instanz
..mehrfach pro Server supported (50x)
jede Instanz ist absolut autark bzw isoliert (eig Prozess, eig RAM, eig CPU, eig Verz, eig DB)
aber warum? Produktiv und Testrechner oder weil die eine Software eine andere Version braucht

Sicherheit...der eine SA soll keinen Zugriff haben, daher andere Instanz

PC25 -- Aufruf der Standardinstanz   Port:  1433
benInstanz... Aufruf per PC25\benInstanz  Port: ???? (random)


Filestreaming
Häckchen :-) 
"Tabelle"´--> User: \\PC25\SQLServer\DB\Exponate   (=FileTabelle fiktiv)
rein unter SQL Server Verwaltung..
WINFS (2003 eingstellt)


TempDB
evtl meist verwend. DB... #tabellen und ##tabellen, Zeilenversionierung., IX .. 
evtl eig HDD 
noch besser: Log und Daten trennen
TraceFlags 1117 1118 werden automatisch gesetzt
Anzahl Cores = Anzahl Datendateien (max 8)


MAXDOP
Anzahl der CPU pro Abfrage
Nicht alle Prozessoren einer Abfrage zuzuordnen ist sinnvoll
Alle Cores (max 8) werden zugewiesen.. nicht unbedingt auch best practice



Arbeitsspeicher
Frage nach RAM (Min und MAX)nur der Datenpuffer gemeint
berücksichtige das OS.. mind. ca 2 GB






---DB Engine pus Volltextsuche plus Replikation
--Konnektivität


Dienstkonten: NT Service\SQLAgent$FE  unbeaufs. Dienstkonten (lok Konten)
		man kann auch AD KOnten verwenden. Brauchen keine besond. Rechte. 
				Werden loakle beim Setup vergeben

	--Netzwerkzugriff per ComputerKonto
	--Vorteil: Kennwörter werden autom. verwaltet auch Kennwortänderungen


Volumewartungstask.. Nullen befüllen
einem guten Admin sollte das rel egal sein.. ;-)
Das Wacshtum einer DB sollte regelm kontrolliert werden 
