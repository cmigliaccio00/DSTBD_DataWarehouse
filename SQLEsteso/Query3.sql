/*=============================================================================
Selezionare per ogni data del mese di luglio 2003 l’incasso totale, 
e la media giornaliera degli incassi delle chiamate effettuate 
negli ultimi tre giorni.
------------------------------------------------------------------------------*/
SELECT Data, SUM(F.Prezzo) AS Incasso_TOT,
      ROUND( AVG (SUM(F.Prezzo)) OVER (   ORDER BY Data
                                    RANGE BETWEEN 
                                    INTERVAL  '2' DAY PRECEDING 
                                    AND CURRENT ROW ),2) AS Avg_3gg
FROM Fatti F, Tempo T
WHERE F.id_tempo=T.id_tempo AND 
      Mese='7-2003' 
GROUP BY Data