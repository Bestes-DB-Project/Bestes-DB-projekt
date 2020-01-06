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
    CONSTRAINT PERSON_PK PRIMARY KEY (SVNr)
);

Create Table TelNr (
    SVNr BIGINT NOT NULL,
    TelNr INT NOT NULL,
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
    SVNr BIGINT NOT NULL,
    CONSTRAINT Raumschiffexemplar_TypenNr_FK FOREIGN KEY (TypenNr) REFERENCES Raumschifftyp(TypenNr),
    CONSTRAINT Raumschiffexemplar_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Angestellte(SVNr),
    CONSTRAINT Raumschiffexemplar_Unique UNIQUE (Code),
    CONSTRAINT Raumschiffexemplar_PK PRIMARY KEY (TypenNr,InvNr)
);

Insert into dbs_spacetravel.flug Values (1,'Erde','Erde',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
Insert into dbs_spacetravel.flug Values (2,'Erde','Mars',STR_TO_DATE('2020-01-07 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 13:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (3,'Mars','Jupiter',STR_TO_DATE('2020-01-08 12:20:10','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-08 22:15:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (4,'Neptun','Venus',STR_TO_DATE('2020-01-08 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 15:45:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (5,'Merkur','Mars',STR_TO_DATE('2020-01-08 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-09 23:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (6,'Neptun','Saturn',STR_TO_DATE('2020-01-09 14:30:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 09:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (7,'Saturn','Merkur',STR_TO_DATE('2020-01-10 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-10 23:30:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (8,'Venus','Uranus',STR_TO_DATE('2020-01-10 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-12 13:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (9,'Jupiter','Venus',STR_TO_DATE('2020-01-11 13:12:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-11 12:39:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (10,'Merkur','Neptun',STR_TO_DATE('2020-01-12 18:13:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 20:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (11,'Saturn','Uranus',STR_TO_DATE('2020-01-12 12:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 12:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (12,'Mars','Erde',STR_TO_DATE('2020-01-12 16:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 17:33:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (13,'Venus','Jupiter',STR_TO_DATE('2020-01-13 13:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 15:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (14,'Venus','Jupiter',STR_TO_DATE('2020-01-13 15:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 17:00:00','%Y-%m-%d %H:%i:%s'));
Insert into dbs_spacetravel.flug Values (15,'Venus','Jupiter',STR_TO_DATE('2020-01-13 17:00:00','%Y-%m-%d %H:%i:%s'),STR_TO_DATE('2020-01-14 19:00:00','%Y-%m-%d %H:%i:%s'));


Insert into dbs_spacetravel.person (SVNr,Vorname,Nachname) Values (2788160497,'Christopher','Skallak');