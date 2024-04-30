USE NORDAIR
GO
	
/* Copiez et ins�rez sous proc�dures/fonctions/triggers
   les requ�tes de tests dans les scripts correspondants de T-SQL */

/* ********************************************************************************
	SCRIPT NordAir T-SQL E1 - Les fonctions
   ******************************************************************************** */
/* Ex�cutez les requ�tes de tests et inclure le r�sultat affich� lors des SELECT */

/*  Question E1-A */
/* ============== */
SELECT	dbo.MINUTES_EN_HEURES(0) AS DUREE1,
		dbo.MINUTES_EN_HEURES(30) AS DUREE2,
		dbo.MINUTES_EN_HEURES(95) AS DUREE3
/* 
DUREE1           DUREE2           DUREE3
---------------- ---------------- ----------------
00:00:00.0000000 00:30:00.0000000 01:35:00.0000000
*/

SELECT	dbo.MINUTES_EN_HEURES(119) AS DUREE4,
		dbo.MINUTES_EN_HEURES(180) AS DUREE5,
		dbo.MINUTES_EN_HEURES(181) AS DUREE6
/* 
DUREE4           DUREE5           DUREE6
---------------- ---------------- ----------------
01:59:00.0000000 03:00:00.0000000 03:01:00.0000000
*/

/*  Question E1-B */
/* ============== */
-- Test 1
SELECT dbo.MINUTES_VOL_PILOTE(34, '2022-05-13', '2022-05-20') AS NB_MINUTES_VOL
/* 
NB_MINUTES_VOL
--------------
1420
*/

-- Test 2
SELECT dbo.MINUTES_VOL_PILOTE(99, '2022-05-13', '2022-05-20') AS NB_MINUTES_VOL
/* 
NB_MINUTES_VOL
--------------
NULL
 */

-- Test 3
SELECT dbo.MINUTES_VOL_PILOTE(34, '2022-03-01', '2022-03-05') AS NB_MINUTES_VOL
/* 
NB_MINUTES_VOL
--------------
0
*/

-- Test 4
SELECT
	NO_PILOTE,
	NOM,
	PRENOM,
	LEFT(dbo.MINUTES_VOL_PILOTE(NO_PILOTE, '2022-05-15', '2022-05-17'), 5) AS NB_MINUTES_VOL
FROM
	PILOTE
/* 
NO_PILOTE                               NOM             PRENOM          NB_MINUTES_VOL
--------------------------------------- --------------- --------------- --------------
22                                      LAVIGNE         ROGER           710
34                                      LATRIMOUILLE    ANDRE           355
55                                      LAVERTU         MARIE           710
61                                      GENEST          CLAUDINE        355

(4 rows affected)
*/

/*  Question E1-C */
/* ============== */
-- Test 1
SELECT LEFT(dbo.HEURES_VOL_PILOTE(34, '2022-05-13', '2022-05-20'), 5) AS NB_HEURES_VOL
/* 
NB_HEURES_VOL
-------------
23:40

(1 row affected) 
*/

-- Test 2
SELECT LEFT(dbo.HEURES_VOL_PILOTE(99, '2022-05-13', '2022-05-20'), 5) AS NB_HEURES_VOL
/* 
NB_HEURES_VOL
-------------
NULL

(1 row affected)
*/

-- Test 3
SELECT LEFT(dbo.HEURES_VOL_PILOTE(34, '2022-03-01', '2022-03-05'), 5) AS NB_HEURES_VOL
/* 
NB_HEURES_VOL
-------------
00:00

(1 row affected)
*/

-- Test 4
SELECT
	NO_PILOTE,
	NOM,
	PRENOM,
	LEFT(dbo.HEURES_VOL_PILOTE(NO_PILOTE, '2022-05-15', '2022-05-17'), 5) AS NB_HEURES_VOL
FROM
	PILOTE
/*
NO_PILOTE                               NOM             PRENOM          NB_HEURES_VOL
--------------------------------------- --------------- --------------- -------------
22                                      LAVIGNE         ROGER           11:50
34                                      LATRIMOUILLE    ANDRE           05:55
55                                      LAVERTU         MARIE           11:50
61                                      GENEST          CLAUDINE        05:55

(4 rows affected)
*/

/* ********************************************************************************
	SCRIPT NordAir T-SQL E2 - Le trigger
   ******************************************************************************** */
/* Pour chaque cas de test, inclure seulement le r�sultat des 3 derniers SELECT apr�s l'ordre UPDATE
   Les 2 premiers SELECT de chaque test sont pr�sents pour vous aider � faire votre assurance qualit� */

BEGIN TRANSACTION

-- Test 1
SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5)

UPDATE	RESERVATION
SET		ANNULEE = 'true'
WHERE	ID_RESERVATION = 5

SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5)
SELECT
	ID_RESERVATION,
	CONVERT(DATE, DATE_RESERVATION) AS DATE_RESERVATION,
	CONVERT(DATE, DATE_ANNULATION)  AS  DATE_ANNULATION,
	ANNULEE_PAR_USER,
	ID_PASSAGER,
	LISTE_ENVOLEES
FROM AUDIT_ANNULATION_RESERVATION
/* R�sultat des 3 derniers SELECT ici */
/*
ID_RESERVATION                          DATE_RESERVATION        ID_PASSAGER                             ANNULEE
--------------------------------------- ----------------------- --------------------------------------- -------
1                                       2022-04-13 00:00:00.000 1                                       0
2                                       2022-04-18 00:00:00.000 2                                       0
5                                       2022-04-20 00:00:00.000 5                                       1

(3 rows affected)

ID_RESERV_ENVOLEE                       ID_RESERVATION                          ID_ENVOLEE                              CODE_SIEGE
--------------------------------------- --------------------------------------- --------------------------------------- ----------
1                                       1                                       1                                       01A
2                                       2                                       1                                       02B
3                                       2                                       8                                       03C

(3 rows affected)

ID_RESERVATION DATE_RESERVATION DATE_ANNULATION ANNULEE_PAR_USER      ID_PASSAGER LISTE_ENVOLEES
-------------- ---------------- --------------- --------------------- ----------- ----------------------------------------------------------------------------------------------------
5              2022-04-20       2022-04-25      LAPTOP-S98H0U7A\zacky 5            - 7 - 8 - 9 - 10 - 11 - 12 - 13 - 14

(1 row affected)
*/
-- Test 2
SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5)

UPDATE	RESERVATION
SET		ANNULEE = 'true'
WHERE	ID_RESERVATION = 5

SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5)
SELECT
	ID_RESERVATION,
	CONVERT(DATE, DATE_RESERVATION) AS DATE_RESERVATION,
	CONVERT(DATE, DATE_ANNULATION)  AS  DATE_ANNULATION,
	ANNULEE_PAR_USER,
	ID_PASSAGER,
	LISTE_ENVOLEES
FROM AUDIT_ANNULATION_RESERVATION
/* R�sultat des 3 derniers SELECT ici */
/*

ID_RESERVATION                          DATE_RESERVATION        ID_PASSAGER                             ANNULEE
--------------------------------------- ----------------------- --------------------------------------- -------
1                                       2022-04-13 00:00:00.000 1                                       0
2                                       2022-04-18 00:00:00.000 2                                       0
5                                       2022-04-20 00:00:00.000 5                                       1

(3 rows affected)

ID_RESERV_ENVOLEE                       ID_RESERVATION                          ID_ENVOLEE                              CODE_SIEGE
--------------------------------------- --------------------------------------- --------------------------------------- ----------
1                                       1                                       1                                       01A
2                                       2                                       1                                       02B
3                                       2                                       8                                       03C

(3 rows affected)

ID_RESERVATION DATE_RESERVATION DATE_ANNULATION ANNULEE_PAR_USER      ID_PASSAGER LISTE_ENVOLEES
-------------- ---------------- --------------- --------------------- ----------- ----------------------------------------------------------------------------------------------------
5              2022-04-20       2022-04-25      LAPTOP-S98H0U7A\zacky 5            - 7 - 8 - 9 - 10 - 11 - 12 - 13 - 14

(1 row affected)


*/
-- Test 3
SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5,7)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5,7)

UPDATE	RESERVATION
SET		ANNULEE = 'true'
WHERE	ID_RESERVATION = 7

SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5,7)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5,7)
SELECT
	ID_RESERVATION,
	CONVERT(DATE, DATE_RESERVATION) AS DATE_RESERVATION,
	CONVERT(DATE, DATE_ANNULATION)  AS  DATE_ANNULATION,
	ANNULEE_PAR_USER,
	ID_PASSAGER,
	LISTE_ENVOLEES
FROM AUDIT_ANNULATION_RESERVATION
/* R�sultat des 3 derniers SELECT ici */

/* 
ID_RESERVATION                          DATE_RESERVATION        ID_PASSAGER                             ANNULEE
--------------------------------------- ----------------------- --------------------------------------- -------
1                                       2022-04-13 00:00:00.000 1                                       0
2                                       2022-04-18 00:00:00.000 2                                       0
5                                       2022-04-20 00:00:00.000 5                                       1
7                                       2022-05-01 00:00:00.000 7                                       1

(4 rows affected)

ID_RESERV_ENVOLEE                       ID_RESERVATION                          ID_ENVOLEE                              CODE_SIEGE
--------------------------------------- --------------------------------------- --------------------------------------- ----------
1                                       1                                       1                                       01A
2                                       2                                       1                                       02B
3                                       2                                       8                                       03C

(3 rows affected)

ID_RESERVATION DATE_RESERVATION DATE_ANNULATION ANNULEE_PAR_USER      ID_PASSAGER LISTE_ENVOLEES
-------------- ---------------- --------------- --------------------- ----------- ----------------------------------------------------------------------------------------------------
5              2022-04-20       2022-04-25      LAPTOP-S98H0U7A\zacky 5            - 7 - 8 - 9 - 10 - 11 - 12 - 13 - 14
7              2022-05-01       2022-04-25      LAPTOP-S98H0U7A\zacky 7            - 16 - 17

(2 rows affected)
*/

-- Test 4
SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5,7)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5,7)

UPDATE	RESERVATION
SET		DATE_RESERVATION = GETDATE()
WHERE	ID_RESERVATION = 1

SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5,7)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5,7)
SELECT
	ID_RESERVATION,
	CONVERT(DATE, DATE_RESERVATION) AS DATE_RESERVATION,
	CONVERT(DATE, DATE_ANNULATION)  AS  DATE_ANNULATION,
	ANNULEE_PAR_USER,
	ID_PASSAGER,
	LISTE_ENVOLEES
FROM AUDIT_ANNULATION_RESERVATION
/* R�sultat des 3 derniers SELECT ici */

/*
ID_RESERVATION                          DATE_RESERVATION        ID_PASSAGER                             ANNULEE
--------------------------------------- ----------------------- --------------------------------------- -------
1                                       2022-04-25 12:51:27.950 1                                       0
2                                       2022-04-18 00:00:00.000 2                                       0
5                                       2022-04-20 00:00:00.000 5                                       1
7                                       2022-05-01 00:00:00.000 7                                       1

(4 rows affected)

ID_RESERV_ENVOLEE                       ID_RESERVATION                          ID_ENVOLEE                              CODE_SIEGE
--------------------------------------- --------------------------------------- --------------------------------------- ----------
1                                       1                                       1                                       01A
2                                       2                                       1                                       02B
3                                       2                                       8                                       03C

(3 rows affected)

ID_RESERVATION DATE_RESERVATION DATE_ANNULATION ANNULEE_PAR_USER      ID_PASSAGER LISTE_ENVOLEES
-------------- ---------------- --------------- --------------------- ----------- ----------------------------------------------------------------------------------------------------
5              2022-04-20       2022-04-25      LAPTOP-S98H0U7A\zacky 5            - 7 - 8 - 9 - 10 - 11 - 12 - 13 - 14
7              2022-05-01       2022-04-25      LAPTOP-S98H0U7A\zacky 7            - 16 - 17

(2 rows affected)
*/

-- Test 5
SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5,7)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5,7)

UPDATE	RESERVATION
SET		ANNULEE = 'true'
WHERE	ID_RESERVATION = 1

SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5,7)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5,7)
SELECT
	ID_RESERVATION,
	CONVERT(DATE, DATE_RESERVATION) AS DATE_RESERVATION,
	CONVERT(DATE, DATE_ANNULATION)  AS  DATE_ANNULATION,
	ANNULEE_PAR_USER,
	ID_PASSAGER,
	LISTE_ENVOLEES
FROM AUDIT_ANNULATION_RESERVATION
/* R�sultat des 3 derniers SELECT ici */
/*
ID_RESERVATION                          DATE_RESERVATION        ID_PASSAGER                             ANNULEE
--------------------------------------- ----------------------- --------------------------------------- -------
1                                       2022-04-25 12:51:27.950 1                                       1
2                                       2022-04-18 00:00:00.000 2                                       0
5                                       2022-04-20 00:00:00.000 5                                       1
7                                       2022-05-01 00:00:00.000 7                                       1

(4 rows affected)

ID_RESERV_ENVOLEE                       ID_RESERVATION                          ID_ENVOLEE                              CODE_SIEGE
--------------------------------------- --------------------------------------- --------------------------------------- ----------
2                                       2                                       1                                       02B
3                                       2                                       8                                       03C

(2 rows affected)

ID_RESERVATION DATE_RESERVATION DATE_ANNULATION ANNULEE_PAR_USER      ID_PASSAGER LISTE_ENVOLEES
-------------- ---------------- --------------- --------------------- ----------- ----------------------------------------------------------------------------------------------------
5              2022-04-20       2022-04-25      LAPTOP-S98H0U7A\zacky 5            - 7 - 8 - 9 - 10 - 11 - 12 - 13 - 14
7              2022-05-01       2022-04-25      LAPTOP-S98H0U7A\zacky 7            - 16 - 17
1              2022-04-25       2022-04-25      LAPTOP-S98H0U7A\zacky 1            - 1

(3 rows affected)
*/

-- Test 6
SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5,7)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5,7)

UPDATE	RESERVATION
SET		ANNULEE = 'false'
WHERE	ID_RESERVATION = 2

SELECT * FROM RESERVATION WHERE ID_RESERVATION IN (1,2,5,7)
SELECT * FROM RESERVATION_ENVOLEE WHERE ID_RESERVATION IN (1,2,5,7)
SELECT
	ID_RESERVATION,
	CONVERT(DATE, DATE_RESERVATION) AS DATE_RESERVATION,
	CONVERT(DATE, DATE_ANNULATION)  AS  DATE_ANNULATION,
	ANNULEE_PAR_USER,
	ID_PASSAGER,
	LISTE_ENVOLEES
FROM AUDIT_ANNULATION_RESERVATION
/* R�sultat des 3 derniers SELECT ici */
/*
ID_RESERVATION                          DATE_RESERVATION        ID_PASSAGER                             ANNULEE
--------------------------------------- ----------------------- --------------------------------------- -------
1                                       2022-04-25 12:51:27.950 1                                       1
2                                       2022-04-18 00:00:00.000 2                                       0
5                                       2022-04-20 00:00:00.000 5                                       1
7                                       2022-05-01 00:00:00.000 7                                       1

(4 rows affected)

ID_RESERV_ENVOLEE                       ID_RESERVATION                          ID_ENVOLEE                              CODE_SIEGE
--------------------------------------- --------------------------------------- --------------------------------------- ----------
2                                       2                                       1                                       02B
3                                       2                                       8                                       03C

(2 rows affected)

ID_RESERVATION DATE_RESERVATION DATE_ANNULATION ANNULEE_PAR_USER      ID_PASSAGER LISTE_ENVOLEES
-------------- ---------------- --------------- --------------------- ----------- ----------------------------------------------------------------------------------------------------
5              2022-04-20       2022-04-25      LAPTOP-S98H0U7A\zacky 5            - 7 - 8 - 9 - 10 - 11 - 12 - 13 - 14
7              2022-05-01       2022-04-25      LAPTOP-S98H0U7A\zacky 7            - 16 - 17
1              2022-04-25       2022-04-25      LAPTOP-S98H0U7A\zacky 1            - 1

(3 rows affected)
*/

ROLLBACK

/* ********************************************************************************
	SCRIPT NordAir T-SQL E3 - La proc�dure
   ******************************************************************************** */
/* Pour chaque test:
   - Apr�s un SELECT: inclure le r�sultat obtenu seulement si des lignes sont ramen�es par le SELECT
   - Apr�s un EXECUTE: inclure le message obtenu seulement si c'est un message d'erreur
   Par exemple:
	SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-06-16' AND '2022-06-17'
	/* Inclure r�sultat si des lignes affich�es */
	EXECUTE PLANIFIER_VOLS 1823, 55, 'CADM', '2022-06-16', '2022-06-17'
	/* Inclure message si message d'erreur */
	SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-06-16' AND '2022-06-17'
	/* Inclure r�sultat si des lignes affich�es */
*/
BEGIN TRANSACTION

-- Test 1
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-06-16' AND '2022-06-17'
EXECUTE PLANIFIER_VOLS 1823, 55, 'CADM', '2022-06-16', '2022-06-17'
/* AUCUN ERREUR */
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-06-16' AND '2022-06-17'
/*
ID_ENVOLEE                              DATE_ENVOLEE            ID_SEGMENT                              ID_AVION                                ID_PILOTE
--------------------------------------- ----------------------- --------------------------------------- --------------------------------------- ---------------------------------------
193                                     2022-06-16 00:00:00.000 5                                       1                                       3
194                                     2022-06-16 00:00:00.000 6                                       1                                       3
195                                     2022-06-16 00:00:00.000 7                                       1                                       3
196                                     2022-06-16 00:00:00.000 8                                       1                                       3
197                                     2022-06-17 00:00:00.000 5                                       1                                       3
198                                     2022-06-17 00:00:00.000 6                                       1                                       3
199                                     2022-06-17 00:00:00.000 7                                       1                                       3
200                                     2022-06-17 00:00:00.000 8                                       1                                       3

(8 rows affected) 
*/

-- Test 2
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-09-01' AND '2022-09-05'
EXECUTE PLANIFIER_VOLS 1733, 22, 'COPA', '2022-09-01', '2022-09-05'
/* Le vol n’existe pas */
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-09-01' AND '2022-09-05'

-- Test 3
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-09-01' AND '2022-09-05'
EXECUTE PLANIFIER_VOLS 1923, 55, 'TOTO', '2022-09-01', '2022-09-05'
/* L’avion n’existe pas */
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-09-01' AND '2022-09-05'

-- Test 4
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-07-01' AND '2022-07-01'
EXECUTE PLANIFIER_VOLS 1822, 55, 'CADM', '2022-07-01', '2022-07-01'
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-07-01' AND '2022-07-01'
/*
ID_ENVOLEE                              DATE_ENVOLEE            ID_SEGMENT                              ID_AVION                                ID_PILOTE
--------------------------------------- ----------------------- --------------------------------------- --------------------------------------- ---------------------------------------
201                                     2022-07-01 00:00:00.000 1                                       1                                       3
202                                     2022-07-01 00:00:00.000 2                                       1                                       3
203                                     2022-07-01 00:00:00.000 3                                       1                                       3
204                                     2022-07-01 00:00:00.000 4                                       1                                       3

(4 rows affected)
*/

-- Test 5
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-09-01' AND '2022-09-05'
EXECUTE PLANIFIER_VOLS 1923, 99, 'COPA', '2022-09-01', '2022-09-05'
/* Le pilote n’existe pas */
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-09-01' AND '2022-09-05'

-- Test 6
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-06-01' AND '2022-06-05'
EXECUTE PLANIFIER_VOLS 1923, 22, 'COPA', '2022-06-01', '2022-06-05'
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-06-01' AND '2022-06-05'
/*
ID_ENVOLEE                              DATE_ENVOLEE            ID_SEGMENT                              ID_AVION                                ID_PILOTE
--------------------------------------- ----------------------- --------------------------------------- --------------------------------------- ---------------------------------------
205                                     2022-06-01 00:00:00.000 13                                      2                                       1
206                                     2022-06-01 00:00:00.000 14                                      2                                       1
207                                     2022-06-01 00:00:00.000 15                                      2                                       1
208                                     2022-06-01 00:00:00.000 16                                      2                                       1
209                                     2022-06-02 00:00:00.000 13                                      2                                       1
210                                     2022-06-02 00:00:00.000 14                                      2                                       1
211                                     2022-06-02 00:00:00.000 15                                      2                                       1
212                                     2022-06-02 00:00:00.000 16                                      2                                       1
213                                     2022-06-03 00:00:00.000 13                                      2                                       1
214                                     2022-06-03 00:00:00.000 14                                      2                                       1
215                                     2022-06-03 00:00:00.000 15                                      2                                       1
216                                     2022-06-03 00:00:00.000 16                                      2                                       1
217                                     2022-06-04 00:00:00.000 13                                      2                                       1
218                                     2022-06-04 00:00:00.000 14                                      2                                       1
219                                     2022-06-04 00:00:00.000 15                                      2                                       1
220                                     2022-06-04 00:00:00.000 16                                      2                                       1
221                                     2022-06-05 00:00:00.000 13                                      2                                       1
222                                     2022-06-05 00:00:00.000 14                                      2                                       1
223                                     2022-06-05 00:00:00.000 15                                      2                                       1
224                                     2022-06-05 00:00:00.000 16                                      2                                       1

(20 rows affected)
*/

-- Test 7
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-09-05' AND '2022-09-01'
EXECUTE PLANIFIER_VOLS 1923, 61, 'CADM', '2022-06-05', '2022-06-01'
/* La date de fin de période est plus petite que la date de début de la période. */
SELECT * FROM ENVOLEE WHERE DATE_ENVOLEE BETWEEN '2022-09-05' AND '2022-09-01'

ROLLBACK