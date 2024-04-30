/**********************************************************************
	TP2 partie 1 - SECTION A - Gabriel Bertrand et Zachary Gingras
**********************************************************************/

/**********************************************************************
	Question A.1 - 3 points
***********************************************************************
• Ajouter la contrainte de validation à la table RESERVATION_ENVOLEE afin de s’assurer que le 
code du siège réservé respecte le format suivant :
	-Deux premiers caractères : un nombre
	-Troisième caractère : une lettre A, B, C ou D
• Dans une transaction (afin qu’un retour arrière ou « rollback » soit possible), 
écrire les requêtes de manipulation (INSERT ou UPDATE) pour tester le comportement de la contrainte :
	-Un 1er cas valide;
	-Des cas invalides qui échouent à cause de la contrainte.
Inclure le résultat affiché lors de l’exécution des requêtes de tests (puis exécuter le « rollback »).
**********************************************************************/
ALTER TABLE RESERVATION_ENVOLEE
ADD CONSTRAINT CHK_CODE_SIEGE
CHECK (CODE_SIEGE LIKE '[0-9][0-9][A-D]')

--TEST REUSSI
--#1
BEGIN TRANSACTION
UPDATE RESERVATION_ENVOLEE SET CODE_SIEGE = '00A' WHERE ID_RESERV_ENVOLEE = 1
ROLLBACK
--(1 row affected)

--TEST FAIL
--#1
BEGIN TRANSACTION
UPDATE RESERVATION_ENVOLEE SET CODE_SIEGE = '000' WHERE ID_RESERV_ENVOLEE = 1
ROLLBACK
--The UPDATE statement conflicted with the CHECK constraint "CHK_CODE_SIEGE". The conflict occurred in database "NORDAIR", table "dbo.RESERVATION_ENVOLEE", column 'CODE_SIEGE'.

--#2
BEGIN TRANSACTION
UPDATE RESERVATION_ENVOLEE SET CODE_SIEGE = '00E' WHERE ID_RESERV_ENVOLEE = 1
ROLLBACK
--The UPDATE statement conflicted with the CHECK constraint "CHK_CODE_SIEGE". The conflict occurred in database "NORDAIR", table "dbo.RESERVATION_ENVOLEE", column 'CODE_SIEGE'.

--#3
BEGIN TRANSACTION
UPDATE RESERVATION_ENVOLEE SET CODE_SIEGE = '0BB' WHERE ID_RESERV_ENVOLEE = 1
ROLLBACK
--The UPDATE statement conflicted with the CHECK constraint "CHK_CODE_SIEGE". The conflict occurred in database "NORDAIR", table "dbo.RESERVATION_ENVOLEE", column 'CODE_SIEGE'.


/**********************************************************************
	Question A.2 - 3 points
***********************************************************************
• Ajouter les contraintes de validation aux tables PASSAGER et PILOTE afin de s’assurer que le numéro de téléphone 
respecte le format suivant : (999)999-9999
• Dans une transaction (afin qu’un retour arrière ou « rollback » soit possible), écrire les requêtes de manipulation 
(INSERT ou UPDATE) pour tester le comportement de chaque contrainte :
	-Un 1er cas valide;
	-Des cas invalides qui échouent à cause de la contrainte.
Inclure le résultat affiché lors de l’exécution des requêtes de tests (puis exécuter le « rollback »).
**********************************************************************/

ALTER TABLE PASSAGER
ADD CONSTRAINT CHK_NUM_TEL
CHECK (TELEPHONE LIKE '[(][0-9][0-9][0-9][)][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]')

--ET

ALTER TABLE PILOTE
ADD CONSTRAINT CHK_NUM_TEL
CHECK (TELEPHONE LIKE '[(][0-9][0-9][0-9][)][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]')

--TEST REUSSI 
BEGIN TRANSACTION
UPDATE PASSAGER SET TELEPHONE = '(999)999-9999' WHERE ID_PASSAGER = 1
ROLLBACK
--(1 row affected)

--TEST FAIL 
--#1
BEGIN TRANSACTION
UPDATE PASSAGER SET TELEPHONE = '9999999999' WHERE ID_PASSAGER = 1
ROLLBACK
--The UPDATE statement conflicted with the CHECK constraint "CHK_NUM_TEL". The conflict occurred in database "NORDAIR", table "dbo.PASSAGER", column 'TELEPHONE'.

--#2
BEGIN TRANSACTION
UPDATE PASSAGER SET TELEPHONE = '(999)9999999' WHERE ID_PASSAGER = 1
ROLLBACK
--The UPDATE statement conflicted with the CHECK constraint "CHK_NUM_TEL". The conflict occurred in database "NORDAIR", table "dbo.PASSAGER", column 'TELEPHONE'.

--#3
BEGIN TRANSACTION
UPDATE PASSAGER SET TELEPHONE = '999999-9999' WHERE ID_PASSAGER = 1
ROLLBACK
--The UPDATE statement conflicted with the CHECK constraint "CHK_NUM_TEL". The conflict occurred in database "NORDAIR", table "dbo.PASSAGER", column 'TELEPHONE'.

--#4
BEGIN TRANSACTION
UPDATE PASSAGER SET TELEPHONE = '(AAA)AAA-AAAA' WHERE ID_PASSAGER = 1
ROLLBACK
--The UPDATE statement conflicted with the CHECK constraint "CHK_NUM_TEL". The conflict occurred in database "NORDAIR", table "dbo.PASSAGER", column 'TELEPHONE'.

