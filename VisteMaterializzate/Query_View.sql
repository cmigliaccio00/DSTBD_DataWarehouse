/*====================================================
Query sul Data warehouse 
	(...con MATERIALIZED VIEW)
									
									Carlo Migliaccio
									12/11/2023
----------------------------------------------------*/

--Query 1
SELECT Tipo_Tariffa, Mese, SUM(Incasso_tot) AS Incasso_tot
FROM VM2
WHERE Anno='2003'
GROUP BY CUBE(Tipo_Tariffa, Mese)
ORDER BY Tipo_Tariffa, TO_DATE(Mese,'MM-YYYY')

--Query 2
SELECT Mese, Incasso_TOT, Chiamate_TOT,
       DENSE_RANK() OVER (
            ORDER BY Incasso_TOT DESC
        ) AS Ranking
FROM VM1
ORDER BY Ranking

--Query 3
SELECT Mese, Chiamate_tot, 
       DENSE_RANK() OVER ( 
            ORDER BY Chiamate_tot
        ) AS Ranking
FROM VM1
WHERE Anno='2003'

--Query 4
SELECT Tipo_Tariffa, SUM(Incasso_TOT) AS Incasso_TOT
FROM VM2
WHERE Mese LIKE '7-2003%'
GROUP BY Tipo_Tariffa

--Query 5
SELECT Mese, Incasso_tot, 
       SUM(Incasso_tot) OVER (
            PARTITION BY Anno
            ORDER BY TO_DATE(Mese, 'MM-YYYY')
            ROWS UNBOUNDED PRECEDING
        ) AS Cumulativo
FROM VM1
ORDER BY TO_DATE(Mese, 'MM-YYYY')

--Query 6
SELECT Tipo_Tariffa, Mese, 
	   SUM(Incasso_Tot) AS Incasso_TOT,
        ROUND(100*SUM(Incasso_Tot)/
		(SUM(SUM(Incasso_TOT)) OVER (
			PARTITION BY Tipo_Tariffa)), 2
		) AS P1,
        ROUND(100*SUM(Incasso_Tot)/
		(SUM(SUM(Incasso_TOT)) OVER (	
			PARTITION BY Mese)), 2
		) AS P2
FROM VM2
WHERE Anno='2003'
GROUP BY Tipo_Tariffa, Mese
ORDER BY Tipo_Tariffa, TO_DATE(Mese, 'MM-YYYY')


