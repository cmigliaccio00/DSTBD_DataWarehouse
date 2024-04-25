/*=======================================================
Trigger 'Refresh_VM2' 
									Carlo Migliaccio
									12/11/2023
-------------------------------------------------------*/

CREATE OR REPLACE TRIGGER Refresh_VM2
AFTER INSERT ON FATTI
FOR EACH ROW 
DECLARE 
VarTariffa  VARCHAR(30); 
VarMese     VARCHAR(30); 
VarAnno     INTEGER;
N           NUMBER; 
BEGIN
--Recupero nome tariffa 
SELECT Tipo_Tariffa into VarTariffa
FROM Tariffe
WHERE id_tar=:NEW.id_tar; 
--Recupero mese 
SELECT Mese into VarMese
FROM Tempo 
WHERE id_tempo=:NEW.id_tempo; 
--Recupero Anno
SELECT Anno into VarAnno
FROM Tempo
WHERE id_tempo=:NEW.id_tempo;

--Vedo se il record già c'è 
SELECT COUNT(*) into N
FROM VM2
WHERE Tipo_Tariffa=VarTariffa   
      AND Mese=VarMese; 
      
IF (N>0)    THEN
    --Devo solo aggiornare, perché il record già c'è
    UPDATE VM2
    SET Incasso_Tot=Incasso_Tot+:NEW.Prezzo
    WHERE Tipo_Tariffa=VarTariffa AND 
          Mese=VarMese;
ELSE 
    --devo inserire il record
    INSERT INTO VM2(Tipo_Tariffa, Mese, Anno, Incasso_Tot)
    VALUES(VarTariffa, VarMese, VarAnno, :NEW.Prezzo); 
END IF; 

END;