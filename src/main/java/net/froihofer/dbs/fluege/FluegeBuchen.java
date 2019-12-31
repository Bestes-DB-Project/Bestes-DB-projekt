package net.froihofer.dbs.fluege;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;

import java.sql.Types;
import java.util.List;
import javax.naming.InitialContext;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.PersistenceException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;


import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static net.froihofer.dbs.fluege.FluegeBuchen.ERROR_MSG_PARAM;
import static net.froihofer.dbs.fluege.FluegeBuchen.SUCCESS_MSG_PARAM;
import net.froihofer.dbs.fluege.entities.Buchung;
import net.froihofer.dbs.fluege.entities.Person;
import net.froihofer.dbs.fluege.entities.Passagier;
import java.sql.Date;
import java.sql.ResultSet;




public class FluegeBuchen extends HttpServlet {

  private static final Logger log = LoggerFactory.getLogger(FluegeBuchen.class);
  public static final String ERROR_MSG_PARAM = "BUCHUNG_SPEICHERUNG_FEHLERMELDUNG";
  public static final String SUCCESS_MSG_PARAM = "BUCHUNG_SPEICHERUNG_ERFOLGSMELDUNG";

  private EntityManagerFactory emf;
  
  @Override
  public void init() throws ServletException {
    super.init();
    emf = Persistence.createEntityManagerFactory("dbs-fluege");
  }
  
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Connection con = null;
    Boolean createperson = false;
    PrintWriter pw = resp.getWriter();
    

    Integer SVNr = Integer.parseInt(req.getParameter("SVNr"));
    String vorname = req.getParameter("Vorname");
    String nachname = req.getParameter("Nachname");
    Person person = new Person(SVNr, vorname, nachname);

    Passagier passagier = new Passagier(SVNr);
    
    //Integer klasse = Integer.parseInt(req.getParameter("klasse"));
    Integer klasse = 1;
    Date Buchungsdatum = new Date(System.currentTimeMillis()); 
    Integer FlugNr = 2;
    //Integer FlugNr = Integer.parseInt(req.getParameter("FlugNr"));
    Buchung buchung = new Buchung(klasse, Buchungsdatum, SVNr, FlugNr);
    
    
    
    try {
        InitialContext ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");
        con = ds.getConnection();
        
        Statement statement = con.createStatement();
        //ps.setInt(1, SVNr);
        ResultSet rs = statement.executeQuery("SELECT Vorname, Nachname FROM person WHERE SVNr =" + SVNr);
        if(rs.next())
        {
            log.error("Version:" + rs.getString(1));
            createperson = false;
        }
        else
        {
            createperson = true;
        }
        
        
    }
    catch (Exception e){
        throw new PersistenceException("Fehler beim Suchen der Person: " + e.getMessage(), e);
    }
    finally {
      try {
        con.close();
      }
      catch (Exception e) {
        log.debug("Fehler beim Schließen der Connection.", e);
      }
    }

    try {
      if(createperson)
      {
        persistPerson(person);
      }
      persistPassagier(passagier);
      persistBuchung(buchung);
      
      req.setAttribute(SUCCESS_MSG_PARAM, "Buchung wurde erfolgreich bearbeitet");      
    }
    catch (Exception e) {
      log.error("Fehler beim bearbeiten der Buchung.",e);
      req.setAttribute(ERROR_MSG_PARAM, e.getMessage());
    }
    //req.setAttribute(WEINE, getWeineFromWeingut(wein.getErzeuger().getWeingut()));
    req.getRequestDispatcher("/Fluege-Buchen.jsp").forward(req, resp);
  }
  
  private void persistPassagier(Passagier passagier) throws PersistenceException {
    Connection con = null;
    try {
    InitialContext ctx = new InitialContext();
    DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");
    
    con = ds.getConnection();
    String sqlStr = "INSERT INTO passagier (SVNr) VALUES (?)";
      PreparedStatement ps = con.prepareStatement(sqlStr);
      ps.setInt(1, passagier.getSVNr());
      int count = ps.executeUpdate();
      if (count != 1) {
        throw new PersistenceException("Unbekannter Fehler beim Speichern des neuen Passagiers (updateCount = 0).");
      }
    }
    catch (Exception e) {
      throw new PersistenceException("Fehler beim Anlegen des Passagiers: " + e.getMessage(), e);
    }
    finally {
      try {
        con.close();
      }
      catch (Exception e) {
        log.debug("Fehler beim Schließen der Connection.", e);
      }
    }
  }
  
  private void persistPerson(Person person) throws PersistenceException {
    Connection con = null;
    try {
    InitialContext ctx = new InitialContext();
    DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");

    con = ds.getConnection();
    String sqlStr = "INSERT INTO person (SVNr, Vorname, Nachname) VALUES (?,?,?)";
      PreparedStatement ps = con.prepareStatement(sqlStr);
      ps.setInt(1, person.getSVNr());
      ps.setString(2, person.getVorname());
      ps.setString(3, person.getNnachname());
      int count = ps.executeUpdate();
      if (count != 1) {
        throw new PersistenceException("Unbekannter Fehler beim Speichern des neuen Person (updateCount = 0).");
      }
    }
    catch (Exception e) {
      throw new PersistenceException("Fehler beim Anlegen der Person: " + e.getMessage(), e);
    }
    finally {
      try {
        con.close();
      }
      catch (Exception e) {
        log.debug("Fehler beim Schließen der Connection.", e);
      }
    }
  }
  
  
  private void persistBuchung(Buchung buchung) throws PersistenceException {
    Connection con = null;
    try {
    InitialContext ctx = new InitialContext();
    DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");

    con = ds.getConnection();
    String sqlStr = "INSERT INTO bucht (Klasse, Buchungsdatum, SVNr, FlugNr) VALUES (?, ?, ?, ?)";
      PreparedStatement ps = con.prepareStatement(sqlStr);
      ps.setInt(1, buchung.getKlasse());
      ps.setDate(2, buchung.getBuchungsdatum());
      ps.setInt(3, buchung.getSVNr());
      ps.setInt(4, buchung.getFlugNr());
      int count = ps.executeUpdate();
      if (count != 1) {
        throw new PersistenceException("Unbekannter Fehler beim Speichern der neuen Buchung (updateCount = 0).");
      }
    }
    catch (Exception e) {
      throw new PersistenceException("Fehler beim Anlegen der Buchung: " + e.getMessage(), e);
    }
    finally {
      try {
        con.close();
      }
      catch (Exception e) {
        log.debug("Fehler beim Schließen der Connection.", e);
      }
    }
  }
}
