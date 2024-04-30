/**********************************************************************
 --------------- TP1 - Partie #2 - Gabriel Bertrand -------------------
**********************************************************************/

/**********************************************************************
Question 5 - 16 points
• Produire la liste des types de logement :
• Pour chaque type de logement, indiquer dans l’ordre :
	-Le code du type de logement,
	-La description du type de logement;
	-Le nombre de logements proposés dans le village Casa-Dali pour ce type de logement.
• Trier par code de type de logement.
A) Écrire la requête sans utiliser de sous-requête. (8 pts)
B) Écrire la requête en utilisant une sous-requête corrélée mais sans l’opérateur EXIST ou NOT EXIST. (8 pts)
**********************************************************************/
/*A*/
SELECT
	T_LOGE.CODE_TYPE_LOGEMENT,
	T_LOGE.DESCRIPTION,
	COUNT(LOGE.ID_LOGEMENT) AS NB_LOGEMENT
FROM 
	VILLAGE VIL
		INNER JOIN LOGEMENT LOGE
			ON LOGE.ID_VILLAGE = VIL.ID_VILLAGE
		INNER JOIN TYPE_LOGEMENT T_LOGE
			ON  LOGE.ID_TYPE_LOGEMENT = T_LOGE.ID_TYPE_LOGEMENT
WHERE
	VIL.NOM_VILLAGE = 'Casa-Dali'
GROUP BY 
	T_LOGE.CODE_TYPE_LOGEMENT, T_LOGE.DESCRIPTION
ORDER BY
	T_LOGE.CODE_TYPE_LOGEMENT
/*
CODE_TYPE_LOGEMENT DESCRIPTION                         NB_LOGEMENT
------------------ ----------------------------------- -----------
B2                 Suite 2 personnes                   5
C2                 Bungalow 2 personnes                3
D1                 Chalet 6 personnes                  2
D2                 Chalet 4 personnes                  5

(4 rows affected)
*/
/*B*/
SELECT
	(SELECT CODE_TYPE_LOGEMENT FROM TYPE_LOGEMENT T_LOGE WHERE LOGE.ID_TYPE_LOGEMENT = T_LOGE.ID_TYPE_LOGEMENT) AS CODE_TYPE_LOGEMENT,
	(SELECT DESCRIPTION FROM TYPE_LOGEMENT T_LOGE WHERE LOGE.ID_TYPE_LOGEMENT = T_LOGE.ID_TYPE_LOGEMENT) AS DESCRIPTION,
	COUNT(LOGE.ID_LOGEMENT) AS NB_LOGEMENT
FROM 
	VILLAGE VIL
		INNER JOIN LOGEMENT LOGE
			ON LOGE.ID_VILLAGE = VIL.ID_VILLAGE
WHERE
	VIL.NOM_VILLAGE = 'Casa-Dali'
GROUP BY 
	LOGE.ID_TYPE_LOGEMENT
ORDER BY
	(SELECT CODE_TYPE_LOGEMENT FROM TYPE_LOGEMENT T_LOGE WHERE LOGE.ID_TYPE_LOGEMENT = T_LOGE.ID_TYPE_LOGEMENT)
/*
CODE_TYPE_LOGEMENT DESCRIPTION                         NB_LOGEMENT
------------------ ----------------------------------- -----------
B2                 Suite 2 personnes                   5
C2                 Bungalow 2 personnes                3
D1                 Chalet 6 personnes                  2
D2                 Chalet 4 personnes                  5

(4 rows affected)
*/

/**********************************************************************
Question 6 - 16 points
• Produire la liste des logements du village Casa-Dali disponibles pour toute la période du 20 au 24 mars 2022 inclusivement.
• Pour chaque logement disponible, indiquer dans l’ordre :
	-Le numéro du logement,
	-Le code du type de logement,
	-La description du type de logement.
• Trier par logement.
A) Écrire la requête en utilisant l’opérateur IN ou NOT IN. (8 pts)
B) Écrire la requête en utilisant l’opérateur EXIST ou NOT EXIST. (8 pts)
**********************************************************************/
/*A*/
SELECT
	LOGE.NO_LOGEMENT,
	T_LOGE.CODE_TYPE_LOGEMENT,
	T_LOGE.DESCRIPTION
FROM LOGEMENT LOGE
	INNER JOIN VILLAGE 
		 ON LOGE.ID_VILLAGE = VILLAGE.ID_VILLAGE
		 AND VILLAGE.NOM_VILLAGE = 'Casa-Dali'
	INNER JOIN TYPE_LOGEMENT T_LOGE
			ON  LOGE.ID_TYPE_LOGEMENT = T_LOGE.ID_TYPE_LOGEMENT
WHERE 
	LOGE.ID_LOGEMENT NOT IN (	SELECT 
										SEJ.ID_LOGEMENT
								FROM 
										SEJOUR SEJ
								WHERE
										DATE_SEJOUR >= '2022-03-20' AND DATE_SEJOUR <= '2022-03-24'
							)
ORDER BY 
	LOGE.NO_LOGEMENT
	
/*
NO_LOGEMENT CODE_TYPE_LOGEMENT DESCRIPTION
----------- ------------------ -----------------------------------
8           B2                 Suite 2 personnes
11          B2                 Suite 2 personnes
18          B2                 Suite 2 personnes
19          B2                 Suite 2 personnes
105         D2                 Chalet 4 personnes
107         D2                 Chalet 4 personnes
109         D2                 Chalet 4 personnes

(7 rows affected)
*/
/*B*/
SELECT
	LOGE.NO_LOGEMENT,
	T_LOGE.CODE_TYPE_LOGEMENT,
	T_LOGE.DESCRIPTION
FROM LOGEMENT LOGE
	INNER JOIN VILLAGE 
		ON LOGE.ID_VILLAGE = VILLAGE.ID_VILLAGE
		AND VILLAGE.NOM_VILLAGE = 'Casa-Dali'
	INNER JOIN TYPE_LOGEMENT T_LOGE
		ON  LOGE.ID_TYPE_LOGEMENT = T_LOGE.ID_TYPE_LOGEMENT
WHERE 
	NOT EXISTS (	SELECT *
					FROM SEJOUR SEJ
					WHERE LOGE.ID_LOGEMENT = SEJ.ID_LOGEMENT
					AND DATE_SEJOUR >= '2022-03-20' AND DATE_SEJOUR <= '2022-03-24'
				)
ORDER BY 
	LOGE.NO_LOGEMENT
	
/*
NO_LOGEMENT CODE_TYPE_LOGEMENT DESCRIPTION
----------- ------------------ -----------------------------------
8           B2                 Suite 2 personnes
11          B2                 Suite 2 personnes
18          B2                 Suite 2 personnes
19          B2                 Suite 2 personnes
105         D2                 Chalet 4 personnes
107         D2                 Chalet 4 personnes
109         D2                 Chalet 4 personnes

(7 rows affected)
*/

/**********************************************************************
Question 7 - 14 points
• Quel ou quels sont le ou les villages avec le plus grand nombre de nuitées vendues?
• Indiquer dans l’ordre :
	-Le pays,
	-Le nom village,
	-Le nombre de nuitées.
A) Créer la vue V_NB_NUITEES qui compte pour chaque village vacances le nombre total de nuitées vendues. La vue doit contenir : (8 pts)
	-L’identifiant du village,
	-Le nom du village.
	-Le pays,
	-Le nombre total de nuitées.
Faire ensuite un SELECT pour vérifier le contenu de la vue.
B) Écrire la requête 7 en utilisant la vue V_NB_NUITEES. (6 pts)
**********************************************************************/
/*A*/
CREATE VIEW V_NB_NUITEES
AS 
	SELECT
		VIL.ID_VILLAGE,
		VIL.NOM_VILLAGE,
		VIL.PAYS,
		COUNT(SEJ.DATE_SEJOUR) AS NB_NUITEES
	FROM
		VILLAGE VIL
			LEFT JOIN RESERVATION RES
				ON RES.ID_VILLAGE = VIL.ID_VILLAGE
			LEFT JOIN SEJOUR SEJ
				ON SEJ.ID_RESERVATION = RES.ID_RESERVATION
	GROUP BY
		VIL.ID_VILLAGE, VIL.NOM_VILLAGE, VIL.PAYS
GO
/*B*/
SELECT 
	PAYS,
	NOM_VILLAGE,
	NB_NUITEES
FROM 
	V_NB_NUITEES
WHERE
	NB_NUITEES >= (SELECT TOP 1 
					NB_NUITEES 
				FROM 
					V_NB_NUITEES 
				WHERE 
					NB_NUITEES IS NOT NULL
				ORDER BY 
					NB_NUITEES DESC)
/*
PAYS       NOM_VILLAGE     NB_NUITEES
---------- --------------- -----------
Espagne    Casa-Dali       154
Warning: Null value is eliminated by an aggregate or other SET operation.

(1 row affected)
*/

/**********************************************************************
Question 8 - 14 points
• Produire les confirmations pour toutes les réservations effectuées (date de réservation) entre le 12 et le 20 février 2022 inclusivement.
• Pour chaque réservation, indiquer dans l’ordre :
	-L’identifiant de la réservation,
	-L’identifiant du client,
	-Le nom du client,
	-Le prénom du client,
	-Le nom du village,
	-La date de départ de Montréal (format affichage : aaaa-mm-jj),
	-La date de retour à Montréal (format affichage : aaaa-mm-jj),
	-Le nombre de personnes concernées par la réservation.
• Trier par date de réservation, puis par identifiant de réservation.
A) Créer la vue V_RECAPITULATIF_RESERVATION qui contient toutes les réservations : (8 pts)
	-L’identifiant de la réservation,
	-La date de réservation,
	-L’identifiant du client,
	-L’identifiant du village,
	-La date de départ de Montréal,
	-La date de retour à Montréal,
	-La durée de la réservation en nombre de jours,
	-Le nombre de personnes concernées par la réservation,
	-Le nombre total de nuitées qui seront facturées.
Faire ensuite un SELECT pour vérifier le contenu de la vue.
B) Écrire la requête 8 en utilisant la vue RECAPITULATIF_RESERVATION. (6 pts)
**********************************************************************/
/*A*/
/*******************+1 POUR LE RETOUR???????????????????????????????????****************************************************************/
CREATE VIEW V_RECAPITULATIF_RESERVATION
AS 
	SELECT
		RES.ID_RESERVATION,
		RES.DATE_RESERVATION,
		RES.ID_CLIENT,
		VIL.NOM_VILLAGE,
		MIN(SEJ.DATE_SEJOUR) AS DEPART_MONTREAL,
		MAX(SEJ.DATE_SEJOUR) AS RETOUR_MONTREAL,
		COUNT(DISTINCT SEJ.DATE_SEJOUR) AS DUREE_SEJOUR,
		SUM(SEJ.NB_PERSONNES) / COUNT(DISTINCT SEJ.DATE_SEJOUR) AS NB_PERSONNE,
		COUNT(SEJ.DATE_SEJOUR) AS NB_NUITEE_FACTUREE
	FROM
		VILLAGE VIL
			INNER JOIN RESERVATION RES
				ON RES.ID_VILLAGE = VIL.ID_VILLAGE
			INNER JOIN CLIENT CLI
				ON CLI.ID_CLIENT = RES.ID_CLIENT
			INNER JOIN SEJOUR SEJ
				ON SEJ.ID_RESERVATION = RES.ID_RESERVATION
	GROUP BY 
		RES.ID_RESERVATION, RES.DATE_RESERVATION, RES.ID_CLIENT, VIL.NOM_VILLAGE
GO
/*B*/
SELECT
	VRR.ID_RESERVATION,
	VRR.ID_CLIENT,
	CLI.NOM,
	CLI.PRENOM,
	VRR.NOM_VILLAGE,
	VRR.DEPART_MONTREAL,
	VRR.RETOUR_MONTREAL,
	VRR.NB_PERSONNE
FROM
	V_RECAPITULATIF_RESERVATION VRR
		INNER JOIN CLIENT CLI
			ON VRR.ID_CLIENT = CLI.ID_CLIENT
ORDER BY 
	VRR.DATE_RESERVATION, VRR.ID_RESERVATION
	
/*
ID_RESERVATION                          ID_CLIENT                               NOM                       PRENOM                    NOM_VILLAGE     DEPART_MONTREAL         RETOUR_MONTREAL         NB_PERSONNE
--------------------------------------- --------------------------------------- ------------------------- ------------------------- --------------- ----------------------- ----------------------- -----------
1007                                    6                                       Caron                     Léo                       Casa-Dali       2022-02-26 00:00:00.000 2022-02-28 00:00:00.000 20
1011                                    1                                       Daho                      Étienne                   Porto-Nuevo     2021-12-27 00:00:00.000 2022-01-02 00:00:00.000 8
1006                                    9                                       Fortin                    Marine                    Casa-Dali       2022-03-26 00:00:00.000 2022-03-29 00:00:00.000 10
1010                                    14                                      Dallaire                  Karine                    Casa-Dali       2022-02-24 00:00:00.000 2022-04-02 00:00:00.000 2
1005                                    12                                      Fiset                     Valérie                   Casa-Dali       2022-03-06 00:00:00.000 2022-03-09 00:00:00.000 2
1009                                    12                                      Fiset                     Valérie                   Casa-Dali       2022-04-03 00:00:00.000 2022-04-04 00:00:00.000 2
1000                                    1                                       Daho                      Étienne                   Casa-Dali       2022-03-15 00:00:00.000 2022-03-19 00:00:00.000 6
1001                                    8                                       Plante                    Josée                     Casa-Dali       2022-03-13 00:00:00.000 2022-03-18 00:00:00.000 4
1002                                    7                                       St-Onge                   Éric                      Casa-Dali       2022-03-09 00:00:00.000 2022-03-12 00:00:00.000 3
1012                                    3                                       Gosselin                  Yvonne                    Porto-Nuevo     2023-03-02 00:00:00.000 2023-03-06 00:00:00.000 8
1004                                    5                                       Paré                      Marine                    Casa-Dali       2022-03-20 00:00:00.000 2022-03-25 00:00:00.000 9
1008                                    7                                       St-Onge                   Éric                      Casa-Dali       2022-03-31 00:00:00.000 2022-04-05 00:00:00.000 6
1015                                    4                                       Dupuis                    Pierre                    Porto-Nuevo     2022-03-01 00:00:00.000 2022-03-01 00:00:00.000 3
1003                                    2                                       Fiset                     Raymond                   Casa-Dali       2022-03-17 00:00:00.000 2022-03-23 00:00:00.000 15
1016                                    9                                       Fortin                    Marine                    Kouros          2022-03-17 00:00:00.000 2022-03-20 00:00:00.000 1
1017                                    13                                      Roy                       Paul                      Kouros          2022-03-18 00:00:00.000 2022-03-20 00:00:00.000 5
1013                                    1                                       Daho                      Étienne                   Porto-Nuevo     2022-03-07 00:00:00.000 2022-03-09 00:00:00.000 2
1014                                    8                                       Plante                    Josée                     Porto-Nuevo     2022-03-09 00:00:00.000 2022-03-14 00:00:00.000 4

(18 rows affected)
*/

/**********************************************************************
Question 9 - 6 points
• Augmenter de 5,5% tous les tarifs des nuitées pour les villages de catégorie 1 et 2 (numéro de catégorie).
• Faire un SELECT avant la modification et un SELECT après pour vérifier que votre requête a bien fonctionné.
**********************************************************************/
/*UPDATE*/
UPDATE TARIF_NUITEE
SET TARIF_UNITAIRE = TARIF_UNITAIRE * 1.055
FROM 
	CATEGORIE_VILLAGE C_VIL
		INNER JOIN TARIF_NUITEE T_NUI
			ON T_NUI.ID_CATEGORIE_VILLAGE = C_VIL.ID_CATEGORIE_VILLAGE
WHERE
	C_VIL.NO_CATEGORIE = 1 OR C_VIL.NO_CATEGORIE = 2

/*SELECT*/
SELECT 
	*
FROM 
	CATEGORIE_VILLAGE C_VIL
		INNER JOIN TARIF_NUITEE T_NUI
			ON T_NUI.ID_CATEGORIE_VILLAGE = C_VIL.ID_CATEGORIE_VILLAGE
WHERE
	C_VIL.NO_CATEGORIE = 1 OR C_VIL.NO_CATEGORIE = 2
	
/*AVANT*/
/*
ID_CATEGORIE_VILLAGE                    NO_CATEGORIE DESCRIPTION                                        ID_CATEGORIE_VILLAGE                    ID_TYPE_LOGEMENT                        TARIF_UNITAIRE
--------------------------------------- ------------ -------------------------------------------------- --------------------------------------- --------------------------------------- ---------------------------------------
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       1                                       45.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       2                                       50.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       3                                       60.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       4                                       70.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       5                                       75.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       6                                       85.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       7                                       40.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       8                                       35.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       9                                       40.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       10                                      50.00
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       11                                      80.00
2                                       2            tennis, piscine, golf, sauna                       2                                       1                                       40.00
2                                       2            tennis, piscine, golf, sauna                       2                                       2                                       45.00
2                                       2            tennis, piscine, golf, sauna                       2                                       3                                       50.00
2                                       2            tennis, piscine, golf, sauna                       2                                       4                                       60.00
2                                       2            tennis, piscine, golf, sauna                       2                                       5                                       65.00
2                                       2            tennis, piscine, golf, sauna                       2                                       6                                       75.00
2                                       2            tennis, piscine, golf, sauna                       2                                       7                                       30.00
2                                       2            tennis, piscine, golf, sauna                       2                                       8                                       40.00
2                                       2            tennis, piscine, golf, sauna                       2                                       9                                       30.00
2                                       2            tennis, piscine, golf, sauna                       2                                       10                                      40.00
2                                       2            tennis, piscine, golf, sauna                       2                                       11                                      60.00

(22 rows affected)
*/
/*APRES*/
/*
ID_CATEGORIE_VILLAGE                    NO_CATEGORIE DESCRIPTION                                        ID_CATEGORIE_VILLAGE                    ID_TYPE_LOGEMENT                        TARIF_UNITAIRE
--------------------------------------- ------------ -------------------------------------------------- --------------------------------------- --------------------------------------- ---------------------------------------
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       1                                       47.48
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       2                                       52.75
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       3                                       63.30
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       4                                       73.85
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       5                                       79.13
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       6                                       89.68
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       7                                       42.20
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       8                                       36.93
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       9                                       42.20
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       10                                      52.75
1                                       1            tennis, piscine, mini-golf, golf, sauna, garderie  1                                       11                                      84.40
2                                       2            tennis, piscine, golf, sauna                       2                                       1                                       42.20
2                                       2            tennis, piscine, golf, sauna                       2                                       2                                       47.48
2                                       2            tennis, piscine, golf, sauna                       2                                       3                                       52.75
2                                       2            tennis, piscine, golf, sauna                       2                                       4                                       63.30
2                                       2            tennis, piscine, golf, sauna                       2                                       5                                       68.58
2                                       2            tennis, piscine, golf, sauna                       2                                       6                                       79.13
2                                       2            tennis, piscine, golf, sauna                       2                                       7                                       31.65
2                                       2            tennis, piscine, golf, sauna                       2                                       8                                       42.20
2                                       2            tennis, piscine, golf, sauna                       2                                       9                                       31.65
2                                       2            tennis, piscine, golf, sauna                       2                                       10                                      42.20
2                                       2            tennis, piscine, golf, sauna                       2                                       11                                      63.30

(22 rows affected)
*/
/**********************************************************************
Question 10 - 6 points
• Déplacer tous les séjours de 2 personnes (uniquement) des suites 11 et 19 (numéro de logement) du village Casa-Dali dans la suite 8 (numéro de logement) du village, pour la période du 1 au 15 mars 2022. On considère que la disponibilité du logement 8 est assurée.
• Faire un SELECT avant la modification et un SELECT après pour vérifier que votre requête a bien fonctionné.
**********************************************************************/
/*UPDATE*/
UPDATE SEJOUR
SET ID_LOGEMENT = (	SELECT 
						ID_LOGEMENT 
					FROM 
						LOGEMENT 
							INNER JOIN VILLAGE 
								ON LOGEMENT.ID_VILLAGE = VILLAGE.ID_VILLAGE
					WHERE 
						NO_LOGEMENT = 8 AND NOM_VILLAGE = 'Casa-Dali')
FROM 
	SEJOUR SEJ
WHERE
	SEJ.ID_LOGEMENT IN (SELECT 
							LOGE.ID_LOGEMENT
						FROM 
							VILLAGE VIL
								INNER JOIN LOGEMENT LOGE
									ON LOGE.ID_VILLAGE = VIL.ID_VILLAGE
						WHERE
							VIL.NOM_VILLAGE = 'Casa-Dali' AND (LOGE.NO_LOGEMENT = 11 OR LOGE.NO_LOGEMENT = 19))
	AND SEJ.NB_PERSONNES = 2 AND SEJ.DATE_SEJOUR >= '2022-03-12' AND SEJ.DATE_SEJOUR <= '2022-03-20'

/*SELECT #1*/
SELECT 
	* 
FROM 
	SEJOUR SEJ
WHERE
	SEJ.ID_LOGEMENT IN (SELECT 
							LOGE.ID_LOGEMENT
						FROM 
							VILLAGE VIL
								INNER JOIN LOGEMENT LOGE
									ON LOGE.ID_VILLAGE = VIL.ID_VILLAGE
						WHERE
							VIL.NOM_VILLAGE = 'Casa-Dali' AND (LOGE.NO_LOGEMENT = 11 OR LOGE.NO_LOGEMENT = 19))
	AND SEJ.NB_PERSONNES = 2 AND SEJ.DATE_SEJOUR >= '2022-03-12' AND SEJ.DATE_SEJOUR <= '2022-03-20'
	
/*SELECT #2*/
SELECT 
	* 
FROM 
	SEJOUR SEJ
WHERE
	SEJ.ID_LOGEMENT IN (SELECT 
							LOGE.ID_LOGEMENT
						FROM 
							VILLAGE VIL
								INNER JOIN LOGEMENT LOGE
									ON LOGE.ID_VILLAGE = VIL.ID_VILLAGE
						WHERE
							VIL.NOM_VILLAGE = 'Casa-Dali' AND LOGE.NO_LOGEMENT = 8)
	AND SEJ.NB_PERSONNES = 2 AND SEJ.DATE_SEJOUR >= '2022-03-12' AND SEJ.DATE_SEJOUR <= '2022-03-20'
	
/*AVANT #1*/
/*ID_SEJOUR                               DATE_SEJOUR             ID_LOGEMENT                             ID_RESERVATION                          NB_PERSONNES
--------------------------------------- ----------------------- --------------------------------------- --------------------------------------- ------------
12                                      2022-03-13 00:00:00.000 5                                       1001                                    2
14                                      2022-03-14 00:00:00.000 5                                       1001                                    2
16                                      2022-03-15 00:00:00.000 5                                       1001                                    2
18                                      2022-03-16 00:00:00.000 5                                       1001                                    2
20                                      2022-03-17 00:00:00.000 5                                       1001                                    2
22                                      2022-03-18 00:00:00.000 5                                       1001                                    2

(6 rows affected)*/

/*AVANT #2*/
/*ID_SEJOUR                               DATE_SEJOUR             ID_LOGEMENT                             ID_RESERVATION                          NB_PERSONNES
--------------------------------------- ----------------------- --------------------------------------- --------------------------------------- ------------

(0 rows affected)*/

/*APRES #1*/
/*ID_SEJOUR                               DATE_SEJOUR             ID_LOGEMENT                             ID_RESERVATION                          NB_PERSONNES
--------------------------------------- ----------------------- --------------------------------------- --------------------------------------- ------------

(0 rows affected)*/

/*APRES #2*/
/*ID_SEJOUR                               DATE_SEJOUR             ID_LOGEMENT                             ID_RESERVATION                          NB_PERSONNES
--------------------------------------- ----------------------- --------------------------------------- --------------------------------------- ------------
12                                      2022-03-13 00:00:00.000 1                                       1001                                    2
14                                      2022-03-14 00:00:00.000 1                                       1001                                    2
16                                      2022-03-15 00:00:00.000 1                                       1001                                    2
18                                      2022-03-16 00:00:00.000 1                                       1001                                    2
20                                      2022-03-17 00:00:00.000 1                                       1001                                    2
22                                      2022-03-18 00:00:00.000 1                                       1001                                    2

(6 rows affected)*/
