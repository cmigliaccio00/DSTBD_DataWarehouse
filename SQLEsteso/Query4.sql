/*Per ogni regione chiamante, selezionare il numero mensile di chiamate 
e il numero mensile cumulativo di chiamate dall'inizio dell'anno.*/
SELECT Anno, Regione, Mese, SUM(Chiamate) AS Num_Chiamate,
       SUM(SUM(Chiamate)) OVER (---qui la granularità richiesta è maggiore
                                PARTITION BY Anno, Regione
                                ORDER BY TO_DATE(MESE, 'MM-YYYY') 
                                ROWS UNBOUNDED PRECEDING) AS Cumulativo
FROM Fatti F, Tempo T, Luogo L
WHERE F.id_tempo=T.id_tempo AND
      L.id_luogo=F.id_luogo_chiamante
GROUP BY Regione, Mese, Anno
ORDER BY Regione, TO_DATE(MESE, 'MM-YYYY') 
