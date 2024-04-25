/*=======================================================
Trigger 'Refresh_VM1' 
									Carlo Migliaccio
									12/11/2023
-------------------------------------------------------*/
CREATE OR REPLACE TRIGGER Refresh_VM1 
AFTER INSERT ON FATTI
FOR EACH ROW 
DECLARE 
VarMese VARCHAR(30);
VarAnno NUMBER;
N   NUMBER;     
BEGIN 
--Recupero il mese
SELECT Mese into VarMese
FROM Tempo
WHERE Id_tempo=:NEW.id_tempo;
--Recupero l'anno
SELECT Anno into VarAnno
FROM Tempo 
WHERE Id_tempo=:NEW.id_tempo;
--Controllo se ho il record usando la chiave della vista
SELECT COUNT(*) INTO N
FROM VM1 
WHERE Mese=VarMese; 

IF(N>0) THEN 
    --record già presente, devo fare UPDATE    
    UPDATE VM1 
    SET Incasso_Tot = Incasso_Tot + :NEW.Prezzo,
		Chiamate_Tot = Chiamate_Tot + :NEW.Chiamate
    WHERE Mese=VarMese; 
ELSE
    --devo inserire un nuovo record nella vista
    INSERT INTO VM1
	(Mese, Anno, Incasso_Tot, Chiamate_Tot)
    VALUES(VarMese, VarAnno, :NEW.Prezzo, :NEW.Chiamate); 
END IF;
END;