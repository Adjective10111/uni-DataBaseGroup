CREATE TABLE STADIUM (
	Stadium_id varchar(10) NOT NULL UNIQUE,
	Name varchar(10) NOT NULL,
	Capacity varchar(10) NOT NULL,

	CONSTRAINT Stadium_PK
		PRIMARY KEY (Stadium_id)
)

CREATE TABLE SEAT (
	Stadium_id varchar(10) NOT NULL,
	type varchar(10) NOT NULL,
	Price int NOT NULL,

	CONSTRAINT Seat_PK
		PRIMARY KEY (Stadium_id,type),
	CONSTRAINT Stadium_FK
		FOREIGN KEY (Stadium_id) REFERENCES STADIUM(Stadium_id)
)

CREATE TABLE STADIUM_LOCATION(
	Stadium_id varchar(10) NOT NULL,
	Slocation varchar(10) NOT NULL,
	CONSTRAINT Slocation_PK
		PRIMARY KEY(Stadium_id, Slocation),
	CONSTRAINT stadium_FK
		FOREIGN KEY(Stadium_id) REFERENCES STADIUM(Stadium_id)
)

CREATE TABLE MATCH (
	Match_id varchar(10) NOT NULL unique,
	Home_team varchar(10) NOT NULL,
	Away_team varchar(10) NOT NULL,
	Date date NOT NULL,
	Stadium_id varchar(10) NOT NULL,
	Attendence int,
	League_id varchar(10) NOT NULL,

	CONSTRAINT Match_PK
		PRIMARY KEY (Match_id),
	CONSTRAINT Stadium_FK
		FOREIGN KEY (Stadium_id) REFERENCES STADIUM(Stadium_id),
	--CONSTRAINT Team1_Fk
	--	FOREIGN KEY(Home_team) REFERENCES TEAM(Serial_no),
	--CONSTRAINT Team2_Fk
	--	FOREIGN KEY(Away_team) REFERENCES TEAM(Serial_no),
	--CONSTRAINT League_FK
	--	FOREIGN KEY (League_id) REFERENCES LEAGUE(Serial_no)
)