/*====================================================
Query sul Data warehouse
									
									Carlo Migliaccio
									12/11/2023
----------------------------------------------------*/

--Query 1
SELECT Tipo_Tariffa, Mese, SUM(Prezzo) AS Incasso_TOT
FROM Fatti F, Tempo T, Tariffe TA
WHERE F.id_tempo=T.id_tempo AND 
TA.id_tar=F.id_tar AND Anno='2003'
GROUP BY CUBE(Tipo_Tariffa, Mese)
ORDER BY Tipo_Tariffa, TO_DATE(Mese, 'MM-YYYY')

--Query 2
SELECT DENSE_RANK() OVER (
		ORDER BY SUM(Prezzo)
		) AS Rank_Incasso,
       Mese, SUM(Chiamate) AS Num_Chiamate, 
	   SUM(Prezzo) AS Incasso_TOT
FROM Fatti F, Tempo T
WHERE F.id_tempo=T.id_tempo
GROUP BY Mese

--Query 3
SELECT DENSE_RANK() OVER (
		ORDER BY SUM(Chiamate)
		) AS Rank_Chiamate,
       Mese, SUM(Chiamate) AS Num_Chiamate, 
	   SUM(Prezzo) AS Incasso_TOT    
FROM Fatti F, Tempo T
WHERE F.id_tempo=T.id_tempo
GROUP BY Mese

--Query 4
SELECT Tipo_Tariffa, SUM(Prezzo) AS Incasso_Tot
FROM Fatti F, Tariffe T, Tempo TE
WHERE F.id_tempo=Te.id_tempo AND 
      F.id_tar=T.id_tar AND
      Mese LIKE '7-2003%'
GROUP BY Tipo_Tariffa
ORDER BY Incasso_Tot DESC

--Query 5
SELECT Anno, Mese, SUM(Prezzo) AS Incasso_Mese, 
       SUM(SUM(Prezzo)) OVER (
				PARTITION BY Anno
                ORDER BY TO_DATE(Mese, 'MM-YYYY')
                ROWS UNBOUNDED PRECEDING
				) AS Cum_Anno
FROM Fatti F, Tempo T
WHERE f.id_tempo=T.id_tempo
GROUP BY Mese, Anno
ORDER BY Anno, TO_DATE(Mese, 'MM-YYYY')

--Query 6
SELECT Tipo_Tariffa, Mese, SUM(Prezzo)AS IncassoTotale,
       ROUND(100*SUM(Prezzo)/(SUM(SUM(Prezzo)) 
	   OVER (	PARTITION BY Mese
		)	),2) AS Perc_Incasso,
       ROUND(100*SUM(Prezzo)/(SUM(SUM(Prezzo)) OVER ()
	   ),2) AS Perc_Tariffa
FROM Tariffe T, Fatti F, Tempo TE
WHERE TE.id_tempo=F.id_tempo AND
      F.id_tar=T.id_tar AND
      Anno='2003'
GROUP BY Tipo_Tariffa, Mese
ORDER BY TO_DATE(Mese, 'MM-YYYY'),Tipo_Tariffa