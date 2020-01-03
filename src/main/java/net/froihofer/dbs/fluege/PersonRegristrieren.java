/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package net.froihofer.dbs.fluege;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.PersistenceException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import net.froihofer.dbs.fluege.entities.Passagier;
import net.froihofer.dbs.fluege.entities.Person;
import static net.froihofer.dbs.weine.NeuerWein.ERROR_MSG_PARAM;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author joseph
 */
public class PersonRegristrieren extends HttpServlet{
    
  private static final Logger log = LoggerFactory.getLogger(PersonRegristrieren.class);
  public static final String ERROR_MSG_PARAM = "BUCHUNG_SPEICHERUNG_FEHLERMELDUNG";
  public static final String SUCCESS_MSG_PARAM = "BUCHUNG_SPEICHERUNG_ERFOLGSMELDUNG";
  //public static final String PASSAGIER = "PASSAGIER_ENTRY";
  private EntityManagerFactory emf;
  
  @Override
  public void init() throws ServletException {
    super.init();
    emf = Persistence.createEntityManagerFactory("dbs-fluege");
  }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String name = req.getParameter("vorname");
    String name2 = req.getParameter("nachname");
    String nummer = req.getParameter("svnr");
    String plznummer = req.getParameter("plz");
    String hausnummer = req.getParameter("hausnummer");
    String ort = req.getParameter("ort");
    String strasse = req.getParameter("strasse");
    PrintWriter pw = resp.getWriter();
    List<String> telefonnummern = new ArrayList<String>();
    telefonnummern.add(req.getParameter("telefonnummer1"));
    telefonnummern.add(req.getParameter("telefonnummer2"));
    telefonnummern.add(req.getParameter("telefonnummer3"));
    telefonnummern.add(req.getParameter("telefonnummer4"));
    telefonnummern.add(req.getParameter("telefonnummer5"));
    int svnrlength = nummer.length();
    
    if (StringUtils.isBlank(name)) {
        req.setAttribute(ERROR_MSG_PARAM,"Vorname darf nicht leer sein.");
        req.getRequestDispatcher("/Regristrieren.jsp").forward(req, resp);
        return;
    }
    else if (StringUtils.isBlank(name2)) {
        req.setAttribute(ERROR_MSG_PARAM,"Nachname darf nicht leer sein.");
        req.getRequestDispatcher("/Regristrieren.jsp").forward(req, resp);
        return;
    }
    else if (StringUtils.isBlank(nummer)) {
        req.setAttribute(ERROR_MSG_PARAM,"Sozialversicherungsnummer darf nicht leer sein.");
        req.getRequestDispatcher("/Regristrieren.jsp").forward(req, resp);
        return;
    }
    if (svnrlength != 12) {
        req.setAttribute(ERROR_MSG_PARAM,"Die Anzahl des Zeichens ist nicht gleich zwölf.");
        req.getRequestDispatcher("/Regristrieren.jsp").forward(req, resp);
        return;
    }
    
    if (StringUtils.isNotBlank(plznummer) && plznummer.length() > 9){
        req.setAttribute(ERROR_MSG_PARAM,"Zahl ist länger als neun Zeichen.");
        req.getRequestDispatcher("/Regristrieren.jsp").forward(req, resp);
        return;
    }
    if(!telefonnummern.isEmpty()){
        for(String n:telefonnummern){
            if (n.length() > 9){
            req.setAttribute(ERROR_MSG_PARAM,"Einer der Telefonnummern hat mehr als neun Zeichen.");
            req.getRequestDispatcher("/Regristrieren.jsp").forward(req, resp);
            return;
            }
        }
    }  
    Long svnr = Long.valueOf(nummer);
    Integer plz;
    if(NumberUtils.isNumber(plznummer)) plz = Integer.valueOf(plznummer);
    else plz = null;
    Person person = new Person(svnr, name, name2, plz, ort, strasse, hausnummer);
    try{
        createPassagier(person);
        if(!telefonnummern.isEmpty()) createTelefonnummer(person, telefonnummern);
        req.setAttribute(SUCCESS_MSG_PARAM, "Person \""+person.getVorname()+"\" wurde erfolgreich gespeichert.");
    } catch(Exception e){
       log.error("Fehler beim Regristrieren.",e);
       req.setAttribute(ERROR_MSG_PARAM, e.getMessage());
    }
    req.getRequestDispatcher("/Regristrieren.jsp").forward(req, resp);
  }
  private void createPassagier(Person person) throws PersistenceException {
      Passagier passagier = new Passagier(person.getSVNr());
      Connection con = null;
      try{
        InitialContext ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");
        con = ds.getConnection();
        
        String sqlStr = "INSERT INTO Person (SVNr, Vorname, Nachname, PLZ, Ort, Straße, HausNr) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sqlStr);
        ps.setLong(1, person.getSVNr());
        ps.setString(2, person.getVorname());
        ps.setString(3, person.getNachname());
        if(person.getPLZ() != null){
            ps.setInt(4, person.getPLZ());
        } else {
            ps.setNull(4, Types.INTEGER);
        }
        if(person.getOrt() != null){
            ps.setString(5, person.getOrt());
        } else {
            ps.setNull(5, Types.VARCHAR);
        }
        if(person.getStraße() != null){
            ps.setString(6, person.getStraße());
        } else {
            ps.setNull(6, Types.VARCHAR);
        }
        if(person.getHausNr() != null){
            ps.setString(7, person.getHausNr());
        } else {
            ps.setNull(7, Types.VARCHAR);
        }
        
        int count = ps.executeUpdate();
        if (count != 1) {
            throw new PersistenceException("Unbekannter Fehler beim Speichern des neuen Persons (updateCount = 0).");
        }
        
        //Passagierupdate
        sqlStr = "INSERT INTO Passagier (SVNr) " + "VALUES (?)";
        ps = con.prepareStatement(sqlStr);
        //ps.setInt(1, passagier.getPasNr());
        ps.setLong(1, passagier.getSVNr());
        count = ps.executeUpdate();
        if (count != 1) {
            throw new PersistenceException("Unbekannter Fehler beim Speichern des Persons als Passagier (updateCount = 0).");
        }
        
      } catch (Exception e) {
      throw new PersistenceException("Fehler beim Regristrieren: " + e.getMessage(), e);
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
  
  private void createTelefonnummer(Person person, List<String> nummern){
      Connection con = null;
      try{
          InitialContext ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");
        con = ds.getConnection();
        for(String n:nummern){
            if(NumberUtils.isNumber(n)){
                String sqlStr = "INSERT INTO TelNr (SVNr, TelNr) "
                    + "VALUES (?, ?)";
                PreparedStatement ps = con.prepareStatement(sqlStr);
                ps.setLong(1, person.getSVNr());
                ps.setInt(2, Integer.parseInt(n));
                int count = ps.executeUpdate();
                if (count != 1) {
                    throw new PersistenceException("Unbekannter Fehler beim Speichern der Telefonnummer (updateCount = 0).");
                }
            } 
        }
      } catch (Exception e) {
            throw new PersistenceException("Fehler beim Regristrieren: " + e.getMessage(), e);
      }
  }
}
