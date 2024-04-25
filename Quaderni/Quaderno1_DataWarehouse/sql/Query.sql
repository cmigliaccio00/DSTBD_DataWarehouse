/*=========================================================
Quaderno 1 - Query in SQL 
										
										Carlo Migliaccio 
										16/11/2023
---------------------------------------------------------*/

/*=============================================================
1. Separatamente per ogni tipo di biglietto e per ogni mese 
(della validità del biglietto), analizzare: 
-le entrate medie giornaliere, (attenzione!) 
-le entrate cumulative dall'inizio dell'anno,
-la percentuale di biglietti relativi al tipo di biglietto 
considerato sul numero totale di biglietti del mese
-------------------------------------------------------------*/
SELECT Tipo, Mese, Anno, 
		--La granularità della tupla non è uguale a quella richiesta
		--dalla media da calcolare. Applico la definizione
	   (SUM(Incasso)/COUNT(DISTINCT TE.Data)) AS Incasso_AVG, 
       SUM(SUM(Incasso)) OVER (	PARTITION BY Tipo, Anno
							ORDER BY TO_DATE(Mese, "MM-YYYY")
							ROWS UNBOUNDED PRECEDING) AS Incasso_CUM,
	   100*(SUM(NumBiglietti) / 
			SUM((SUM(NumBiglietti)) OVER ( PARTITION BY Mese ) ) AS Perc_Tipo 
FROM Fatti F, Tipo T, Tempo TE
WHERE F.IdTipo=T.Id_Tipo AND 
	  F.IdTempo=TE.IdTempo
GROUP BY Tipo, Mese, Anno



/*============================================================
2. Considerare i biglietti del 2021. 
Separatamente per ogni museo e tipo di biglietto analizzare: 
-il ricavo medio per un biglietto
-la percentuale di ricavo sul ricavo totale per la 
categoria di museo e tipo di biglietto corrispondenti, 
-assegnare un rango al museo, per ogni tipo di biglietto, 
secondo il numero totale di biglietti in ordine decrescente.
-------------------------------------------------------------*/
SELECT NomeMuseo, Categoria, Tipo, 
	   (SUM(Incasso)/SUM(NumBiglietti)) AS Prezzo_Medio, 
       (100*SUM(Incasso)/ 
		( SUM(SUM(Incasso)) OVER 
			( PARTITION BY Categoria, Tipo) )
		) AS Perc_Ricavo,
	   DENSE_RANK() OVER (	
				PARTITION BY Tipo
				ORDER BY SUM(NumBiglietti) DESC
				) AS Ranking_Museo
FROM Fatti F, Museo M, Tempo T, Tipo TI
WHERE F.IdMuseo=M.IdMuseo AND 
	  T.IdTempo=F.IdTempo AND 
	  TI.IdTipo=F.IdTipo AND 
	  Anno='2021'
GROUP BY NomeMuseo, Categoria, Tipo