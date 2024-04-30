/**********************************************************************
	TP2 partie 2 - SECTION E2 - Gabriel Bertrand et Zachary Gingras
**********************************************************************/

/**********************************************************************
• Créer une table AUDIT_ANNULATION_RESERVATION qui va contenir de l’information sur chaque
réservation annulée :
	L’identifiant de la réservation,
	La date de la réservation,
	La date de l’annulation,
	L’utilisateur qui a effectué l’annulation,
	L’identifiant du passager,
	La liste des envolées associées à la réservation.
**********************************************************************/

	-- VARCHAR(21) -> POUR QUE LE ( SELECT SYSTEM_USER ) FONCTIONNE (COMME NOS SYSTEM_USER SONT DE VARCHAR(21))

	CREATE TABLE AUDIT_ANNULATION_RESERVATION (
		ID_RESERVATION			SMALLINT		NOT NULL,
		DATE_RESERVATION		DATETIME		NOT NULL,
		DATE_ANNULATION			DATETIME		NOT NULL,
		ANNULEE_PAR_USER		VARCHAR(21)		NOT NULL,
		ID_PASSAGER				SMALLINT		NOT NULL,
		LISTE_ENVOLEES			VARCHAR(100)		NULL
	)

/**********************************************************************
• Écrire le trigger T-SQL « RESERVATION_ANNULEE » qui, lorsqu’une réservation est annulée,
effectue les traitements suivants :
	- Supprime toutes les réservations des envolées associées à la réservation afin de rendre disponibles 
	les sièges réservés. À noter que la réservation elle-même n’est pas supprimée de la base de données.
	- Enregistre dans la table AUDIT_ANNULATION_RESERVATION les information sur la réservation annulée. 
	Voir ci-dessous pour le format texte de la liste des envolées concernées par l’annulation.
**********************************************************************/



CREATE TRIGGER T_RESERVATION_ANNULEE ON [dbo].[RESERVATION]
AFTER UPDATE
AS 
DECLARE @afterUpdateID BIT
SELECT
	@afterUpdateID = INSERTED.ANNULEE
FROM
	INSERTED DECLARE @beforeUpdateID BIT;
SELECT
	@beforeUpdateID = DELETED.ANNULEE
FROM
	DELETED; 
IF (@afterUpdateID = 'true') AND (@beforeUpdateID = 'false')
BEGIN
	DECLARE @liste_envolee VARCHAR(100);
	SET @liste_envolee = '';
	DECLARE @updatedID INT;
	SELECT
		@updatedID = INSERTED.ID_RESERVATION
	FROM
		INSERTED; 
	DECLARE cur_Reservation CURSOR FOR
	SELECT
		RES.ID_RESERV_ENVOLEE
	FROM
		RESERVATION_ENVOLEE RES
	WHERE
		RES.ID_RESERVATION = @updatedID OPEN cur_Reservation;
	DECLARE @v_Id_reservation_envolee VARCHAR(100); 
	FETCH NEXT FROM cur_Reservation INTO @v_Id_reservation_envolee;
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		SET @liste_envolee += ' - ' + @v_Id_reservation_envolee;
		DELETE 
			FROM RESERVATION_ENVOLEE
		WHERE
			RESERVATION_ENVOLEE.ID_RESERV_ENVOLEE = @v_Id_reservation_envolee;
		FETCH NEXT FROM cur_Reservation INTO @v_Id_reservation_envolee;
	END 
	CLOSE cur_Reservation;
	DEALLOCATE cur_Reservation;
	INSERT INTO AUDIT_ANNULATION_RESERVATION (
			ID_RESERVATION,
			DATE_RESERVATION,
			DATE_ANNULATION,
			ANNULEE_PAR_USER,
			ID_PASSAGER,
			LISTE_ENVOLEES )
		VALUES (
			( SELECT ID_RESERVATION FROM DELETED ),
			( SELECT DELETED.DATE_RESERVATION FROM DELETED ),
			GETDATE(),
			( SELECT SYSTEM_USER ),
			( SELECT DELETED.ID_PASSAGER FROM DELETED ),
			@liste_envolee)
END



