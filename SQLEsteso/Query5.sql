/* Selezionare per ogni mese, l'incasso del mese e l’incasso cumulativo 
dall’inizio dell’anno.*/
SELECT Anno, Mese, SUM(Prezzo) AS Incasso_Mese,
       SUM(SUM(Prezzo)) OVER (PARTITION BY Anno
                              ORDER BY Mese 
                              ROWS UNBOUNDED PRECEDING) AS Cumulativo
FROM Tempo T, Fatti F 
WHERE T.id_tempo=F.id_tempo 
GROUP BY Mese, Anno
ORDER BY Anno, Mese ASC