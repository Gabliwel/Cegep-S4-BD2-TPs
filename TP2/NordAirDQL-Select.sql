/**********************************************************************
	TP2 partie 1 - SECTION C - Gabriel Bertrand et Zachary Gingras
**********************************************************************/

/**********************************************************************
	Question C.1 - 10 points
***********************************************************************
• Produire la liste de tous les segments de vols de la compagnie NordAir au départ de la Côte-Nord 
(municipalités de Baie-Comeau, Havre Saint-Pierre et Sept-Îles) comprenant dans l'ordre:
	-Le no de vol (VOL),
	-Le nom de la ville de l'aéroport de départ (DEPART),
	-L'heure de départ, sous le format hh:mi (A)
	-Le nom de la ville de l'aéroport de destination (ARRIVEE),
	-La durée estimée d’une envolée, sous le format hh:mi (DUREE)
• Cette liste est triée par ville de départ, heure de départ puis ville de destination.
**********************************************************************/

SELECT 
	VOL.NO_VOL AS VOL, 
	A_DEPART.NOM_VILLE AS DEPART, 
	CONVERT(VARCHAR(5),HEURE_DEPART, 108) AS À ,
	A_ARRIVE.NOM_VILLE AS ARRIVE, 
	CONVERT(VARCHAR(5),
	DATEADD(minute, DUREE_VOL, 0) ,108)  AS DUREE
FROM 
	SEGMENT SEG
		INNER JOIN AEROPORT AS A_DEPART
			ON A_DEPART.ID_AEROPORT = SEG.AEROPORT_DEPART
		INNER JOIN AEROPORT AS A_ARRIVE
			ON A_ARRIVE.ID_AEROPORT = SEG.AEROPORT_DESTINATION
		INNER JOIN VOL ON
			SEG.ID_VOL = VOL.ID_VOL
WHERE 
	A_DEPART.NOM_VILLE = 'BAIE-COMEAU' OR
	A_DEPART.NOM_VILLE = 'HAVRE SAINT-PIERRE' OR
	A_DEPART.NOM_VILLE = 'SEPT-ILES'
ORDER BY 
	A_DEPART.NOM_VILLE, SEG.HEURE_DEPART, A_ARRIVE.NOM_VILLE
	
/*
VOL                                     DEPART               À     ARRIVE               DUREE
--------------------------------------- -------------------- ----- -------------------- -----
1822                                    BAIE-COMEAU          07:00 SEPT-ILES            01:00
1923                                    BAIE-COMEAU          08:30 MONT-JOLI            00:45
1922                                    BAIE-COMEAU          18:30 SEPT-ILES            01:00
1823                                    BAIE-COMEAU          20:00 MONT-JOLI            00:45
1923                                    HAVRE SAINT-PIERRE   05:30 GASPE                00:40
1823                                    HAVRE SAINT-PIERRE   17:00 GASPE                00:40
1923                                    SEPT-ILES            07:30 BAIE-COMEAU          00:55
1822                                    SEPT-ILES            08:00 GASPE                00:30
1823                                    SEPT-ILES            19:00 BAIE-COMEAU          00:55
1922                                    SEPT-ILES            19:30 GASPE                00:30

(10 rows affected)
*/

/**********************************************************************
	Question C.2 - 10 points
***********************************************************************
• Produire la liste des vols prévus pour la période du 13 au 19 mai 2022. Pour chacun, indiquer dans l'ordre:
	-La date du vol, sous le format YYYY-MM-DD (DATE),
	-Le numéro du vol (VOL),
	-Le nombre de sièges encore disponibles (non réservés) pour l'ensemble du vol 
	(sur tous les segments, du départ initial à la destination finale du vol) (DISPONIBLES).
• Cette liste est triée par date puis par vol.
**********************************************************************/
SELECT 
	ENV.DATE_ENVOLEE,
	VOL.NO_VOL,
	MIN(VS.NOMBRE_PLACES_RESTANTES) AS DISPONIBLE
FROM 
	VOL
		INNER JOIN SEGMENT SEG
			ON VOL.ID_VOL = SEG.ID_VOL
		INNER JOIN ENVOLEE ENV
			ON SEG.ID_SEGMENT = ENV.ID_SEGMENT
		INNER JOIN V_SIEGES VS
			ON ENV.ID_ENVOLEE = VS.ID_ENVOLEE
WHERE 
	ENV.DATE_ENVOLEE >= '2022-05-13' AND ENV.DATE_ENVOLEE <= '2022-05-19'
GROUP BY 
	VOL.NO_VOL, ENV.DATE_ENVOLEE
ORDER BY 
	ENV.DATE_ENVOLEE, VOL.NO_VOL
	
/*
DATE_ENVOLEE            NO_VOL                                  DISPONIBLE
----------------------- --------------------------------------- ---------------------------------------
2022-05-13 00:00:00.000 1822                                    44
2022-05-13 00:00:00.000 1823                                    47
2022-05-13 00:00:00.000 1922                                    31
2022-05-13 00:00:00.000 1923                                    25
2022-05-14 00:00:00.000 1822                                    47
2022-05-14 00:00:00.000 1923                                    31
2022-05-15 00:00:00.000 1822                                    47
2022-05-15 00:00:00.000 1922                                    30
2022-05-16 00:00:00.000 1822                                    44
2022-05-16 00:00:00.000 1823                                    46
2022-05-16 00:00:00.000 1922                                    31
2022-05-16 00:00:00.000 1923                                    29
2022-05-17 00:00:00.000 1822                                    31
2022-05-17 00:00:00.000 1923                                    31
2022-05-18 00:00:00.000 1822                                    29
2022-05-18 00:00:00.000 1823                                    47
2022-05-18 00:00:00.000 1922                                    46
2022-05-19 00:00:00.000 1822                                    31
2022-05-19 00:00:00.000 1823                                    47
2022-05-19 00:00:00.000 1923                                    28

(20 rows affected)
*/


/**********************************************************************
	Question C.3 - 10 points
***********************************************************************
• Produire la liste des passagers pour les vols de la période du 13 au 19 mai 2022. 
Cette liste comporte les informations suivantes dans l'ordre:
	-La date du vol, sous le format YYYY-MM-DD (DEPART),
	-L’heure de départ, sous sous le format hh:mi (A),
	-Le numéro du vol (VOL),
	-Le nom, le prénom et l’identifiant du passager (PASSAGER),
	-Le nom de la ville de l'aéroport initial de départ du passager (DE)
	-Le nom de la ville de l'aéroport d’arrivée pour la destination finale du passager (A).
• Cette liste est triée par date des envolées, puis par vol, par segment initial (ordre du segment) et 
par segment d’arrivée (ordre du segment), et finalement par nom, prénom et id des passagers.
**********************************************************************/

SELECT 
	CONVERT(varchar, L_VOL.DATE, 23) AS DEPART,
	FORMAT(CAST(SEG1.HEURE_DEPART AS DATETIME),'HH:mm') AS A,
	L_VOL.ID_VOL AS VOL,
	L_VOL.NOM + ', ' + L_VOL.PRENOM + ' (' + CAST(L_VOL.ID_PASSAGER AS varchar) + ')' AS PASSAGER,
	AER1.NOM_VILLE AS DE,
	AER2.NOM_VILLE AS A
FROM 
	V_LISTE_VOL L_VOL
		INNER JOIN SEGMENT SEG1
			ON SEG1.ID_VOL = L_VOL.ID_VOL
			AND SEG1.ORDRE_SEGMENT = L_VOL.SEGMENT_DEPART
		INNER JOIN AEROPORT AER1
			ON SEG1.AEROPORT_DEPART = AER1.ID_AEROPORT
		INNER JOIN SEGMENT SEG2
			ON SEG2.ID_VOL = L_VOL.ID_VOL
			AND SEG2.ORDRE_SEGMENT = L_VOL.SEGMENT_ARRIVEE
		INNER JOIN AEROPORT AER2
			ON SEG2.AEROPORT_DESTINATION = AER2.ID_AEROPORT
ORDER BY
	L_VOL.DATE, 
	L_VOL.ID_VOL,
	L_VOL.SEGMENT_DEPART, 
	L_VOL.SEGMENT_ARRIVEE, 
	L_VOL.NOM, 
	L_VOL.PRENOM, 
	L_VOL.ID_PASSAGER
	
/*
DEPART                         A                                                                                                                                                                                                                                                                VOL                                     PASSAGER                                                          DE                   A
------------------------------ ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- --------------------------------------- ----------------------------------------------------------------- -------------------- --------------------
2022-05-13                     06:00                                                                                                                                                                                                                                                            1                                       Barbeau, Isabelle (1)                                             MONT-JOLI            BAIE-COMEAU
2022-05-13                     06:00                                                                                                                                                                                                                                                            1                                       Berthiaume, Jonny (2)                                             MONT-JOLI            BAIE-COMEAU
2022-05-13                     06:00                                                                                                                                                                                                                                                            1                                       BrindAmour, Jean-Francois (4)                                     MONT-JOLI            BAIE-COMEAU
2022-05-13                     06:00                                                                                                                                                                                                                                                            1                                       Desjardins, Francois (5)                                          MONT-JOLI            HAVRE SAINT-PIERRE
2022-05-13                     07:00                                                                                                                                                                                                                                                            1                                       Bolduc, Sebastien (3)                                             BAIE-COMEAU          SEPT-ILES
2022-05-13                     07:00                                                                                                                                                                                                                                                            1                                       Mercier, David (16)                                               BAIE-COMEAU          SEPT-ILES
2022-05-13                     20:00                                                                                                                                                                                                                                                            2                                       Berthiaume, Jonny (2)                                             BAIE-COMEAU          MONT-JOLI
2022-05-13                     20:30                                                                                                                                                                                                                                                            3                                       Nadeau, Michel (14)                                               GASPE                HAVRE SAINT-PIERRE
2022-05-13                     05:30                                                                                                                                                                                                                                                            4                                       Fortin, Mathieu (9)                                               HAVRE SAINT-PIERRE   SEPT-ILES
2022-05-13                     05:30                                                                                                                                                                                                                                                            4                                       Ouellet, Remi (32)                                                HAVRE SAINT-PIERRE   SEPT-ILES
2022-05-13                     05:30                                                                                                                                                                                                                                                            4                                       Gregoire, Pierre-Luc (12)                                         HAVRE SAINT-PIERRE   BAIE-COMEAU
2022-05-13                     05:30                                                                                                                                                                                                                                                            4                                       Lapointe-Girard, etienne (29)                                     HAVRE SAINT-PIERRE   BAIE-COMEAU
2022-05-13                     05:30                                                                                                                                                                                                                                                            4                                       Ouellette, Pierre (33)                                            HAVRE SAINT-PIERRE   BAIE-COMEAU
2022-05-13                     05:30                                                                                                                                                                                                                                                            4                                       Talbot, Remi (36)                                                 HAVRE SAINT-PIERRE   MONT-JOLI
2022-05-13                     05:30                                                                                                                                                                                                                                                            4                                       Tremblay, Sebastien (35)                                          HAVRE SAINT-PIERRE   MONT-JOLI
2022-05-13                     07:30                                                                                                                                                                                                                                                            4                                       Poussier, Genevieve (20)                                          SEPT-ILES            BAIE-COMEAU
2022-05-13                     07:30                                                                                                                                                                                                                                                            4                                       Tremblay, Vincent (15)                                            SEPT-ILES            BAIE-COMEAU
2022-05-14                     09:00                                                                                                                                                                                                                                                            1                                       Harnois, Stephane J. (8)                                          GASPE                HAVRE SAINT-PIERRE
2022-05-14                     06:30                                                                                                                                                                                                                                                            4                                       BrindAmour, Jean-Francois (4)                                     GASPE                SEPT-ILES
2022-05-15                     08:00                                                                                                                                                                                                                                                            1                                       Rouillard, Guy (37)                                               SEPT-ILES            GASPE
2022-05-15                     19:30                                                                                                                                                                                                                                                            3                                       Fortin, Mathieu (9)                                               SEPT-ILES            HAVRE SAINT-PIERRE
2022-05-15                     20:30                                                                                                                                                                                                                                                            3                                       Cote, Mathieu (6)                                                 GASPE                HAVRE SAINT-PIERRE
2022-05-16                     06:00                                                                                                                                                                                                                                                            1                                       Duval, Philippe (18)                                              MONT-JOLI            BAIE-COMEAU
2022-05-16                     06:00                                                                                                                                                                                                                                                            1                                       Lapierre, Guillaume (19)                                          MONT-JOLI            BAIE-COMEAU
2022-05-16                     06:00                                                                                                                                                                                                                                                            1                                       Mallet, Sylvain (21)                                              MONT-JOLI            BAIE-COMEAU
2022-05-16                     06:00                                                                                                                                                                                                                                                            1                                       Saucier, Jean-Francois (22)                                       MONT-JOLI            HAVRE SAINT-PIERRE
2022-05-16                     07:00                                                                                                                                                                                                                                                            1                                       Poussier, Genevieve (20)                                          BAIE-COMEAU          SEPT-ILES
2022-05-16                     09:00                                                                                                                                                                                                                                                            1                                       Fortin, Jean-Philippe (7)                                         GASPE                HAVRE SAINT-PIERRE
2022-05-16                     18:00                                                                                                                                                                                                                                                            2                                       Jobin, Samuel (10)                                                GASPE                SEPT-ILES
2022-05-16                     18:00                                                                                                                                                                                                                                                            2                                       Rouillard, Guy (37)                                               GASPE                SEPT-ILES
2022-05-16                     20:00                                                                                                                                                                                                                                                            2                                       Lapierre, Guillaume (19)                                          BAIE-COMEAU          MONT-JOLI
2022-05-16                     20:30                                                                                                                                                                                                                                                            3                                       Aubert, Vincent (31)                                              GASPE                HAVRE SAINT-PIERRE
2022-05-16                     05:30                                                                                                                                                                                                                                                            4                                       Fortin, Jean-Philippe (7)                                         HAVRE SAINT-PIERRE   GASPE
2022-05-16                     05:30                                                                                                                                                                                                                                                            4                                       Fortin, Mathieu (9)                                               HAVRE SAINT-PIERRE   GASPE
2022-05-16                     05:30                                                                                                                                                                                                                                                            4                                       Desjardins, Francois (5)                                          HAVRE SAINT-PIERRE   BAIE-COMEAU
2022-05-17                     09:00                                                                                                                                                                                                                                                            1                                       Aspiros, Charles (25)                                             GASPE                HAVRE SAINT-PIERRE
2022-05-17                     05:30                                                                                                                                                                                                                                                            4                                       Ratte, Francois (11)                                              HAVRE SAINT-PIERRE   GASPE
2022-05-17                     06:30                                                                                                                                                                                                                                                            4                                       Mallet, Sylvain (21)                                              GASPE                SEPT-ILES
2022-05-17                     07:30                                                                                                                                                                                                                                                            4                                       Ouellet, Remi (32)                                                SEPT-ILES            BAIE-COMEAU
2022-05-17                     08:30                                                                                                                                                                                                                                                            4                                       Desjardins, Francois (5)                                          BAIE-COMEAU          MONT-JOLI
2022-05-18                     06:00                                                                                                                                                                                                                                                            1                                       Rouillard, Guy (37)                                               MONT-JOLI            BAIE-COMEAU
2022-05-18                     06:00                                                                                                                                                                                                                                                            1                                       Talbot, Remi (36)                                                 MONT-JOLI            BAIE-COMEAU
2022-05-18                     06:00                                                                                                                                                                                                                                                            1                                       Tremblay, Sebastien (35)                                          MONT-JOLI            BAIE-COMEAU
2022-05-18                     07:00                                                                                                                                                                                                                                                            1                                       Gregoire, Pierre-Luc (12)                                         BAIE-COMEAU          SEPT-ILES
2022-05-18                     07:00                                                                                                                                                                                                                                                            1                                       Lapointe-Girard, etienne (29)                                     BAIE-COMEAU          SEPT-ILES
2022-05-18                     07:00                                                                                                                                                                                                                                                            1                                       Ouellette, Pierre (33)                                            BAIE-COMEAU          SEPT-ILES
2022-05-18                     09:00                                                                                                                                                                                                                                                            1                                       Lagace, Mathieu (23)                                              GASPE                HAVRE SAINT-PIERRE
2022-05-18                     09:00                                                                                                                                                                                                                                                            1                                       Ratte, Francois (11)                                              GASPE                HAVRE SAINT-PIERRE
2022-05-18                     19:00                                                                                                                                                                                                                                                            2                                       Dostie-Proulx, Pierre-Luc (13)                                    SEPT-ILES            BAIE-COMEAU
2022-05-18                     17:30                                                                                                                                                                                                                                                            3                                       Dionne, Marjorie (17)                                             MONT-JOLI            BAIE-COMEAU
2022-05-18                     17:30                                                                                                                                                                                                                                                            3                                       Pelletier, Nathalie (34)                                          MONT-JOLI            BAIE-COMEAU
2022-05-18                     19:30                                                                                                                                                                                                                                                            3                                       Picard, Maxime (26)                                               SEPT-ILES            HAVRE SAINT-PIERRE
2022-05-19                     09:00                                                                                                                                                                                                                                                            1                                       Blanchette, Marc (24)                                             GASPE                HAVRE SAINT-PIERRE
2022-05-19                     18:00                                                                                                                                                                                                                                                            2                                       Richard, Jean-Francois (27)                                       GASPE                SEPT-ILES
2022-05-19                     19:00                                                                                                                                                                                                                                                            2                                       Mercier, Nicolas (30)                                             SEPT-ILES            BAIE-COMEAU
2022-05-19                     05:30                                                                                                                                                                                                                                                            4                                       Blanchette, Marc (24)                                             HAVRE SAINT-PIERRE   GASPE
2022-05-19                     05:30                                                                                                                                                                                                                                                            4                                       Dube, Jason (28)                                                  HAVRE SAINT-PIERRE   GASPE
2022-05-19                     05:30                                                                                                                                                                                                                                                            4                                       Picard, Maxime (26)                                               HAVRE SAINT-PIERRE   GASPE
2022-05-19                     05:30                                                                                                                                                                                                                                                            4                                       Saucier, Jean-Francois (22)                                       HAVRE SAINT-PIERRE   BAIE-COMEAU
2022-05-20                     07:00                                                                                                                                                                                                                                                            1                                       Rouillard, Guy (37)                                               BAIE-COMEAU          SEPT-ILES
2022-05-20                     07:00                                                                                                                                                                                                                                                            1                                       Talbot, Remi (36)                                                 BAIE-COMEAU          SEPT-ILES
2022-05-20                     07:00                                                                                                                                                                                                                                                            1                                       Tremblay, Sebastien (35)                                          BAIE-COMEAU          SEPT-ILES
2022-05-20                     09:00                                                                                                                                                                                                                                                            1                                       Dube, Jason (28)                                                  GASPE                HAVRE SAINT-PIERRE
2022-05-20                     18:30                                                                                                                                                                                                                                                            3                                       Dionne, Marjorie (17)                                             BAIE-COMEAU          SEPT-ILES
2022-05-20                     18:30                                                                                                                                                                                                                                                            3                                       Pelletier, Nathalie (34)                                          BAIE-COMEAU          SEPT-ILES
2022-05-20                     07:30                                                                                                                                                                                                                                                            4                                       Mercier, David (16)                                               SEPT-ILES            BAIE-COMEAU
2022-05-20                     07:30                                                                                                                                                                                                                                                            4                                       Ouellette, Pierre (33)                                            SEPT-ILES            BAIE-COMEAU
2022-05-20                     08:30                                                                                                                                                                                                                                                            4                                       Saucier, Jean-Francois (22)                                       BAIE-COMEAU          MONT-JOLI

(68 rows affected)

*/









