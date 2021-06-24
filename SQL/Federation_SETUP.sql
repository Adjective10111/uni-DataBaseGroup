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
--     CONSTRAINT Match_FK
--         FOREIGN KEY (Match_id) REFERENCES MATCH(Match_id),

    CONSTRAINT Score_limit
        CHECK (0 <= Score <= 10),
    CONSTRAINT Ref_Positions
        CHECK (
		Position in
               		('Referee', 'HeadLinesman', 'LineJudge', 'Umpire',
                	'BackJudge', 'SideJudge', 'FieldJudge')
        )
)

CREATE TABLE SUPERVISOR (
    National_code varchar(10) NOT NULL UNIQUE,
    FOREIGN KEY (National_code) REFERENCES PERSON(National_code)
)

CREATE TABLE SUPERVISE (
    Match_id varchar(10) NOT NULL UNIQUE,
    SV_NC varchar(10) NOT NULL,
    Description varchar(MAX),

    CONSTRAINT Judge_PK
        PRIMARY KEY (Match_id),
    CONSTRAINT Supervisor_FK
        FOREIGN KEY (SV_NC) REFERENCES SUPERVISOR(National_code),
--     CONSTRAINT Match_FK
--         FOREIGN KEY (Match_id) REFERENCES MATCH(Match_id),
)

CREATE TABLE CONTRACT (
    Serial_no varchar(10) NOT NULL UNIQUE,
    Player_NC varchar(10) NOT NULL,
    Team_id varchar(10) NOT NULL,
    Start_date date NOT NULL,
    End_date date NOT NULL,
    Release_clause varchar(MAX),

    CONSTRAINT Contract_PK
        PRIMARY KEY (Serial_no),
--     CONSTRAINT Player_FK
--         FOREIGN KEY (Player_NC) REFERENCES PLAYER(National_code),
--     CONSTRAINT Team_FK
--         FOREIGN KEY (Team_id) REFERENCES TEAM(Serial_no),

    CONSTRAINT Valid_Dates CHECK (End_date > Start_date)
)

CREATE TABLE PLAYED (
    Player_NC varchar(10) NOT NULL,
    Match_id varchar(10) NOT NULL,
    Position varchar(3) NULL,
    Score float,

    CONSTRAINT Played_PK
        PRIMARY KEY (Player_NC, Match_id),
--     CONSTRAINT Player_FK
--         FOREIGN KEY (Player_NC) REFERENCES PLAYER(National_code),
--     CONSTRAINT Match_FK
--         FOREIGN KEY (Match_id) REFERENCES MATCH(Match_id),

    CONSTRAINT Score_limit
        CHECK (0 <= Score <= 10),
    CONSTRAINT Positions
        CHECK (
		Position in ('GK', 'SW', 'CB', 'LB', 'LWB', 'RB','RWB',
                		'DM', 'CM', 'AM', 'LW', 'RW', 'S', 'CF')
            )
)

CREATE TABLE EVENT (
    Player1_NC varchar(10) NOT NULL,
    Player2_NC varchar(10),
    Match_id varchar(10) NOT NULL,
    Time time NOT NULL,
    Code varchar(2) NOT NULL,

    CONSTRAINT Event_PK
        PRIMARY KEY (Match_id, Time),
--     CONSTRAINT Player1_FK
--         FOREIGN KEY (Player1_NC) REFERENCES PLAYER(National_code),
--     CONSTRAINT Player2_FK
--         FOREIGN KEY (Player2_NC) REFERENCES PLAYER(National_code),
--     CONSTRAINT Match_FK
--         FOREIGN KEY (Match_id) REFERENCES MATCH(Match_id),

    CONSTRAINT Valid_Code
        CHECK (Code in ('GL', 'F', 'YC', 'RC'))
)
