/*=======================================================
MATERIALIZED VIEW VM2
	(...accorpa le query 1, 4, 6)
							
							Carlo Migliaccio
							12/11/2023
-------------------------------------------------------*/

--(DDL) Vista materializzata propriamente detta 
CREATE MATERIALIZED VIEW VM2
BUILD IMMEDIATE
REFRESH COMPLETE ON COMMIT
ENABLE QUERY REWRITE 
AS (    SELECT Tipo_Tariffa, Mese, Anno, SUM(PREZZO) AS Incasso_TOT
        FROM Fatti F, Tariffe T, Tempo TE
        WHERE F.id_tar=T.id_tar AND 
              TE.id_tempo=F.id_tempo
        GROUP BY Tipo_Tariffa, Mese, Anno
);

--Se prima di creare la vista creo i MATERIALIZED VIEW LOG
CREATE MATERIALIZED VIEW VM2
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
ENABLE QUERY REWRITE 
AS (    SELECT Tipo_Tariffa, Mese, Anno, SUM(PREZZO) AS Incasso_TOT
        FROM Fatti F, Tariffe T, Tempo TE
        WHERE F.id_tar=T.id_tar AND 
              TE.id_tempo=F.id_tempo
        GROUP BY Tipo_Tariffa, Mese, Anno
);

-----------------------------------------------------------
-----------------------------------------------------------
--(DDL) Tabella gestita con trigger che monitora 
--la tabella dei fatti
CREATE TABLE VM2 (
	Tipo_Tariffa 		VARCHAR(30)		NOT NULL, 
	Mese				VARCHAR(30)		NOT NULL, 
	Anno				INTEGER			NOT NULL, 
	Incasso_TOT			INTEGER			NOT NULL, 
	PRIMARY KEY(Tipo_Tariffa, Mese)
); 

INSERT INTO VM2(Tipo_Tariffa, Mese, Anno, Incasso_TOT)
(		SELECT Tipo_Tariffa, Mese, Anno, SUM(PREZZO) AS Incasso_TOT
        FROM Fatti F, Tariffe T, Tempo TE
        WHERE F.id_tar=T.id_tar AND 
              TE.id_tempo=F.id_tempo
        GROUP BY Tipo_Tariffa, Mese, Anno
);