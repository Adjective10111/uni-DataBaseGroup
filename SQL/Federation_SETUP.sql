CREATE TABLE PERSON (
    National_code varchar(10) NOT NULL UNIQUE,
    FName varchar(10) NOT NULL,
    LName varchar(10) NOT NULL,
    Birth_date date NOT NULL,
    Phone varchar(11),
    CONSTRAINT Person_PK PRIMARY KEY (National_code)
)

CREATE TABLE REFEREE (
    National_code varchar(10) NOT NULL UNIQUE,
    FOREIGN KEY (National_code) REFERENCES PERSON(National_code)
)

CREATE TABLE SUPERVISOR (
    National_code varchar(10) NOT NULL UNIQUE,
    FOREIGN KEY (National_code) REFERENCES PERSON(National_code)
)

CREATE TABLE PLAYER (
    National_code varchar(10) NOT NULL UNIQUE,
    Height float,
    Weight float,

    CONSTRAINT PLAYER_PK
        PRIMARY KEY (National_code),
    CONSTRAINT Person_FK
        FOREIGN KEY (National_code) REFERENCES PERSON(National_code)
)

CREATE TABLE TECHNICAL_STAFF (
    National_code varchar(10) NOT NULL UNIQUE,
    Role varchar(10),

    CONSTRAINT TECHNICAL_STAFF_PK
        PRIMARY KEY (National_code),
    CONSTRAINT Person_FK
        FOREIGN KEY (National_code) REFERENCES PERSON(National_code)
)

CREATE TABLE TEAM (
    Team_id varchar(10) NOT NULL UNIQUE,
    Name varchar(10) NOT NULL,
    City varchar(10) NOT NULL,
    Established_year date NOT NULL,

    CONSTRAINT TEAM_PK
        PRIMARY KEY (Name)
)

CREATE TABLE CONTRACT (
    Serial_no varchar(10) NOT NULL UNIQUE,
    Staff_NC varchar(10) NOT NULL,
    Team_id varchar(10) NOT NULL,
    Start_date date NOT NULL,
    End_date date NOT NULL,
    Release_clause varchar(MAX),

    CONSTRAINT Contract_PK
        PRIMARY KEY (Serial_no),
    CONSTRAINT Staff_FK
        FOREIGN KEY (Staff_NC) REFERENCES PERSON(National_code),
    CONSTRAINT Team_FK
        FOREIGN KEY (Team_id) REFERENCES TEAM(Team_id),

    CONSTRAINT Valid_Staff CHECK (
        Staff_NC in ((SELECT National_code FROM PLAYER) UNION
                    (SELECT National_code FROM TECHNICAL_STAFF))
        ),
    CONSTRAINT Valid_Dates CHECK (End_date > Start_date)
)

CREATE TABLE STADIUM (
	Stadium_id varchar(10) NOT NULL UNIQUE,
	Name varchar(10) NOT NULL,
	Capacity int NOT NULL,

	CONSTRAINT Stadium_PK
		PRIMARY KEY (Stadium_id)
)

CREATE TABLE SEAT (
	Stadium_id varchar(10) NOT NULL,
	type varchar(1) NOT NULL,
	Price money NOT NULL,

	CONSTRAINT Seat_PK
		PRIMARY KEY (Stadium_id,type),
	CONSTRAINT Stadium_FK
		FOREIGN KEY (Stadium_id) REFERENCES STADIUM(Stadium_id)
)

CREATE TABLE STADIUM_LOCATION(
	Stadium_id varchar(10) NOT NULL,
	SLocation varchar(10) NOT NULL,
	CONSTRAINT SLocation_PK
		PRIMARY KEY(Stadium_id, SLocation),
	CONSTRAINT Stadium_FK
		FOREIGN KEY(Stadium_id) REFERENCES STADIUM(Stadium_id)
)

CREATE TABLE LEAGUE(
    League_id varchar(10) NOT NULL UNIQUE,
    Name varchar(10) NOT NULL,
    Champion varchar(10) NOT NULL,

    CONSTRAINT LEAGUE_PK
        PRIMARY KEY (League_id),
    CONSTRAINT Champion_FK
        FOREIGN KEY (Champion) REFERENCES TEAM(Team_id)
)

CREATE TABLE PARTICIPATE(
    Tsn varchar(10) NOT NULL UNIQUE,
    Lsn varchar(10) NOT NULL UNIQUE,

    CONSTRAINT PARTICIPATE_PK
        PRIMARY KEY (Tsn, Lsn),
    CONSTRAINT Participant
        FOREIGN KEY (Tsn) REFERENCES TEAM(Team_id),
    CONSTRAINT League_FK
        FOREIGN KEY (Lsn) REFERENCES LEAGUE(League_id)
)

CREATE TABLE MATCH (
	Match_id varchar(10) NOT NULL unique,
	Home_team varchar(10) NOT NULL,
	Away_team varchar(10) NOT NULL,
	Date date NOT NULL,
	Stadium_id varchar(10) NOT NULL,
	Attendance int,
	League_id varchar(10) NOT NULL,

	CONSTRAINT Match_PK
		PRIMARY KEY (Match_id),
	CONSTRAINT Stadium_FK
		FOREIGN KEY (Stadium_id) REFERENCES STADIUM(Stadium_id),
	CONSTRAINT HomeTeam_FK
		FOREIGN KEY (Home_team) REFERENCES TEAM(Team_id),
	CONSTRAINT AwayTeam_FK
		FOREIGN KEY (Away_team) REFERENCES TEAM(Team_id),
	CONSTRAINT League_FK
		FOREIGN KEY (League_id) REFERENCES LEAGUE(League_id)
)

CREATE TABLE JUDGE (
    Referee_NC varchar(10) NOT NULL,
    Match_id varchar(10) NOT NULL,
    Position varchar(12),
    Score float,
    Description varchar(MAX),

    CONSTRAINT Judge_PK
        PRIMARY KEY (Referee_NC, Match_id),
    CONSTRAINT Ref_FK
        FOREIGN KEY (Referee_NC) REFERENCES REFEREE(National_code),
    CONSTRAINT Match_FK
        FOREIGN KEY (Match_id) REFERENCES MATCH(Match_id),

    CONSTRAINT Score_limit
        CHECK (0 <= Score <= 10),
    CONSTRAINT Ref_Positions
        CHECK (
		Position in
               		('Referee', 'HeadLinesman', 'LineJudge', 'Umpire',
                	'BackJudge', 'SideJudge', 'FieldJudge')
        )
)

CREATE TABLE SUPERVISE (
    Match_id varchar(10) NOT NULL UNIQUE,
    SV_NC varchar(10) NOT NULL,
    Description varchar(MAX),

    CONSTRAINT Judge_PK
        PRIMARY KEY (Match_id),
    CONSTRAINT Supervisor_FK
        FOREIGN KEY (SV_NC) REFERENCES SUPERVISOR(National_code),
    CONSTRAINT Match_FK
        FOREIGN KEY (Match_id) REFERENCES MATCH(Match_id),
)

CREATE TABLE EVENT (
    Player1_NC varchar(10) NOT NULL,
    Player2_NC varchar(10),
    Match_id varchar(10) NOT NULL,
    Time time NOT NULL,
    Code varchar(2) NOT NULL,

    CONSTRAINT Event_PK
        PRIMARY KEY (Match_id, Time),
    CONSTRAINT Player1_FK
        FOREIGN KEY (Player1_NC) REFERENCES PLAYER(National_code),
    CONSTRAINT Player2_FK
        FOREIGN KEY (Player2_NC) REFERENCES PLAYER(National_code),
    CONSTRAINT Match_FK
        FOREIGN KEY (Match_id) REFERENCES MATCH(Match_id),

    CONSTRAINT Valid_Code
        CHECK (Code in ('GL', 'F', 'YC', 'RC'))
)

CREATE TABLE PLAYED (
    Player_NC varchar(10) NOT NULL,
    Match_id varchar(10) NOT NULL,
    Position varchar(3) NULL,
    Score float,

    CONSTRAINT Played_PK
        PRIMARY KEY (Player_NC, Match_id),
    CONSTRAINT Player_FK
        FOREIGN KEY (Player_NC) REFERENCES PLAYER(National_code),
    CONSTRAINT Match_FK
        FOREIGN KEY (Match_id) REFERENCES MATCH(Match_id),

    CONSTRAINT Score_limit
        CHECK (0 <= Score <= 10),
    CONSTRAINT Positions
        CHECK (
		Position in ('GK', 'SW', 'CB', 'LB', 'LWB', 'RB','RWB',
                		'DM', 'CM', 'AM', 'LW', 'RW', 'S', 'CF')
            )
)
