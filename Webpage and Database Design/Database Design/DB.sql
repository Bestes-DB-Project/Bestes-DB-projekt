Create Database  dbs_spacetravel;
Use dbs_spacetravel;

Create Table Person (
    SVNr INT NOT NULL,
    Vorname varchar(30) NOT NULL,
    Nachname varchar(30) NOT NULL,
    PLZ INT,
    Ort varchar(30),
    Straße varchar(50),
    HausNr varchar(20),
    CONSTRAINT PERSON_PK PRIMARY KEY (SVNr)
);

Create Table TelNr (
    SVNr INT NOT NULL,
    TelNr INT NOT NULL,
    CONSTRAINT TelNr_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Person(SVNr),
    CONSTRAINT TelNr_PK PRIMARY KEY (TelNr,SVNr)
);

Create Table Passagier (
    PasNr INT NOT NULL AUTO_INCREMENT,
    SVNr INT NOT NULL,
    CONSTRAINT Passagier_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Person(SVNr),
    CONSTRAINT Passagier_PK PRIMARY KEY (PasNr)
);

Create Table Angestellte (
    AngNr INT NOT NULL,
    SVNr INT NOT NULL,
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
    SVNr INT NOT NULL,
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
    SVNr INT NOT NULL,
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
    SVNr INT NOT NULL,
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
    SVNr INT NOT NULL,
    FlugNr INT NOT NULL,
    CONSTRAINT Bucht_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Passagier(SVNr),
    CONSTRAINT Bucht_FlugNr_FK FOREIGN KEY (FlugNr) REFERENCES Flug(FlugNr),
    CONSTRAINT Bucht_Unique UNIQUE (BuchungsNr),
    CONSTRAINT Bucht_PK PRIMARY KEY (SVNr,FlugNr)
);

Create Table Techniker (
    LizenzNr INT NOT NULL,
    Ausbildungsgrad varchar(30),
    SVNr INT NOT NULL,
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
    SVNr INT NOT NULL,
    CONSTRAINT Raumschiffexemplar_TypenNr_FK FOREIGN KEY (TypenNr) REFERENCES Raumschifftyp(TypenNr),
    CONSTRAINT Raumschiffexemplar_SVNr_FK FOREIGN KEY (SVNr) REFERENCES Angestellte(SVNr),
    CONSTRAINT Raumschiffexemplar_Unique UNIQUE (Code),
    CONSTRAINT Raumschiffexemplar_PK PRIMARY KEY (TypenNr,InvNr)
);

Insert into dbs_spacetravel.flug Values (1,'Earth','Earth',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);