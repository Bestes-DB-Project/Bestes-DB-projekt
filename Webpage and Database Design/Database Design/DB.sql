DROP Database IF EXISTS dbs_spacetravel;
Create Database  dbs_spacetravel;
Use dbs_spacetravel;

Create Table Person (
    SVNr BIGINT NOT NULL,
    Vorname varchar(30) NOT NULL,
    Nachname varchar(30) NOT NULL,
    PLZ INT,
    Ort varchar(30),
    Straße varchar(50),
    HausNr varchar(20),
    Passwort varchar(20),
    CONSTRAINT PERSON_PK PRIMARY KEY (SVNr)
);

Create Table TelNr (
    SVNr BIGINT NOT NULL,
    TelNr BIGINT NOT NULL,
    CONSTRAINT TelNr_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Person(SVNr),
    CONSTRAINT TelNr_PK PRIMARY KEY (TelNr,SVNr)
);

Create Table Passagier (
    PasNr INT NOT NULL AUTO_INCREMENT,
    SVNr BIGINT NOT NULL,
    CONSTRAINT Passagier_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Person(SVNr),
    CONSTRAINT Passagier_PK PRIMARY KEY (PasNr)
);

Create Table Angestellte (
    AngNr INT NOT NULL,
    SVNr BIGINT NOT NULL,
    CONSTRAINT Angestellte_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Person(SVNr),
    CONSTRAINT Angestellte_PK PRIMARY KEY (AngNr,SVNr)
);

Create Table Bank (
    BLZ INT NOT NULL,
    BankName varchar(20) NOT NULL,
    CONSTRAINT Bank_PK PRIMARY KEY (BLZ)
);


Create Table Gehaltskonto (
    KontoNr INT NOT NULL,
    BLZ INT NOT NULL,
    Kontostand INT NOT NULL,
    SVNr BIGINT NOT NULL,
    CONSTRAINT Gehalstkonto_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Angestellte(SVNr),
    CONSTRAINT Gehalstkonto_BLZ_FK FOREIGN KEY (BLZ) REFERENCES Bank(BLZ),
    CONSTRAINT Angestellte_Unique UNIQUE (SVNr),
    CONSTRAINT Angestellte_PK PRIMARY KEY (KontoNr,BLZ)
);



Create Table Flug (
    FlugNr INT NOT NULL,
    Abflugplanet varchar(30),
    Zielplanet varchar(30),
    Abflugzeit timestamp,
    Ankuftszeit timestamp,
    CONSTRAINT Flug_PK PRIMARY KEY (FlugNr)
);

Create Table Flug_Wartet_Auf (
    FlugDavor INT NOT NULL,
    FlugDanach INT NOT NULL,
    CONSTRAINT FlugWartetAuf_FlugDavor_FK FOREIGN KEY (FlugDavor) REFERENCES Flug(FlugNr),
    CONSTRAINT FlugWartetAuf_FlugDanach_FK FOREIGN KEY (FlugDanach) REFERENCES Flug(FlugNr),
    CONSTRAINT FlugWartetAuf_PK PRIMARY KEY (FlugDavor,FlugDanach)
);

Create Table Kapitaen (
    Kapitaenspatent INT NOT NULL,
    Lichtjahre INT,
    SVNr BIGINT NOT NULL,
    CONSTRAINT Kapitaen_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Angestellte(SVNr),
    CONSTRAINT Kapitaenspatent_Unique UNIQUE (Kapitaenspatent),
    CONSTRAINT Kapitaen_PK PRIMARY KEY (SVNr)
);


Create Table Hersteller (
    HerstellerName varchar(30) NOT NULL,
    CONSTRAINT Hersteller_PK PRIMARY KEY (HerstellerName)
);

Create Table Raumschifftyp (
    TypenNr INT NOT NULL,
    Sitzplätze INT,
    Begleitpersonal varchar(30),
    Typenbezeichnung varchar(30),
    Hersteller varchar(30) NOT NULL,
    CONSTRAINT Raumschifftyp_Hersteller_FK FOREIGN KEY (Hersteller) REFERENCES Hersteller(HerstellerName),
    CONSTRAINT Raumschifftyp_PK PRIMARY KEY (TypenNr)
);

Create Table Fliengen (
    FlugNr INT NOT NULL,
    SVNr BIGINT NOT NULL,
    TypenNr INT NOT NULL,
    CONSTRAINT Fliengen_FlugNr_FK FOREIGN KEY (FlugNr) REFERENCES Flug(FlugNr),
    CONSTRAINT Fliengen_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Kapitaen(SVNr),
    CONSTRAINT Fliengen_TypenNr_FK FOREIGN KEY (TypenNr) REFERENCES Raumschifftyp(TypenNr),
    CONSTRAINT Fliengen_PK PRIMARY KEY (FlugNr)
);

Create Table Bucht (
    BuchungsNr INT NOT NULL AUTO_INCREMENT,
    Klasse INT,
    Buchungsdatum DATE,
    SVNr BIGINT NOT NULL,
    UserSVNr BIGINT NOT NULL,
    FlugNr INT NOT NULL,
    CONSTRAINT Bucht_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Passagier(SVNr),
    CONSTRAINT Bucht_UserSVNr_FK FOREIGN KEY (UserSVNr) REFERENCES Passagier(SVNr),
    CONSTRAINT Bucht_FlugNr_FK FOREIGN KEY (FlugNr) REFERENCES Flug(FlugNr),
    CONSTRAINT Bucht_Unique UNIQUE (BuchungsNr),
    CONSTRAINT Bucht_PK PRIMARY KEY (SVNr,FlugNr)
);

Create Table Techniker (
    LizenzNr INT NOT NULL,
    Ausbildungsgrad varchar(30),
    SVNr BIGINT NOT NULL,
    TypenNr INT NOT NULL,
    CONSTRAINT Techniker_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Angestellte(SVNr),
    CONSTRAINT Techniker_TypenNr_FK FOREIGN KEY (TypenNr) REFERENCES Raumschifftyp(TypenNr),
    CONSTRAINT Techniker_Unique UNIQUE (LizenzNr),
    CONSTRAINT Techniker_PK PRIMARY KEY (SVNr)
);

Create Table Raumschiffexemplar (
    InvNr INT NOT NULL,
    Lichtjahre INT,
    Fertigungsjahr INT,
    TypenNr INT NOT NULL,
    Code INT NOT NULL,
    SVNr BIGINT,
    CONSTRAINT Raumschiffexemplar_TypenNr_FK FOREIGN KEY (TypenNr) REFERENCES Raumschifftyp(TypenNr),
    CONSTRAINT Raumschiffexemplar_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Angestellte(SVNr),
    CONSTRAINT Raumschiffexemplar_Unique UNIQUE (Code),
    CONSTRAINT Raumschiffexemplar_PK PRIMARY KEY (TypenNr,InvNr)
);


Insert into dbs_spacetravel.flug Values (2,'Erde','Mars',STR_TO_DATE('2020-01-01 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (3,'Mars','Jupiter',STR_TO_DATE('2020-01-01 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (4,'Neptun','Venus',STR_TO_DATE('2020-01-01 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (5,'Merkur','Mars',STR_TO_DATE('2020-01-01 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (6,'Neptun','Saturn',STR_TO_DATE('2020-01-01 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (7,'Saturn','Merkur',STR_TO_DATE('2020-01-01 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (8,'Venus','Uranus',STR_TO_DATE('2020-01-01 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (9,'Jupiter','Venus',STR_TO_DATE('2020-01-01 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (10,'Merkur','Neptun',STR_TO_DATE('2020-01-01 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (11,'Saturn','Uranus',STR_TO_DATE('2020-01-01 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (12,'Mars','Erde',STR_TO_DATE('2020-01-01 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (13,'Venus','Jupiter',STR_TO_DATE('2020-01-01 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (14,'Venus','Jupiter',STR_TO_DATE('2020-01-01 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-02 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (15,'Venus','Jupiter',STR_TO_DATE('2020-01-01 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-01 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (16,'Erde','Mars',STR_TO_DATE('2020-01-02 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (17,'Mars','Jupiter',STR_TO_DATE('2020-01-02 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (18,'Neptun','Venus',STR_TO_DATE('2020-01-02 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (19,'Merkur','Mars',STR_TO_DATE('2020-01-02 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (20,'Neptun','Saturn',STR_TO_DATE('2020-01-02 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (21,'Saturn','Merkur',STR_TO_DATE('2020-01-02 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (22,'Venus','Uranus',STR_TO_DATE('2020-01-02 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (23,'Jupiter','Venus',STR_TO_DATE('2020-01-02 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (24,'Merkur','Neptun',STR_TO_DATE('2020-01-02 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (25,'Saturn','Uranus',STR_TO_DATE('2020-01-02 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (26,'Mars','Erde',STR_TO_DATE('2020-01-02 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (27,'Venus','Jupiter',STR_TO_DATE('2020-01-02 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (28,'Venus','Jupiter',STR_TO_DATE('2020-01-02 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (29,'Venus','Jupiter',STR_TO_DATE('2020-01-02 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-03 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (30,'Erde','Mars',STR_TO_DATE('2020-01-03 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (31,'Mars','Jupiter',STR_TO_DATE('2020-01-03 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (32,'Neptun','Venus',STR_TO_DATE('2020-01-03 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (33,'Merkur','Mars',STR_TO_DATE('2020-01-03 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (34,'Neptun','Saturn',STR_TO_DATE('2020-01-03 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (35,'Saturn','Merkur',STR_TO_DATE('2020-01-03 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (36,'Venus','Uranus',STR_TO_DATE('2020-01-03 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (37,'Jupiter','Venus',STR_TO_DATE('2020-01-03 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (38,'Merkur','Neptun',STR_TO_DATE('2020-01-03 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (39,'Saturn','Uranus',STR_TO_DATE('2020-01-03 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (40,'Mars','Erde',STR_TO_DATE('2020-01-03 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (41,'Venus','Jupiter',STR_TO_DATE('2020-01-03 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (42,'Venus','Jupiter',STR_TO_DATE('2020-01-03 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (43,'Venus','Jupiter',STR_TO_DATE('2020-01-03 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-04 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (44,'Erde','Mars',STR_TO_DATE('2020-01-04 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (45,'Mars','Jupiter',STR_TO_DATE('2020-01-04 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (46,'Neptun','Venus',STR_TO_DATE('2020-01-04 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (47,'Merkur','Mars',STR_TO_DATE('2020-01-04 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (48,'Neptun','Saturn',STR_TO_DATE('2020-01-04 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (49,'Saturn','Merkur',STR_TO_DATE('2020-01-04 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (50,'Venus','Uranus',STR_TO_DATE('2020-01-04 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (51,'Jupiter','Venus',STR_TO_DATE('2020-01-04 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (52,'Merkur','Neptun',STR_TO_DATE('2020-01-04 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (53,'Saturn','Uranus',STR_TO_DATE('2020-01-04 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (54,'Mars','Erde',STR_TO_DATE('2020-01-04 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (55,'Venus','Jupiter',STR_TO_DATE('2020-01-04 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (56,'Venus','Jupiter',STR_TO_DATE('2020-01-04 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (57,'Venus','Jupiter',STR_TO_DATE('2020-01-04 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-05 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (58,'Erde','Mars',STR_TO_DATE('2020-01-05 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (59,'Mars','Jupiter',STR_TO_DATE('2020-01-05 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (60,'Neptun','Venus',STR_TO_DATE('2020-01-05 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (61,'Merkur','Mars',STR_TO_DATE('2020-01-05 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (62,'Neptun','Saturn',STR_TO_DATE('2020-01-05 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (63,'Saturn','Merkur',STR_TO_DATE('2020-01-05 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (64,'Venus','Uranus',STR_TO_DATE('2020-01-05 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (65,'Jupiter','Venus',STR_TO_DATE('2020-01-05 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (66,'Merkur','Neptun',STR_TO_DATE('2020-01-05 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (67,'Saturn','Uranus',STR_TO_DATE('2020-01-05 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (68,'Mars','Erde',STR_TO_DATE('2020-01-05 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (69,'Venus','Jupiter',STR_TO_DATE('2020-01-05 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (70,'Venus','Jupiter',STR_TO_DATE('2020-01-05 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (71,'Venus','Jupiter',STR_TO_DATE('2020-01-05 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-06 19:00:00','%Y-%m-%d %H:%i:%s'));
 
Insert into dbs_spacetravel.flug Values (72,'Erde','Mars',STR_TO_DATE('2020-01-06 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (73,'Mars','Jupiter',STR_TO_DATE('2020-01-06 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (74,'Neptun','Venus',STR_TO_DATE('2020-01-06 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (75,'Merkur','Mars',STR_TO_DATE('2020-01-06 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (76,'Neptun','Saturn',STR_TO_DATE('2020-01-06 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (77,'Saturn','Merkur',STR_TO_DATE('2020-01-06 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (78,'Venus','Uranus',STR_TO_DATE('2020-01-06 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (79,'Jupiter','Venus',STR_TO_DATE('2020-01-06 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (80,'Merkur','Neptun',STR_TO_DATE('2020-01-06 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (81,'Saturn','Uranus',STR_TO_DATE('2020-01-06 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (82,'Mars','Erde',STR_TO_DATE('2020-01-06 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (83,'Venus','Jupiter',STR_TO_DATE('2020-01-06 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (84,'Venus','Jupiter',STR_TO_DATE('2020-01-06 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (85,'Venus','Jupiter',STR_TO_DATE('2020-01-06 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-07 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (86,'Erde','Mars',STR_TO_DATE('2020-01-07 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (87,'Mars','Jupiter',STR_TO_DATE('2020-01-07 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (88,'Neptun','Venus',STR_TO_DATE('2020-01-07 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (89,'Merkur','Mars',STR_TO_DATE('2020-01-07 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (90,'Neptun','Saturn',STR_TO_DATE('2020-01-07 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (91,'Saturn','Merkur',STR_TO_DATE('2020-01-07 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (92,'Venus','Uranus',STR_TO_DATE('2020-01-07 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (93,'Jupiter','Venus',STR_TO_DATE('2020-01-07 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (94,'Merkur','Neptun',STR_TO_DATE('2020-01-07 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (95,'Saturn','Uranus',STR_TO_DATE('2020-01-07 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (96,'Mars','Erde',STR_TO_DATE('2020-01-07 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (97,'Venus','Jupiter',STR_TO_DATE('2020-01-07 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (98,'Venus','Jupiter',STR_TO_DATE('2020-01-07 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (99,'Venus','Jupiter',STR_TO_DATE('2020-01-07 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (100,'Erde','Mars',STR_TO_DATE('2020-01-08 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (101,'Mars','Jupiter',STR_TO_DATE('2020-01-08 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (102,'Neptun','Venus',STR_TO_DATE('2020-01-08 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (103,'Merkur','Mars',STR_TO_DATE('2020-01-08 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (104,'Neptun','Saturn',STR_TO_DATE('2020-01-08 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (105,'Saturn','Merkur',STR_TO_DATE('2020-01-08 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (106,'Venus','Uranus',STR_TO_DATE('2020-01-08 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (107,'Jupiter','Venus',STR_TO_DATE('2020-01-08 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (108,'Merkur','Neptun',STR_TO_DATE('2020-01-08 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (109,'Saturn','Uranus',STR_TO_DATE('2020-01-08 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (110,'Mars','Erde',STR_TO_DATE('2020-01-08 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (111,'Venus','Jupiter',STR_TO_DATE('2020-01-08 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (112,'Venus','Jupiter',STR_TO_DATE('2020-01-08 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (113,'Venus','Jupiter',STR_TO_DATE('2020-01-08 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (114,'Erde','Mars',STR_TO_DATE('2020-01-09 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (115,'Mars','Jupiter',STR_TO_DATE('2020-01-09 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (116,'Neptun','Venus',STR_TO_DATE('2020-01-09 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (117,'Merkur','Mars',STR_TO_DATE('2020-01-09 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (118,'Neptun','Saturn',STR_TO_DATE('2020-01-09 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (119,'Saturn','Merkur',STR_TO_DATE('2020-01-09 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (120,'Venus','Uranus',STR_TO_DATE('2020-01-09 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (121,'Jupiter','Venus',STR_TO_DATE('2020-01-09 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (122,'Merkur','Neptun',STR_TO_DATE('2020-01-09 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (123,'Saturn','Uranus',STR_TO_DATE('2020-01-09 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (124,'Mars','Erde',STR_TO_DATE('2020-01-09 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (125,'Venus','Jupiter',STR_TO_DATE('2020-01-09 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (126,'Venus','Jupiter',STR_TO_DATE('2020-01-09 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (127,'Venus','Jupiter',STR_TO_DATE('2020-01-09 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (128,'Erde','Mars',STR_TO_DATE('2020-01-10 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (129,'Mars','Jupiter',STR_TO_DATE('2020-01-10 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (130,'Neptun','Venus',STR_TO_DATE('2020-01-10 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (131,'Merkur','Mars',STR_TO_DATE('2020-01-10 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (132,'Neptun','Saturn',STR_TO_DATE('2020-01-10 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (133,'Saturn','Merkur',STR_TO_DATE('2020-01-10 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (134,'Venus','Uranus',STR_TO_DATE('2020-01-10 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (135,'Jupiter','Venus',STR_TO_DATE('2020-01-10 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (136,'Merkur','Neptun',STR_TO_DATE('2020-01-10 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (137,'Saturn','Uranus',STR_TO_DATE('2020-01-10 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (138,'Mars','Erde',STR_TO_DATE('2020-01-10 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (139,'Venus','Jupiter',STR_TO_DATE('2020-01-10 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (140,'Venus','Jupiter',STR_TO_DATE('2020-01-10 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (141,'Venus','Jupiter',STR_TO_DATE('2020-01-10 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (142,'Erde','Mars',STR_TO_DATE('2020-01-11 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (143,'Mars','Jupiter',STR_TO_DATE('2020-01-11 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (144,'Neptun','Venus',STR_TO_DATE('2020-01-11 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (145,'Merkur','Mars',STR_TO_DATE('2020-01-11 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (146,'Neptun','Saturn',STR_TO_DATE('2020-01-11 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (147,'Saturn','Merkur',STR_TO_DATE('2020-01-11 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (148,'Venus','Uranus',STR_TO_DATE('2020-01-11 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (149,'Jupiter','Venus',STR_TO_DATE('2020-01-11 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (150,'Merkur','Neptun',STR_TO_DATE('2020-01-11 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (151,'Saturn','Uranus',STR_TO_DATE('2020-01-11 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (152,'Mars','Erde',STR_TO_DATE('2020-01-11 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (153,'Venus','Jupiter',STR_TO_DATE('2020-01-11 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (154,'Venus','Jupiter',STR_TO_DATE('2020-01-11 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (155,'Venus','Jupiter',STR_TO_DATE('2020-01-11 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (156,'Erde','Mars',STR_TO_DATE('2020-01-12 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (157,'Mars','Jupiter',STR_TO_DATE('2020-01-12 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (158,'Neptun','Venus',STR_TO_DATE('2020-01-12 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (159,'Merkur','Mars',STR_TO_DATE('2020-01-12 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (160,'Neptun','Saturn',STR_TO_DATE('2020-01-12 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (161,'Saturn','Merkur',STR_TO_DATE('2020-01-12 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (162,'Venus','Uranus',STR_TO_DATE('2020-01-12 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (163,'Jupiter','Venus',STR_TO_DATE('2020-01-12 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (164,'Merkur','Neptun',STR_TO_DATE('2020-01-12 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (165,'Saturn','Uranus',STR_TO_DATE('2020-01-12 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (166,'Mars','Erde',STR_TO_DATE('2020-01-12 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (167,'Venus','Jupiter',STR_TO_DATE('2020-01-12 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (168,'Venus','Jupiter',STR_TO_DATE('2020-01-12 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (169,'Venus','Jupiter',STR_TO_DATE('2020-01-12 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-13 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (170,'Erde','Mars',STR_TO_DATE('2020-01-13 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (171,'Mars','Jupiter',STR_TO_DATE('2020-01-13 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (172,'Neptun','Venus',STR_TO_DATE('2020-01-13 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (173,'Merkur','Mars',STR_TO_DATE('2020-01-13 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (174,'Neptun','Saturn',STR_TO_DATE('2020-01-13 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (175,'Saturn','Merkur',STR_TO_DATE('2020-01-13 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (176,'Venus','Uranus',STR_TO_DATE('2020-01-13 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (177,'Jupiter','Venus',STR_TO_DATE('2020-01-13 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (178,'Merkur','Neptun',STR_TO_DATE('2020-01-13 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (179,'Saturn','Uranus',STR_TO_DATE('2020-01-13 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (180,'Mars','Erde',STR_TO_DATE('2020-01-13 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (181,'Venus','Jupiter',STR_TO_DATE('2020-01-13 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (182,'Venus','Jupiter',STR_TO_DATE('2020-01-13 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (183,'Venus','Jupiter',STR_TO_DATE('2020-01-13 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (184,'Erde','Mars',STR_TO_DATE('2020-01-14 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (185,'Mars','Jupiter',STR_TO_DATE('2020-01-14 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (186,'Neptun','Venus',STR_TO_DATE('2020-01-14 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (187,'Merkur','Mars',STR_TO_DATE('2020-01-14 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (188,'Neptun','Saturn',STR_TO_DATE('2020-01-14 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (189,'Saturn','Merkur',STR_TO_DATE('2020-01-14 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (190,'Venus','Uranus',STR_TO_DATE('2020-01-14 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (191,'Jupiter','Venus',STR_TO_DATE('2020-01-14 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (192,'Merkur','Neptun',STR_TO_DATE('2020-01-14 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (193,'Saturn','Uranus',STR_TO_DATE('2020-01-14 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (194,'Mars','Erde',STR_TO_DATE('2020-01-14 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (195,'Venus','Jupiter',STR_TO_DATE('2020-01-14 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (196,'Venus','Jupiter',STR_TO_DATE('2020-01-14 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (197,'Venus','Jupiter',STR_TO_DATE('2020-01-14 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-15 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.flug Values (198,'Erde','Mars',STR_TO_DATE('2020-01-15 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (199,'Mars','Jupiter',STR_TO_DATE('2020-01-15 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (200,'Neptun','Venus',STR_TO_DATE('2020-01-15 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (201,'Merkur','Mars',STR_TO_DATE('2020-01-15 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (202,'Neptun','Saturn',STR_TO_DATE('2020-01-15 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (203,'Saturn','Merkur',STR_TO_DATE('2020-01-15 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (204,'Venus','Uranus',STR_TO_DATE('2020-01-15 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (205,'Jupiter','Venus',STR_TO_DATE('2020-01-15 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (206,'Merkur','Neptun',STR_TO_DATE('2020-01-15 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (207,'Saturn','Uranus',STR_TO_DATE('2020-01-15 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (208,'Mars','Erde',STR_TO_DATE('2020-01-15 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (209,'Venus','Jupiter',STR_TO_DATE('2020-01-15 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (210,'Venus','Jupiter',STR_TO_DATE('2020-01-15 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (211,'Venus','Jupiter',STR_TO_DATE('2020-01-15 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-16 19:00:00','%Y-%m-%d %H:%i:%s'));

Insert into dbs_spacetravel.person (SVNr,Vorname,Nachname,Passwort) Values (2788160497,'Christopher','Skallak', 'passwort');
Insert into dbs_spacetravel.person (SVNr,Vorname,Nachname,Passwort) Values (1234567890,'Michael','Stipsits', 'passwort');
Insert into dbs_spacetravel.person (SVNr,Vorname,Nachname,Passwort) Values (1234567891,'Bernhard','Schwicker', 'passwort');
Insert into dbs_spacetravel.person (SVNr,Vorname,Nachname,Passwort) Values (1234567892,'Gaurlal','Hothi', 'passwort');
Insert into dbs_spacetravel.person (SVNr,Vorname,Nachname,Passwort) Values (1234567893,'Marvin','Elevado', 'passwort');

Insert into dbs_spacetravel.telnr (SVNr,TelNr) Values (2788160497,1234567890);
Insert into dbs_spacetravel.telnr (SVNr,TelNr) Values (1234567890,1234567890);
Insert into dbs_spacetravel.telnr (SVNr,TelNr) Values (1234567891,1234567890);
Insert into dbs_spacetravel.telnr (SVNr,TelNr) Values (1234567892,1234567890);
Insert into dbs_spacetravel.telnr (SVNr,TelNr) Values (1234567893,1234567890);
Insert into dbs_spacetravel.telnr (SVNr,TelNr) Values (1234567893,1234509876);
Insert into dbs_spacetravel.telnr (SVNr,TelNr) Values (1234567893,1234569999);

Insert into dbs_spacetravel.passagier (SVNr) Values (1234567890);
Insert into dbs_spacetravel.passagier (SVNr) Values (2788160497);

Insert into dbs_spacetravel.bucht (SVNr,UserSVNr,Klasse,FlugNr,Buchungsdatum) Values (1234567890,1234567890,1, 2,STR_TO_DATE('2020-01-08 ','%Y-%m-%d '));
Insert into dbs_spacetravel.bucht (SVNr,UserSVNr,Klasse,FlugNr,Buchungsdatum) Values (1234567890,1234567890,2, 200,STR_TO_DATE('2020-01-08 ','%Y-%m-%d '));
Insert into dbs_spacetravel.bucht (SVNr,UserSVNr,Klasse,FlugNr,Buchungsdatum) Values (2788160497,1234567890,2, 200,STR_TO_DATE('2020-01-08 ','%Y-%m-%d '));


Insert into dbs_spacetravel.angestellte (SVNr,AngNr) Values (1234567891,1);
Insert into dbs_spacetravel.angestellte (SVNr,AngNr) Values (1234567892,2);
Insert into dbs_spacetravel.angestellte (SVNr,AngNr) Values (1234567893,3);

Insert into dbs_spacetravel.bank (BLZ,BankName) Values (14000,"BAWAG");
Insert into dbs_spacetravel.bank (BLZ,BankName) Values (19650,"DenizBank Wien");
Insert into dbs_spacetravel.bank (BLZ,BankName) Values (12000,"UniCredit Austria");
Insert into dbs_spacetravel.bank (BLZ,BankName) Values (19620,"Bank Mattersburg");

Insert into dbs_spacetravel.gehaltskonto (SVNr,KontoNr,BLZ,Kontostand) Values (1234567893,1,14000,10000);
Insert into dbs_spacetravel.gehaltskonto (SVNr,KontoNr,BLZ,Kontostand) Values (1234567892,2,19650,20000);
Insert into dbs_spacetravel.gehaltskonto (SVNr,KontoNr,BLZ,Kontostand) Values (1234567891,3,19620,30000);

Insert into dbs_spacetravel.hersteller (HerstellerName) Values ("Tardis");
Insert into dbs_spacetravel.hersteller (HerstellerName) Values ("Slave");

Insert into dbs_spacetravel.raumschifftyp (Hersteller,Sitzplätze,Begleitpersonal,Typenbezeichnung,TypenNr) Values ("Tardis",2000000000,"Dr Who","The infinite",123456);
Insert into dbs_spacetravel.raumschifftyp (Hersteller,Sitzplätze,Begleitpersonal,Typenbezeichnung,TypenNr) Values ("Slave",3,"Boba Fett","1",654321);

Insert into dbs_spacetravel.techniker (SVNr,LizenzNr,Ausbildungsgrad,TypenNr) Values (1234567891,1,"HTL",123456);
Insert into dbs_spacetravel.techniker (SVNr,LizenzNr,Ausbildungsgrad,TypenNr) Values (1234567893,2,"FH",654321);

Insert into dbs_spacetravel.kapitaen (Kapitaenspatent,Lichtjahre,SVNr) Values (1,111111,1234567893);

Insert into dbs_spacetravel.fliengen (FlugNr,SVNr,TypenNr) Values (100,1234567893,123456);
Insert into dbs_spacetravel.fliengen (FlugNr,SVNr,TypenNr) Values (50,1234567893,123456);
Insert into dbs_spacetravel.fliengen (FlugNr,SVNr,TypenNr) Values (51,1234567893,654321);
Insert into dbs_spacetravel.fliengen (FlugNr,SVNr,TypenNr) Values (200,1234567893,654321);


Insert into dbs_spacetravel.flug_wartet_auf (FlugDavor,FlugDanach) Values (100,110);
Insert into dbs_spacetravel.flug_wartet_auf (FlugDavor,FlugDanach) Values (150,200);
Insert into dbs_spacetravel.flug_wartet_auf (FlugDavor,FlugDanach) Values (10,20);

Insert into dbs_spacetravel.raumschiffexemplar (InvNr,Lichtjahre,Fertigungsjahr,TypenNr,Code) Values (1,20,2020,123456,666);
Insert into dbs_spacetravel.raumschiffexemplar (InvNr,Lichtjahre,Fertigungsjahr,TypenNr,Code) Values (2,500,2421,654321,999);