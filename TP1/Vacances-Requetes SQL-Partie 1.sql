/**********************************************************************
 --------------- TP1 - Partie #1 - Gabriel Bertrand -------------------
**********************************************************************/

/***********************************************************************
Question 1 - 6 points
• Produire la liste des tarifs des nuitées pour le type de logement D2.
• Pour chaque prix, indiquer dans l’ordre :
 - Le code du type de logement,
 - La description du type de logement,
 - Le numéro de la catégorie du village,
 - La description de la catégorie du village,
 - Le prix/nuit/personne en $ canadiens (format affichage : 50.00 $Can).
• Trier par catégorie de village.
***********************************************************************/

SELECT
	T_LOG.CODE_TYPE_LOGEMENT,
	T_LOG.DESCRIPTION,
	C_VIL.NO_CATEGORIE,
	C_VIL.DESCRIPTION,
	CAST(TAR.TARIF_UNITAIRE AS VARCHAR(10)) + ' $Can' AS TARIF_UNITAIRE
FROM
	TYPE_LOGEMENT T_LOG
		INNER JOIN TARIF_NUITEE TAR
			ON TAR.ID_TYPE_LOGEMENT = T_LOG.ID_TYPE_LOGEMENT
		INNER JOIN CATEGORIE_VILLAGE C_VIL
			ON C_VIL.ID_CATEGORIE_VILLAGE = TAR.ID_CATEGORIE_VILLAGE
WHERE 
	T_LOG.CODE_TYPE_LOGEMENT = 'D2'
ORDER BY 
	TAR.ID_CATEGORIE_VILLAGE
	
/*
CODE_TYPE_LOGEMENT DESCRIPTION                         NO_CATEGORIE DESCRIPTION                                        TARIF_UNITAIRE
------------------ ----------------------------------- ------------ -------------------------------------------------- -------------------------------------------------------
D2                 Chalet 4 personnes                  1            tennis, piscine, mini-golf, golf, sauna, garderie  50.00 $Can
D2                 Chalet 4 personnes                  2            tennis, piscine, golf, sauna                       40.00 $Can
D2                 Chalet 4 personnes                  3            tennis, piscine, garderie                          35.00 $Can

(3 rows affected)
*/

/***********************************************************************
Question 2 - 8 points
• Calculer le tarif moyen des nuitées pour chaque catégorie de village.
• Pour chaque catégorie de village, indiquer dans l’ordre :
 - Le numéro de la catégorie du village,
 - La description de la catégorie du village,
 - Le prix moyen par personne et par nuit des logements (format affichage : 43.64 $Can).
• Trier par catégorie de village.
***********************************************************************/

SELECT
	C_VIL.NO_CATEGORIE,
	C_VIL.DESCRIPTION,
	CAST(CAST(AVG(TAR.TARIF_UNITAIRE) AS DECIMAL (10, 2)) AS VARCHAR(10)) + ' $Can' AS TARIF_UNITAIRE_MOYEN
FROM
	CATEGORIE_VILLAGE C_VIL
		INNER JOIN TARIF_NUITEE TAR
			ON TAR.ID_CATEGORIE_VILLAGE = C_VIL.ID_CATEGORIE_VILLAGE
GROUP BY 
	C_VIL.NO_CATEGORIE, C_VIL.DESCRIPTION
ORDER BY 
	C_VIL.NO_CATEGORIE
	
/*
NO_CATEGORIE DESCRIPTION                                        TARIF_UNITAIRE_MOYEN
------------ -------------------------------------------------- --------------------
1            tennis, piscine, mini-golf, golf, sauna, garderie  57.27 $Can
2            tennis, piscine, golf, sauna                       48.64 $Can
3            tennis, piscine, garderie                          43.64 $Can

(3 rows affected)
*/

/***********************************************************************
Question 3 - 6 points
• Produire le calendrier d’occupation du logement 108 du village Casa-Dali pour le mois de mars
2022.
• Indiquer dans l’ordre :
 - Le numéro du logement,
 - Le nom du village,
 - Le nom du pays,
 - Le code du type de logement,
 - La description du type de logement,
 - L’identifiant de la réservation,
 - La date du séjour (de la nuit occupée) (format affichage : aaaa-mm-jj).
• Trier par date.
***********************************************************************/

SELECT
	LOG.NO_LOGEMENT,
	VIL.NOM_VILLAGE,
	VIL.PAYS,
	T_LOG.CODE_TYPE_LOGEMENT,
	T_LOG.DESCRIPTION,
	SEJ.ID_RESERVATION,
	CAST(SEJ.DATE_SEJOUR AS DATE) AS DATE_SEJOUR
FROM
	LOGEMENT LOG
		INNER JOIN TYPE_LOGEMENT T_LOG
			ON T_LOG.ID_TYPE_LOGEMENT = LOG.ID_TYPE_LOGEMENT
		INNER JOIN VILLAGE VIL
			ON VIL.ID_VILLAGE = LOG.ID_VILLAGE
		INNER JOIN SEJOUR SEJ
			ON SEJ.ID_LOGEMENT = LOG.ID_LOGEMENT
WHERE 
	LOG.NO_LOGEMENT =  '108' 
	AND VIL.NOM_VILLAGE = 'Casa-Dali'
	AND MONTH(SEJ.DATE_SEJOUR) = 3
	AND YEAR(SEJ.DATE_SEJOUR) = 2022
ORDER BY 
	SEJ.DATE_SEJOUR
	
/*
NO_LOGEMENT NOM_VILLAGE     PAYS       CODE_TYPE_LOGEMENT DESCRIPTION                         ID_RESERVATION                          DATE_SEJOUR
----------- --------------- ---------- ------------------ ----------------------------------- --------------------------------------- -----------
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1002                                    2022-03-09
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1002                                    2022-03-10
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1002                                    2022-03-11
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1002                                    2022-03-12
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1000                                    2022-03-15
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1000                                    2022-03-16
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1000                                    2022-03-17
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1000                                    2022-03-18
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1000                                    2022-03-19
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1004                                    2022-03-20
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1004                                    2022-03-21
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1004                                    2022-03-22
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1004                                    2022-03-23
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1004                                    2022-03-24
108         Casa-Dali       Espagne    D2                 Chalet 4 personnes                  1004                                    2022-03-25

(15 rows affected)
*/

/***********************************************************************
Question 4 - 8 points
• Pour les clients ayant plus d’une réservation, indiquer le village, la date d’arrivée et le nombre de
jours de chaque réservation.
• Indiquer dans l’ordre :
 - Les nom et prénom du client,
 - L’identifiant de la réservation,
 - La date d’arrivée au village (format aaaa-mm-jj),
 - Le nom du village vacances,
 - La durée en nombre de jours des vacances.
• Trier par nom et prénom du client, puis date d’arrivée au village vacances de la réservation.
***********************************************************************/

SELECT 
	CLI.NOM,
	CLI.PRENOM,
	RES.ID_RESERVATION,
	CAST(MIN(SEJ.DATE_SEJOUR) AS DATE) AS  DATE_ARRIVE,
	VIL.NOM_VILLAGE,
	COUNT(SEJ.DATE_SEJOUR) AS NB_JOUR_SEJOUR
FROM 
	RESERVATION RES
		INNER JOIN CLIENT CLI
			ON CLI.ID_CLIENT = RES.ID_CLIENT
		INNER JOIN VILLAGE VIL
			ON VIL.ID_VILLAGE = RES.ID_VILLAGE
		INNER JOIN SEJOUR SEJ
			ON SEJ.ID_RESERVATION = RES.ID_RESERVATION
WHERE 
	RES.ID_CLIENT IN (	SELECT 
						CLI.ID_CLIENT
					FROM
						CLIENT CLI
							INNER JOIN RESERVATION RES
								ON RES.ID_CLIENT = CLI.ID_CLIENT
					GROUP BY
						CLI.ID_CLIENT
					HAVING
						COUNT(ID_RESERVATION) > 1)
GROUP BY
	CLI.NOM, CLI.PRENOM, RES.ID_RESERVATION, VIL.NOM_VILLAGE
ORDER BY 
	CLI.NOM,
	CLI.PRENOM,
	MIN(SEJ.DATE_SEJOUR)
	
/*
NOM                       PRENOM                    ID_RESERVATION                          DATE_ARRIVE NOM_VILLAGE     NB_JOUR_SEJOUR
------------------------- ------------------------- --------------------------------------- ----------- --------------- --------------
Daho                      Étienne                   1011                                    2021-12-27  Porto-Nuevo     28
Daho                      Étienne                   1013                                    2022-03-07  Porto-Nuevo     3
Daho                      Étienne                   1000                                    2022-03-15  Casa-Dali       10
Fiset                     Valérie                   1005                                    2022-03-06  Casa-Dali       4
Fiset                     Valérie                   1009                                    2022-04-03  Casa-Dali       2
Fortin                    Marine                    1016                                    2022-03-17  Kouros          4
Fortin                    Marine                    1006                                    2022-03-26  Casa-Dali       16
Plante                    Josée                     1014                                    2022-03-09  Porto-Nuevo     12
Plante                    Josée                     1001                                    2022-03-13  Casa-Dali       12
St-Onge                   Éric                      1002                                    2022-03-09  Casa-Dali       4
St-Onge                   Éric                      1008                                    2022-03-31  Casa-Dali       6

(11 rows affected)
*/