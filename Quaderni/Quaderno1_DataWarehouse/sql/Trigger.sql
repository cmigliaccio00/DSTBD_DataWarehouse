/*=========================================================
Quaderno 1 - TRIGGER 
	...per la manutenzione della vista materializzata VM1 
										
										Carlo Migliaccio 
										16/11/2023
---------------------------------------------------------*/
CREATE OR REPLACE TRIGGER Refresh_VM1 
AFTER INSERT ON FATTI 
FOR EACH ROW
DECLARE
VarTipo 	varchar(30); 
VarMod		varchar(30); 
VarMese		varchar(30); 
VarSemestre	varchar(30); 
VarAnno		number; 
N			number; 
BEGIN 
--recupero dalle tabelle dimensionali 
--le informazioni che mi servono
SELECT Tipo into VarTipo
FROM Tipo
WHERE IdTipo=:NEW.IdTipo; 

SELECT Modalita into VarMod
FROM Mod_Acquisto 
WHERE IdMod=:NEW.IdMod; 

SELECT Mese into VarMese
FROM TEMPO 
WHERE IdTempo=:NEW.IdTempo; 

SELECT Semestre into VarSemestre
FROM TEMPO
WHERE IdTempo=:NEW.IdTempo; 

SELECT Anno into VarAnno
FROM TEMPO
WHERE IdTempo=:NEW.IdTempo; 

--controllo (tramite la chiave) se nella vista 
--ho la tupla (Tipo, Modalita, Mese)
SELECT COUNT(*) into N
FROM VM1 
WHERE Tipo=VarTipo AND Modalita=VarMod AND 
	  Mese=VarMese; 

IF(N>0) THEN 
	--devo solo fare l'update
	UPDATE VM1
	SET Incasso=Incasso+:NEW.Incasso, 
		NumBiglietti=NumBiglietti+:NEW.NumBiglietti
	WHERE Tipo=VarTipo AND 
		  Modalita=VarMod AND 
		  Mese= VarMese; 
ELSE 
	--devo inserire per la prima volta il record
	INSERT INTO VM1 (Tipo, Modalita, Mese, Semestre, Anno, 
			         Incasso, NumBiglietti) 
	VALUES(VarTipo, VarModalita, VarMese, VarSemestre, VarAnno, 
		   :NEW.Incasso, :NEW.NumBiglietti); 
END IF; 

END