package net.froihofer.dbs.fluege.entities;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Entity
@Table(name="passagier")
public class Passagier implements Serializable {
  private static final Logger log = LoggerFactory.getLogger(Passagier.class);

  @Id
  @GeneratedValue
  private Integer PasNr;
  private Long SVNr;


  //No arguments constructor required for entity class
  public Passagier(){}
  
  public Passagier(Long SVNr) {
    this.SVNr = SVNr;
  }
  
  public Integer getPasNr() {
    return PasNr;
  }
 
  public Long getSVNr() {
    return SVNr;
  }

  public void setSVNr(Long SVNr) {
    this.SVNr = SVNr;
  }
  
}
