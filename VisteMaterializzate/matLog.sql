/*=================================================
CREATE MATERIALIZED VIEW LOG 
	(...per il REFRESH in modalità fast)
							
								Carlo Migliaccio
								12/11/2023
-------------------------------------------------*/

--FATTI(id_tar, id_tempo, prezzo, chiamate)
CREATE MATERIALIZED VIEW LOG Fatti
WITH ROWID, SEQUENCE
(id_tar, id_tempo, prezzo, chiamate)
INCLUDING NEW VALUES; 

--tariffe(id_tar, tipo_tariffa)
CREATE MATERIALIZED VIEW LOG ON Tariffe
WITH ROWID, SEQUENCE
(id_tar, tipo_tariffa)
INCLUDING NEW VALUES;

--Tempo(id_tempo, mese, anno)
CREATE MATERIALIZED VIEW LOG ON Tempo
WITH ROWID, SEQUENCE
(id_tempo, mese, anno)
INCLUDING NEW VALUES;

--Per fare il rollback delle modifiche fatte prima 
DELETE FROM Fatti
WHERE   id_tempo=8 AND 
        id_tar=1 AND 
        id_luogo_chiamante=558 AND 
        id_luogo_chiamato=752; 

DELETE FROM Fatti
WHERE   id_tempo=1 AND 
        id_tar=6 AND 
        id_luogo_chiamante=558 AND 
        id_luogo_chiamato=752; 
		
--rifacciamo poi le insert...