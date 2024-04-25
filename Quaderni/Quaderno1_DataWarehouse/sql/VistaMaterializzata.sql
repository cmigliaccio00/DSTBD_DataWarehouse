/*=========================================================
Quaderno 1 - MATERIALIZED VIEW E LOG
										
										Carlo Migliaccio 
										16/11/2023
---------------------------------------------------------*/
--creazione della vista materializzata (richiede creazione 
--dei MATERIALIZED VIEW LOG)
CREATE MATERIALIZED VIEW VM1 
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
ENABLE QUERY REWRITE 
AS (	SELECT Tipo, Modalita, Mese, Semestre,Anno,
			   SUM(Incasso) AS Incasso, 
			   SUM(NumBiglietti) AS NumBiglietti
		FROM Fatti F, Tempo T, Tipo TI, Mod_Acquisto M
		WHERE F.IdTempo=T.IdTempo AND 
			  F.IdTipo=TI.IdTipo AND 
			  M.IdMod=F.IdMod
		GROUP BY Tipo, Modalita, Mese, Semestre,Anno
	)

--vista materializzata (senza comando) 
CREATE TABLE VM1 (
	Tipo			VARCHAR(30) 	NOT NULL, 
	Modalita		VARCHAR(30) 	NOT NULL,
	Mese			VARCHAR(30) 	NOT NULL,
	Semestre		VARCHAR(30) 	NOT NULL,
	Anno			INTEGER			NOT NULL, 
	Incasso			FLOAT			NOT NULL, 
	NumBiglietti	INTEGER 		NOT NULL,
	PRIMARY KEY(Tipo, Modalita, Mese)
); 

INSERT INTO VM1 (Tipo, Modalita, Mese, Semestre, Anno, Incaso, NumBiglietti)
(	SELECT Tipo, Modalita, Mese, Semestre,Anno,
			   SUM(Incasso) AS Incasso, 
			   SUM(NumBiglietti) AS NumBiglietti
	FROM Fatti F, Tempo T, Tipo TI, Mod_Acquisto M
	WHERE F.IdTempo=T.IdTempo AND 
			  F.IdTipo=TI.IdTipo AND 
			  M.IdMod=F.IdMod
	GROUP BY Tipo, Modalita, Mese, Semestre,Anno
); 

/*===============================================================
Per usare il FAST REFRESH, devo creare prima di creare la vista
i MATERIALIZED VIEW LOG che agiscono sulle tabelle coinvolte
dalla vista stessa. Questo nella modalità seguente:

Le opzioni ROWID e SEQUENCE sono usate per l'ordine di inserimento 
e di conseguenza per l'aggiornamento della vista  
---------------------------------------------------------------*/
CREATE MATERIALIZED VIEW LOG ON TIPO 
WITH ROWID, SEQUENCE
(IdTipo, Tipo)
INCLUDING NEW VALUES; 

CREATE MATERIALIZED VIEW LOG ON Mod_Acquisto
WITH ROWID, SEQUENCE
(IdMod, Modalita)
INCLUDING NEW VALUES; 

CREATE MATERIALIZED VIEW LOG ON Tempo 
WITH ROWID, SEQUENCE
(IdTempo, Mese, Semestre, Anno)
INCLUDING NEW VALUES; 

CREATE MATERIALIZED VIEW LOG ON Fatti
WITH ROWID, SEQUECE
(IdTipo, IdMod, IdTempo, IdMuseo, Incasso, NumBiglietti)
INCLUDING NEW VALUES; 


--N.B.: Questi sono da creare PRIMA del comando 
--CREATE MATERIALIZED VIEW

	