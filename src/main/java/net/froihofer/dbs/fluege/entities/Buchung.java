package net.froihofer.dbs.fluege.entities;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Date;

@Entity
@Table(name="bucht")
public class Buchung implements Serializable {
  private static final Logger log = LoggerFactory.getLogger(Buchung.class);

  @Id
  @GeneratedValue
  private Integer buchungsNr;
  private Integer klasse;
  private Date buchungsdatum;
  private Long SVNr;
  private Integer FlugNr;
  
  //No arguments constructor required for entity class
  public Buchung(){}
  
  public Buchung(Integer klasse, Date buchungsdatum, Long SVNr, Integer FlugNr) {
    this.klasse = klasse;
    this.buchungsdatum = buchungsdatum;
    this.SVNr = SVNr;
    this.FlugNr = FlugNr;
  }
  
  public Integer getBuchungsNr() {
    return buchungsNr;
  }

  public Integer getKlasse() {
    return klasse;
  }
  
  public void setKlasse(Integer klasse) {
    this.klasse = klasse;
  }

  public Date getBuchungsdatum() {
    return buchungsdatum;
  }

  public void setBuchungsdatum(Date buchungsdatum) {
    this.buchungsdatum = buchungsdatum;
  }  

  public Long getSVNr() {
    return SVNr;
  }

  public void setSVNr(Long SVNr) {
    this.SVNr = SVNr;
  }  

  public Integer getFlugNr() {
    return FlugNr;
  }

  public void setFlugNr(Integer FlugNr) {
    this.FlugNr = FlugNr;
  }  
}