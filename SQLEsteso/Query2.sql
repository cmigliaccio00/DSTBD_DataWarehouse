/*=============================================================================
Selezionare per ogni mese dell’anno 2003 il numero di chiamate totali. 
Utilizzando la funzione RANK(), associare ad ogni mese un numero che identifica 
la posizione del mese all'interno dei vari mesi dell’anno 2003 in funzione 
del numero di chiamate totali (1 per il mese con più telefonate, 2 per il secon-
do mese, ecc.)
------------------------------------------------------------------------------*/
SELECT Mese, SUM(Chiamate) AS Tot_Chiamate,
       DENSE_RANK() OVER ( ORDER BY SUM(F.chiamate) DESC) 
                    AS Rank4Chiamate
FROM Fatti F, Tempo T 
WHERE F.id_tempo = T.id_tempo AND
      Anno='2003'
GROUP BY Mese