package net.froihofer.dbs.fluege.entities;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Entity
@Table(name = "person")
public class Person implements Serializable {

    private static final Logger log = LoggerFactory.getLogger(Person.class);

    @Id
    private Long SVNr;
    private String vorname;
    private String nachname;
    private Integer PLZ;
    private String ort;
    private String straße;
    private String hausNr;
    private String passwort;

    //No arguments constructor required for entity class
    public Person() {
    }

    public Person(Long SVNr, String vorname, String nachname, Integer PLZ, String ort, String straße, String hausNr, String passwort) {
        this.SVNr = SVNr;
        this.vorname = vorname;
        this.nachname = nachname;
        this.PLZ = PLZ;
        this.ort = ort;
        this.straße = straße;
        this.hausNr = hausNr;
        this.passwort = passwort;
    }

    public Person(Long SVNr, String vorname, String nachname) {
        this.SVNr = SVNr;
        this.vorname = vorname;
        this.nachname = nachname;
    }

    public Long getSVNr() {
        return SVNr;
    }

    public void setSVNr(Long SVNr) {
        this.SVNr = SVNr;
    }

    public String getVorname() {
        return vorname;
    }

    public void setVorname(String vorname) {
        this.vorname = vorname;
    }

    public String getNachname() {
        return nachname;
    }

    public void setNachname(String nachname) {
        this.nachname = nachname;
    }

    public Integer getPLZ() {
        return PLZ;
    }

    public void setPLZ(Integer PLZ) {
        this.PLZ = PLZ;
    }

    public String getOrt() {
        return ort;
    }

    public void setOrt(String ort) {
        this.ort = ort;
    }

    public String getStraße() {
        return straße;
    }

    public void setStraße(String straße) {
        this.straße = straße;
    }

    public String getHausNr() {
        return hausNr;
    }

    public void setHausNr(String hausNr) {
        this.hausNr = hausNr;
    }
    
    public String getPasswort() {
        return passwort;
    }

    public void setPasswort (String passwort) {
        this.passwort = passwort;
    }
}
