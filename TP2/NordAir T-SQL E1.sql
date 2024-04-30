/**********************************************************************
	TP2 partie 2 - SECTION E1 - Gabriel Bertrand et Zachary Gingras
**********************************************************************/

/**********************************************************************
A) (2 points)
• Écrire la fonction T-SQL « MINUTES_EN_HEURES » qui, à partir d’une durée en minutes, calcule et retourne une durée de type TIME.
• Inclure le résultat affiché lors de l’exécution des requêtes de tests fournies par le professeur.
**********************************************************************/

CREATE FUNCTION MINUTES_EN_HEURES
(
	@v_nbMinute	int 
)
RETURNS TIME
AS
BEGIN
RETURN FORMAT(DATEADD(MINUTE, @v_nbMinute, 0), 'HH:mm')
END

/**********************************************************************
B) (5 points)
• Écrire la fonction T-SQL « MINUTES_VOL_PILOTE » qui calcule et retourne le nombre total de minutes de vol d’un pilote 
(identifié par son numéro de pilote NO_PILOTE) dans un intervalle de temps date1 à date2, bornes incluses.
  - Si le pilote n’existe pas, la fonction doit retourner NULL.
  - Si le pilote n’a pas travaillé pendant la période de temps, la fonction doit retourner 0.
• Inclure le résultat affiché lors de l’exécution des requêtes de tests fournies par le professeur.
**********************************************************************/

CREATE FUNCTION MINUTES_VOL_PILOTE
(
	@v_noPilote	int, 
	@v_date1	DATETIME,
	@v_date2	DATETIME 
)
RETURNS INT
AS
BEGIN
DECLARE @v_totalMin int;
DECLARE @v_nbFound int;
SET @v_totalMin = 0;
SET @v_nbFound = 0;
SELECT @v_nbFound = COUNT(*) FROM PILOTE WHERE NO_PILOTE = @v_noPilote;
	IF(@v_nbFound = 0)
	BEGIN
		RETURN NULL;
	END
	ELSE
	BEGIN
		SELECT @v_totalMin = SUM(DUREE_VOL)
		FROM ENVOLEE ENV INNER JOIN PILOTE PIL ON PIL.ID_PILOTE = ENV.ID_PILOTE INNER JOIN SEGMENT SEG ON ENV.ID_SEGMENT = SEG.ID_SEGMENT
		WHERE PIL.NO_PILOTE = @v_noPilote AND ENV.DATE_ENVOLEE >= @v_date1 AND ENV.DATE_ENVOLEE <= @v_date2;
		IF(@v_totalMin IS NULL)
		BEGIN
			RETURN 0;
		END
	END
RETURN @v_totalMin;
END

/**********************************************************************
C) (3 points)
• Écrire la fonction T-SQL « HEURES_VOL_PILOTE » qui calcule et retourne la durée de vol avec le type TIME d’un pilote 
(identifié par son numéro de pilote NO_PILOTE) dans un intervalle de temps date1 à date2, bornes incluses.
  - Si le pilote n’existe pas, la fonction doit retourner NULL.
  - Si le pilote n’a pas travaillé pendant la période de temps, la fonction doit retourner 0.
• Inclure le résultat affiché lors de l’exécution des requêtes de tests fournies par le professeur.
**********************************************************************/

CREATE FUNCTION HEURES_VOL_PILOTE
(
	@v_noPilote	int, 
	@v_date1	DATETIME,
	@v_date2	DATETIME 
)
RETURNS TIME
AS
BEGIN
DECLARE @v_nbMin int;
DECLARE @v_totalTime TIME;
SELECT @v_nbMin = dbo.MINUTES_VOL_PILOTE(@v_noPilote, @v_date1, @v_date2);
IF(@v_nbMin IS NULL)
BEGIN
	RETURN NULL;
END
ELSE
BEGIN
	SELECT	@v_totalTime = dbo.MINUTES_EN_HEURES(@v_nbMin)
END
RETURN @v_totalTime;
END
