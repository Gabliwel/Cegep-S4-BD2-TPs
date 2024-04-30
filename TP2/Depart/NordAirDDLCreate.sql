/* **********************************************************
	DDL NordAir - Cr�ation des tables
	Sch�ma MRD:	"NordAir"
	Auteur:		Sylvie Monjal 	
********************************************************** */
--CREATE DATABASE NORDAIR
--GO

USE NORDAIR
GO
/* **********************************************************
	PASSAGER
********************************************************** */

CREATE TABLE PASSAGER (
	ID_PASSAGER			DECIMAL(10,0)	IDENTITY NOT NULL,
	NOM					VARCHAR(15)		NOT NULL,
	PRENOM				VARCHAR(15)		NOT NULL,
	ADRESSE				VARCHAR(30)		NOT NULL,
	TELEPHONE			VARCHAR(13)		NOT NULL,
	COURRIEL			VARCHAR(30)		NULL
	CONSTRAINT PK_PASSAGER
				PRIMARY KEY (ID_PASSAGER)
)

/* **********************************************************
	RESERVATION
***********************************************************/
CREATE TABLE RESERVATION (
	ID_RESERVATION		DECIMAL(12,0)	IDENTITY NOT NULL,
	DATE_RESERVATION	DATETIME		DEFAULT GETDATE() NOT NULL,
	ID_PASSAGER			DECIMAL(10,0)	NOT NULL,
	ANNULEE				BIT				DEFAULT 'FALSE' NOT NULL,
	CONSTRAINT PK_RESERVATION
				PRIMARY KEY (ID_RESERVATION),
	CONSTRAINT FK_RES_PASSAGER
				FOREIGN KEY (ID_PASSAGER)
				REFERENCES PASSAGER (ID_PASSAGER)
)

/* **********************************************************
	VOL
***********************************************************/
CREATE TABLE VOL (
	ID_VOL				DECIMAL(3,0)	IDENTITY NOT NULL,
	NO_VOL				DECIMAL(4,0)	NOT NULL,
	NOTES				VARCHAR(125)	NULL,
	CONSTRAINT PK_VOL
				PRIMARY KEY (ID_VOL),
	CONSTRAINT U1_VOL
				UNIQUE (NO_VOL)
)

/* **********************************************************
	AVION
***********************************************************/
CREATE TABLE AVION (
	ID_AVION			DECIMAL(3,0)	IDENTITY NOT NULL,
	APPEL_AVION			VARCHAR(4)		NOT NULL,
	NOMBRE_PLACES		DECIMAL(3,0)	NOT NULL,
	CONSTRAINT PK_AVION
				PRIMARY KEY (ID_AVION),
	CONSTRAINT U1_AVION
				UNIQUE (APPEL_AVION)
)

/* **********************************************************
	AEROPORT
***********************************************************/
CREATE TABLE AEROPORT (
	ID_AEROPORT			DECIMAL(3,0)	IDENTITY NOT NULL,
	ACR_AEROPORT		VARCHAR(3)		NOT NULL,
	NOM_VILLE			VARCHAR(20)		NOT NULL,
	CONSTRAINT PK_AEROPORT
				PRIMARY KEY (ID_AEROPORT),
	CONSTRAINT U1_AEROPORT
				UNIQUE (ACR_AEROPORT)
)

/* **********************************************************
	PILOTE
***********************************************************/
CREATE TABLE PILOTE (
	ID_PILOTE			DECIMAL(3,0)	IDENTITY NOT NULL,
	NO_PILOTE			DECIMAL(4,0)	NOT NULL,
	NOM					VARCHAR(15)		NOT NULL,
	PRENOM				VARCHAR(15)		NOT NULL,
	ADRESSE				VARCHAR(30)		NOT NULL,
	TELEPHONE			VARCHAR(13)		NOT NULL,
	CONSTRAINT PK_PILOTE
				PRIMARY KEY (ID_PILOTE),
	CONSTRAINT U1_PILOTE
				UNIQUE (NO_PILOTE),
)
		
/* **********************************************************
	SEGMENT
***********************************************************/
CREATE TABLE SEGMENT (
	ID_SEGMENT				DECIMAL(4,0)	IDENTITY NOT NULL,
	ORDRE_SEGMENT			CHAR(1)			NOT NULL,
	ID_VOL					DECIMAL(3,0)	NOT NULL,
	AEROPORT_DEPART			DECIMAL(3,0)	NOT NULL,
	AEROPORT_DESTINATION	DECIMAL(3,0)	NOT NULL,
	DUREE_VOL				DECIMAL(3,0)	NOT NULL,
	HEURE_DEPART			TIME			NOT NULL,
	CONSTRAINT PK_SEGMENT
				PRIMARY KEY (ID_SEGMENT),
	CONSTRAINT U1_SEGMENT
				UNIQUE (ID_SEGMENT, ID_VOL),
	CONSTRAINT FK_SEG_VOL
				FOREIGN KEY (ID_VOL)
				REFERENCES VOL (ID_VOL),
	CONSTRAINT FK_SEG_AEROPORT_DEPART
				FOREIGN KEY (AEROPORT_DEPART)
				REFERENCES	AEROPORT (ID_AEROPORT),
	CONSTRAINT FK_SEG_AEROPORT_DESTI
				FOREIGN KEY (AEROPORT_DESTINATION)
				REFERENCES  AEROPORT (ID_AEROPORT)
)

/* **********************************************************
	ENVOLEE
***********************************************************/
CREATE TABLE ENVOLEE (
	ID_ENVOLEE			DECIMAL(10,0)	IDENTITY NOT NULL,
	DATE_ENVOLEE		DATETIME		NOT NULL,
	ID_SEGMENT			DECIMAL(4,0)	NOT NULL,
	ID_AVION			DECIMAL(3,0)	NOT NULL,
	ID_PILOTE			DECIMAL(3,0)	NOT NULL,
	CONSTRAINT PK_ENVOLEE
				PRIMARY KEY (ID_ENVOLEE),
	CONSTRAINT U1_ENVOLEE
				UNIQUE (DATE_ENVOLEE, ID_SEGMENT),
	CONSTRAINT FK_ENVOL_SEGMENT
				FOREIGN KEY (ID_SEGMENT)
				REFERENCES SEGMENT (ID_SEGMENT),
	CONSTRAINT FK_ENVOL_AVION
				FOREIGN KEY (ID_AVION)
				REFERENCES AVION (ID_AVION),
	CONSTRAINT FK_ENVOL_PILOTE
				FOREIGN KEY (ID_PILOTE)
				REFERENCES PILOTE (ID_PILOTE)
)

/* **********************************************************
	RESERVATION_ENVOLEE
***********************************************************/
CREATE TABLE RESERVATION_ENVOLEE (
	ID_RESERV_ENVOLEE	DECIMAL(13,0)	IDENTITY NOT NULL,
	ID_RESERVATION		DECIMAL(12,0)	NOT NULL,
	ID_ENVOLEE			DECIMAL(10,0)	NOT NULL,
	CODE_SIEGE			VARCHAR(3)		NOT NULL,
	CONSTRAINT PK_RESERVATION_ENVOLEE
				PRIMARY KEY (ID_RESERV_ENVOLEE),
	CONSTRAINT U1_RESERVATION_ENVOLEE
				UNIQUE (ID_RESERVATION, ID_ENVOLEE),
	CONSTRAINT U2_RESERVATION_ENVOLEE
				UNIQUE (ID_ENVOLEE, CODE_SIEGE),
	CONSTRAINT FK_RES_ENV_RESERVATION
				FOREIGN KEY (ID_RESERVATION)
				REFERENCES RESERVATION (ID_RESERVATION),
	CONSTRAINT FK_RES_ENV_ENVOLEE
				FOREIGN KEY (ID_ENVOLEE)
				REFERENCES ENVOLEE (ID_ENVOLEE),	
)