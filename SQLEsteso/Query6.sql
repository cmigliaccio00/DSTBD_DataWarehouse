/*
Considerare l誕nno 2003. Separatamente per tariffa e mese, analizzare 
(i) l段ncasso totale, 
(ii) la percentuale dell段ncasso rispetto all段ncasso totale considerando tutte 
le tariffe telefoniche, 
(iii) la percentuale dell段ncasso rispetto all段ncasso totale 
considerando tutti i mesi.
*/
SELECT Tipo_Tariffa, Mese, SUM(Prezzo) AS IncassoTotale,
       ROUND ((100*SUM(Prezzo) / (SUM(SUM(Prezzo)) OVER (  
                            PARTITION BY MESE) )),2) AS Perc_Mese,
       ROUND((100*SUM(Prezzo) / (SUM(SUM(Prezzo)) OVER (
                            PARTITION BY MESE) )),2) AS Perc_Tariffe
FROM Fatti F, Tempo T, Tariffe TA
WHERE F.id_tempo = T.id_Tempo AND 
      TA.id_tar = F.id_tar
      AND Anno='2003'
GROUP BY Tipo_Tariffa, Mese

