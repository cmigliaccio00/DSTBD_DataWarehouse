/*=======================================================
MATERIALIZED VIEW VM1 
	(...accorpa le query 2, 3, 5)
							
							Carlo Migliaccio
							12/11/2023
-------------------------------------------------------*/

---(DDL) Vista materializzata propriamente detta
CREATE MATERIALIZED VIEW VM1
BUILD IMMEDIATE
REFRESH COMPLETE ON COMMIT
ENABLE QUERY REWRITE 
AS (    SELECT Mese, Anno, SUM(PREZZO) AS Incasso_TOT,
			   SUM(chiamate) AS Chiamate_TOT
        FROM Fatti F, Tempo TE
        WHERE TE.id_tempo=F.id_tempo
        GROUP BY Mese, Anno
);

--In presenza di MATERIALIZED VIEW LOG
CREATE MATERIALIZED VIEW VM1
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
ENABLE QUERY REWRITE 
AS (    SELECT Mese, Anno, SUM(PREZZO) AS Incasso_TOT
			   SUM(chiamate) AS Chiamate_TOT
        FROM Fatti F, Tempo TE
        WHERE TE.id_tempo=F.id_tempo
        GROUP BY Mese, Anno
);

-----------------------------------------------------------
-----------------------------------------------------------
--(DDL) Tabella gestita con trigger che monitora 
--la tabella dei fatti
CREATE TABLE VM1 (
	Mese 			VARCHAR(30)		NOT NULL, 
	Anno			INTEGER 		NOT NULL,
	Incasso_TOT		INTEGER			NOT NULL, 
	Chiamate_TOT 	INTEGER 		NOT NULL, 
	PRIMARY KEY(Mese)
); 

INSERT INTO VM1 (Mese, Anno, Incasso_TOT, Chiamate_TOT)
(   SELECT Mese, Anno, SUM(PREZZO) AS Incasso_TOT,
			   SUM(chiamate) AS Chiamate_TOT
        FROM Fatti F, Tempo TE
        WHERE TE.id_tempo=F.id_tempo
        GROUP BY Mese, Anno
);