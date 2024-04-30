/**********************************************************************
	TP2 partie 2 - SECTION D - Gabriel Bertrand et Zachary Gingras
**********************************************************************/

/**********************************************************************
	Question D.1 7 points
***********************************************************************
• Produire la liste des tables (type ‘BASE TABLE’) qui ne sont pas des tables enfants.
• Indiquer dans l’ordre :
	-Le nom de la base de données (BD),
	-Le nom de la table (NOM_TABLE).
• Trier par le nom des tables.
• Utiliser au besoin des fonctions SQL pour améliorer l’affichage du résultat (ex : SUBSTR ou LEFT).
**********************************************************************/
SELECT 
	TAB.TABLE_CATALOG,
	TAB.TABLE_NAME
FROM 
	INFORMATION_SCHEMA.TABLES TAB
WHERE 
	TAB.TABLE_TYPE = 'BASE TABLE' AND
	TAB.TABLE_NAME NOT IN (	SELECT 
								TABLE_NAME
							FROM 
								INFORMATION_SCHEMA.TABLE_CONSTRAINTS
							WHERE 
								CONSTRAINT_TYPE = 'FOREIGN KEY')
ORDER BY
	TAB.TABLE_NAME
	
/*
TABLE_CATALOG                                                                                                                    TABLE_NAME
-------------------------------------------------------------------------------------------------------------------------------- --------------------------------------------------------------------------------------------------------------------------------
NORDAIR                                                                                                                          AEROPORT
NORDAIR                                                                                                                          AVION
NORDAIR                                                                                                                          PASSAGER
NORDAIR                                                                                                                          PILOTE
NORDAIR                                                                                                                          VOL

(5 rows affected)
*/

/**********************************************************************
	Question D.2 9 points
***********************************************************************
Question D.2 9 points
• Produire la liste de toutes les colonnes des clés étrangères (contraintes d’intégrité référentielle).
• Pour colonne d’une clé étrangère, indiquer dans l’ordre :
	-Le nom de la table enfant (TABLE_ENFANT),
	-Le nom de la colonne (COLONNE_FK),
	-Le nom de la clé étrangère (CLE_ETRANGERE),
	-Le nom de la table parent référée (TABLE PARENT),
	-Le nom de la colonne référée (COLONNE_PK),
	-Le nom de la contrainte unique référée (CLE_PRIMAIRE)
• Trier par table enfant puis par clé étrangère et enfin par nom de la colonne de clé étrangère.
• La requête doit fonctionner dans le cas où des clés étrangères sont composées.
• Utiliser au besoin des fonctions SQL pour améliorer l’affichage du résultat (ex : SUBSTR ou LEFT).
**********************************************************************/

SELECT
    FK.TABLE_NAME AS TABLE_ENFANT,
	FK.COLUMN_NAME AS COLONNE_FK,
	FK.CONSTRAINT_NAME AS CLE_ETRANGERE,
	PK.TABLE_NAME AS TABLE_ENFANT,
	PK.COLUMN_NAME AS COLONNE_PK,
	PK.CONSTRAINT_NAME AS CLE_PRIMAIRE
FROM
    INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS CONS
		INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE FK
			ON CONS.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
		INNER JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE PK
			ON CONS.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
ORDER BY
	FK.TABLE_NAME, FK.CONSTRAINT_NAME, FK.COLUMN_NAME

/*

TABLE_ENFANT                                                                                                                     COLONNE_FK                                                                                                                       CLE_ETRANGERE                                                                                                                    TABLE_ENFANT                                                                                                                     COLONNE_PK                                                                                                                       CLE_PRIMAIRE
-------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- --------------------------------------------------------------------------------------------------------------------------------
ENVOLEE                                                                                                                          ID_AVION                                                                                                                         FK_ENVOL_AVION                                                                                                                   AVION                                                                                                                            ID_AVION                                                                                                                         PK_AVION
ENVOLEE                                                                                                                          ID_PILOTE                                                                                                                        FK_ENVOL_PILOTE                                                                                                                  PILOTE                                                                                                                           ID_PILOTE                                                                                                                        PK_PILOTE
ENVOLEE                                                                                                                          ID_SEGMENT                                                                                                                       FK_ENVOL_SEGMENT                                                                                                                 SEGMENT                                                                                                                          ID_SEGMENT                                                                                                                       PK_SEGMENT
RESERVATION                                                                                                                      ID_PASSAGER                                                                                                                      FK_RES_PASSAGER                                                                                                                  PASSAGER                                                                                                                         ID_PASSAGER                                                                                                                      PK_PASSAGER
RESERVATION_ENVOLEE                                                                                                              ID_ENVOLEE                                                                                                                       FK_RES_ENV_ENVOLEE                                                                                                               ENVOLEE                                                                                                                          ID_ENVOLEE                                                                                                                       PK_ENVOLEE
RESERVATION_ENVOLEE                                                                                                              ID_RESERVATION                                                                                                                   FK_RES_ENV_RESERVATION                                                                                                           RESERVATION                                                                                                                      ID_RESERVATION                                                                                                                   PK_RESERVATION
SEGMENT                                                                                                                          AEROPORT_DEPART                                                                                                                  FK_SEG_AEROPORT_DEPART                                                                                                           AEROPORT                                                                                                                         ID_AEROPORT                                                                                                                      PK_AEROPORT
SEGMENT                                                                                                                          AEROPORT_DESTINATION                                                                                                             FK_SEG_AEROPORT_DESTI                                                                                                            AEROPORT                                                                                                                         ID_AEROPORT                                                                                                                      PK_AEROPORT
SEGMENT                                                                                                                          ID_VOL                                                                                                                           FK_SEG_VOL                                                                                                                       VOL                                                                                                                              ID_VOL                                                                                                                           PK_VOL

(9 rows affected)
*/




