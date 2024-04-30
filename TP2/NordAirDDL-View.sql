/**********************************************************************
	TP2 partie 1 - SECTION B - Gabriel Bertrand et Zachary Gingras
**********************************************************************/

/**********************************************************************
	Question B.1 - 9 points
***********************************************************************
• Créer la vue qui renvoie toutes les envolées avec les informations suivantes :
	-L’identifiant de l’envolée;
	-L’appellation de l’avion (COPA ou CADM);
	-Le nombre de sièges dans l’avion;
	-Le nombre de sièges réservés pour l’envolée.
• Écrire une requête SELECT pour vérifier le contenu complet de la vue, trié par l’identifiant des envolées.
Au besoin, effectuer les jointures pertinentes. L’affichage de cette requête de validation doit être de qualité.
Inclure le résultat affiché lors de l’exécution de la requête d’interrogation de la vue.
**********************************************************************/

CREATE VIEW V_SIEGES
	AS
		SELECT ENVOLEE.ID_ENVOLEE, APPEL_AVION, NOMBRE_PLACES, NOMBRE_PLACES - COUNT(RESERVATION_ENVOLEE.ID_ENVOLEE) AS NOMBRE_PLACES_RESTANTES

		FROM ENVOLEE
		INNER JOIN AVION ON
		ENVOLEE.ID_AVION = AVION.ID_AVION
		INNER JOIN RESERVATION_ENVOLEE ON
		ENVOLEE.ID_ENVOLEE = RESERVATION_ENVOLEE.ID_ENVOLEE

		GROUP BY
		ENVOLEE.ID_ENVOLEE,
		AVION.NOMBRE_PLACES,
		AVION.APPEL_AVION
	GO
	
--SELECT 
SELECT * FROM V_SIEGES ORDER BY ID_ENVOLEE
/*
ID_ENVOLEE                              APPEL_AVION NOMBRE_PLACES                           NOMBRE_PLACES_RESTANTES
--------------------------------------- ----------- --------------------------------------- ---------------------------------------
1                                       COPA        48                                      44
2                                       COPA        48                                      45
3                                       COPA        48                                      47
4                                       COPA        48                                      47
8                                       COPA        48                                      47
12                                      CADM        32                                      31
13                                      CADM        32                                      25
14                                      CADM        32                                      25
15                                      CADM        32                                      25
16                                      CADM        32                                      30
20                                      COPA        48                                      47
30                                      CADM        32                                      31
35                                      COPA        48                                      47
43                                      CADM        32                                      31
44                                      CADM        32                                      30
49                                      COPA        48                                      44
50                                      COPA        48                                      46
51                                      COPA        48                                      47
52                                      COPA        48                                      46
54                                      COPA        48                                      46
56                                      COPA        48                                      47
60                                      CADM        32                                      31
61                                      CADM        32                                      29
62                                      CADM        32                                      31
63                                      CADM        32                                      31
68                                      CADM        32                                      31
77                                      CADM        32                                      31
78                                      CADM        32                                      31
79                                      CADM        32                                      31
80                                      CADM        32                                      31
81                                      CADM        32                                      29
82                                      CADM        32                                      29
84                                      CADM        32                                      30
87                                      COPA        48                                      47
89                                      COPA        48                                      46
91                                      COPA        48                                      47
92                                      COPA        48                                      47
100                                     CADM        32                                      31
102                                     COPA        48                                      47
103                                     COPA        48                                      47
109                                     CADM        32                                      28
110                                     CADM        32                                      31
111                                     CADM        32                                      31
114                                     CADM        32                                      29
116                                     CADM        32                                      31
122                                     COPA        48                                      46
127                                     CADM        32                                      30
128                                     CADM        32                                      31

(48 rows affected)
*/

/**********************************************************************
	Question B.2 - 9 points
***********************************************************************
• Créer la vue qui renvoie la liste des passagers pour chaque vol à une certaine date avec les informations suivantes :
	-L’identifiant passager;
	-Le nom du passager;
	-Le prénom du passager;
	-La date du vol (des envolées…);
	-L’identifiant du vol;
	-L’ordre du segment de départ (par exemple, B);
	-L’ordre du segment d’arrivée (par exemple, C).
• Écrire une requête SELECT pour vérifier le contenu complet de la vue, trié par date puis par identifiant du vol.
Au besoin, effectuer les jointures pertinentes. L’affichage de cette requête de validation doit être de qualité.
Inclure le résultat affiché lors de l’exécution de la requête d’interrogation de la vue.
**********************************************************************/

CREATE VIEW V_LISTE_VOL
AS
	SELECT 
		PAS.ID_PASSAGER AS ID_PASSAGER,
		PAS.PRENOM AS PRENOM,
		PAS.NOM AS NOM,
		ENV.DATE_ENVOLEE AS DATE,
		SEG.ID_VOL AS ID_VOL,
		MIN(ORDRE_SEGMENT) AS SEGMENT_DEPART,
		MAX(ORDRE_SEGMENT) AS SEGMENT_ARRIVEE
	FROM
		PASSAGER PAS
			INNER JOIN RESERVATION RES
				ON RES.ID_PASSAGER = PAS.ID_PASSAGER
			INNER JOIN RESERVATION_ENVOLEE RES_EN
				ON RES_EN.ID_RESERVATION = RES.ID_RESERVATION
			INNER JOIN ENVOLEE ENV
				ON ENV.ID_ENVOLEE = RES_EN.ID_ENVOLEE
			INNER JOIN SEGMENT SEG
				ON SEG.ID_SEGMENT = ENV.ID_SEGMENT
	GROUP BY 
		ENV.DATE_ENVOLEE, SEG.ID_VOL, PAS.ID_PASSAGER, PAS.PRENOM, PAS.NOM
GO

--SELECT 
SELECT * FROM V_LISTE_VOL ORDER BY DATE, ID_PASSAGER

/*
ID_PASSAGER                             PRENOM          NOM             DATE                    ID_VOL                                  SEGMENT_DEPART SEGMENT_ARRIVEE
--------------------------------------- --------------- --------------- ----------------------- --------------------------------------- -------------- ---------------
1                                       Isabelle        Barbeau         2022-05-13 00:00:00.000 1                                       A              A
2                                       Jonny           Berthiaume      2022-05-13 00:00:00.000 1                                       A              A
2                                       Jonny           Berthiaume      2022-05-13 00:00:00.000 2                                       D              D
3                                       Sebastien       Bolduc          2022-05-13 00:00:00.000 1                                       B              B
4                                       Jean-Francois   BrindAmour      2022-05-13 00:00:00.000 1                                       A              A
5                                       Francois        Desjardins      2022-05-13 00:00:00.000 1                                       A              D
9                                       Mathieu         Fortin          2022-05-13 00:00:00.000 4                                       A              B
12                                      Pierre-Luc      Gregoire        2022-05-13 00:00:00.000 4                                       A              C
14                                      Michel          Nadeau          2022-05-13 00:00:00.000 3                                       D              D
15                                      Vincent         Tremblay        2022-05-13 00:00:00.000 4                                       C              C
16                                      David           Mercier         2022-05-13 00:00:00.000 1                                       B              B
20                                      Genevieve       Poussier        2022-05-13 00:00:00.000 4                                       C              C
29                                      etienne         Lapointe-Girard 2022-05-13 00:00:00.000 4                                       A              C
32                                      Remi            Ouellet         2022-05-13 00:00:00.000 4                                       A              B
33                                      Pierre          Ouellette       2022-05-13 00:00:00.000 4                                       A              C
35                                      Sebastien       Tremblay        2022-05-13 00:00:00.000 4                                       A              D
36                                      Remi            Talbot          2022-05-13 00:00:00.000 4                                       A              D
4                                       Jean-Francois   BrindAmour      2022-05-14 00:00:00.000 4                                       B              B
8                                       Stephane J.     Harnois         2022-05-14 00:00:00.000 1                                       D              D
6                                       Mathieu         Cote            2022-05-15 00:00:00.000 3                                       D              D
9                                       Mathieu         Fortin          2022-05-15 00:00:00.000 3                                       C              D
37                                      Guy             Rouillard       2022-05-15 00:00:00.000 1                                       C              C
5                                       Francois        Desjardins      2022-05-16 00:00:00.000 4                                       A              C
7                                       Jean-Philippe   Fortin          2022-05-16 00:00:00.000 1                                       D              D
7                                       Jean-Philippe   Fortin          2022-05-16 00:00:00.000 4                                       A              A
9                                       Mathieu         Fortin          2022-05-16 00:00:00.000 4                                       A              A
10                                      Samuel          Jobin           2022-05-16 00:00:00.000 2                                       B              B
18                                      Philippe        Duval           2022-05-16 00:00:00.000 1                                       A              A
19                                      Guillaume       Lapierre        2022-05-16 00:00:00.000 1                                       A              A
19                                      Guillaume       Lapierre        2022-05-16 00:00:00.000 2                                       D              D
20                                      Genevieve       Poussier        2022-05-16 00:00:00.000 1                                       B              B
21                                      Sylvain         Mallet          2022-05-16 00:00:00.000 1                                       A              A
22                                      Jean-Francois   Saucier         2022-05-16 00:00:00.000 1                                       A              D
31                                      Vincent         Aubert          2022-05-16 00:00:00.000 3                                       D              D
37                                      Guy             Rouillard       2022-05-16 00:00:00.000 2                                       B              B
5                                       Francois        Desjardins      2022-05-17 00:00:00.000 4                                       D              D
11                                      Francois        Ratte           2022-05-17 00:00:00.000 4                                       A              A
21                                      Sylvain         Mallet          2022-05-17 00:00:00.000 4                                       B              B
25                                      Charles         Aspiros         2022-05-17 00:00:00.000 1                                       D              D
32                                      Remi            Ouellet         2022-05-17 00:00:00.000 4                                       C              C
11                                      Francois        Ratte           2022-05-18 00:00:00.000 1                                       D              D
12                                      Pierre-Luc      Gregoire        2022-05-18 00:00:00.000 1                                       B              B
13                                      Pierre-Luc      Dostie-Proulx   2022-05-18 00:00:00.000 2                                       C              C
17                                      Marjorie        Dionne          2022-05-18 00:00:00.000 3                                       A              A
23                                      Mathieu         Lagace          2022-05-18 00:00:00.000 1                                       D              D
26                                      Maxime          Picard          2022-05-18 00:00:00.000 3                                       C              D
29                                      etienne         Lapointe-Girard 2022-05-18 00:00:00.000 1                                       B              B
33                                      Pierre          Ouellette       2022-05-18 00:00:00.000 1                                       B              B
34                                      Nathalie        Pelletier       2022-05-18 00:00:00.000 3                                       A              A
35                                      Sebastien       Tremblay        2022-05-18 00:00:00.000 1                                       A              A
36                                      Remi            Talbot          2022-05-18 00:00:00.000 1                                       A              A
37                                      Guy             Rouillard       2022-05-18 00:00:00.000 1                                       A              A
22                                      Jean-Francois   Saucier         2022-05-19 00:00:00.000 4                                       A              C
24                                      Marc            Blanchette      2022-05-19 00:00:00.000 1                                       D              D
24                                      Marc            Blanchette      2022-05-19 00:00:00.000 4                                       A              A
26                                      Maxime          Picard          2022-05-19 00:00:00.000 4                                       A              A
27                                      Jean-Francois   Richard         2022-05-19 00:00:00.000 2                                       B              B
28                                      Jason           Dube            2022-05-19 00:00:00.000 4                                       A              A
30                                      Nicolas         Mercier         2022-05-19 00:00:00.000 2                                       C              C
16                                      David           Mercier         2022-05-20 00:00:00.000 4                                       C              C
17                                      Marjorie        Dionne          2022-05-20 00:00:00.000 3                                       B              B
22                                      Jean-Francois   Saucier         2022-05-20 00:00:00.000 4                                       D              D
28                                      Jason           Dube            2022-05-20 00:00:00.000 1                                       D              D
33                                      Pierre          Ouellette       2022-05-20 00:00:00.000 4                                       C              C
34                                      Nathalie        Pelletier       2022-05-20 00:00:00.000 3                                       B              B
35                                      Sebastien       Tremblay        2022-05-20 00:00:00.000 1                                       B              B
36                                      Remi            Talbot          2022-05-20 00:00:00.000 1                                       B              B
37                                      Guy             Rouillard       2022-05-20 00:00:00.000 1                                       B              B

(68 rows affected)
*/
