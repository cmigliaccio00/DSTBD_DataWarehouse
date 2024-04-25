/*Considerare l’anno 2003. 
Analizzare l’incasso totale 
(i) separatamente per ogni mese, 
(ii) separatamente per ogni mese, tariffa telefonica e regione chiamante 
(iii) separatamente per ogni mese, tariffa telefonica e regione ricevente. */
SELECT  Mese, Tipo_Tariffa, L1.regione AS Reg_Chiamante, 
        L2.regione AS Reg_Ricevente, SUM(Prezzo) AS IncassoTotale
FROM Fatti F, Luogo L1, Tempo T, Luogo L2, Tariffe TA
WHERE F.id_luogo_chiamante = L1.id_luogo AND 
      F.id_luogo_chiamato = L2.id_luogo AND 
      TA.id_tar=F.id_tar AND
      F.id_tempo=T.id_tempo AND 
      Anno='2003'
GROUP BY GROUPING SETS(Mese, (Mese, Tipo_tariffa, L1.regione), 
                        (Mese, Tipo_tariffa, L2.regione))
ORDER BY TO_DATE(Mese, 'MM-YYYY'), Tipo_Tariffa