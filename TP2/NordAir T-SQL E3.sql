/**********************************************************************
	TP2 partie 2 - SECTION E3 - Gabriel Bertrand et Zachary Gingras
**********************************************************************/

/**********************************************************************
Écrire la procédure T-SQL « PLANIFIER_VOLS » qui permet de créer toutes les envolées quotidiennes d’un vol 
dans un intervalle de temps (bornes incluses).
Pour simplifier, ne pas vérifier si l’avion et le pilote sont bien disponibles pour les dates des envolées.
La procédure doit lever une erreur (RAISEERROR) spécifique à chaque cas lorsque :
	- Le vol n’existe pas,
	- Le pilote n’existe pas,
	- L’avion n’existe pas,
	- La date de fin de période est plus petite que la date de début de la période.
**********************************************************************/


CREATE PROCEDURE PLANIFIER_VOLS
	@v_noVol DECIMAL(4,0),
	@v_noPilote DECIMAL(4,0),
	@v_appelAvion VARCHAR(4),
	@v_date1 DATE,
	@v_date2 DATE
AS
BEGIN
DECLARE @v_nbFound int;
SELECT @v_nbFound = COUNT(*) FROM VOL WHERE NO_VOL = @v_noVol
IF(@v_nbFound = 0)
BEGIN
	RAISERROR('Le vol n’existe pas', 16, 1);
	RETURN;
END
SELECT @v_nbFound = COUNT(*) FROM PILOTE WHERE NO_PILOTE = @v_noPilote
IF(@v_nbFound = 0)
BEGIN
	RAISERROR('Le pilote n’existe pas', 16, 2);
	RETURN;
END
SELECT @v_nbFound = COUNT(*) FROM AVION WHERE APPEL_AVION = @v_appelAvion
IF(@v_nbFound = 0)
BEGIN
	RAISERROR('L’avion n’existe pas', 16, 3);
	RETURN;
END
IF(@v_date1 > @v_date2)
BEGIN
	RAISERROR('La date de fin de période est plus petite que la date de début de la période.', 16, 4);
	RETURN;
END

DECLARE @v_nbDay int;
SET @v_nbDay = 0;

WHILE DATEADD(day, @v_nbDay, @v_date1) <= @v_date2
BEGIN
	DECLARE cur_segment CURSOR FOR
	SELECT ID_SEGMENT
	FROM SEGMENT SEG
		INNER JOIN VOL
			ON SEG.ID_VOL = VOL.ID_VOL
	WHERE VOL.NO_VOL = @v_noVol;

	OPEN cur_segment;
	DECLARE @v_idSegment int;

	FETCH NEXT FROM cur_segment INTO @v_idSegment;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO ENVOLEE 
		(DATE_ENVOLEE,
		ID_SEGMENT,
		ID_AVION,
		ID_PILOTE)
		VALUES
		(DATEADD(day, @v_nbDay, @v_date1),
		@v_idSegment,
		(SELECT ID_AVION FROM AVION WHERE APPEL_AVION = @v_appelAvion),
		(SELECT ID_PILOTE FROM PILOTE WHERE NO_PILOTE = @v_noPilote));
		FETCH NEXT FROM cur_segment INTO @v_idSegment;
	END
	CLOSE cur_segment;
	DEALLOCATE cur_segment;
	SET @v_nbDay += 1;
END
END




