/*==============================================================================
1. Selezionare l’incasso totale per ogni tipo tariffa e per ogni anno. 
Selezionare inoltre l'incasso totale complessivo, l'incasso totale per ogni tipo 
di tariffa indifferentemente dall’anno, e l'incasso totale per ogni anno  indif-
ferentemente dal tipo di tariffa.
------------------------------------------------------------------------------*/
SELECT tipo_tariffa, anno, SUM(Prezzo) AS Incasso_Totale 
FROM Tariffe T
INNER JOIN Fatti F ON T.id_tar = F.id_tar
INNER JOIN Tempo T ON T.id_tempo = F.id_tempo
GROUP BY CUBE (tipo_tariffa, anno)
ORDER BY tipo_tariffa, anno
