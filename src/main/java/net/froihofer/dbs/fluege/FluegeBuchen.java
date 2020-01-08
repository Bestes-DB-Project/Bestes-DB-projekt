package net.froihofer.dbs.fluege;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.PersistenceException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

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
  public static final String ERROR_MSG_PARAM = "";
  public static final String SUCCESS_MSG_PARAM = "";
  

  private EntityManagerFactory emf;
  
  @Override
  public void init() throws ServletException {
    super.init();
    emf = Persistence.createEntityManagerFactory("dbs-fluege");
  }
  
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    Connection con = null;

    PrintWriter pw = resp.getWriter();
    String ErrorMSG = "";
    String WarningMSG = "";
    Boolean createperson = false;
    Boolean submit = false;
    Boolean abort = false;
    
    if(req.getParameter("Submit")!= null && req.getParameter("Userid")!= null)
    {
        submit = (req.getParameter("Submit").equals("1")) ? true : false;
    }
    
    if(!submit)
    {
        int i = 2;
        if(req.getParameter("Vorname")!= null)
        {
            String[] vorname = req.getParameterValues("Vorname");
            for (String name : vorname) 
            { 
               log.error("Vorname = " + name);
            }
        }
        req.getRequestDispatcher("/Fluege-Buchen.jsp").forward(req, resp);
    }
    else
    {
        if(req.getParameter("SVNr")!= null && req.getParameter("Vorname")!= null && req.getParameter("Nachname")!= null && req.getParameter("Klasse")!= null && req.getParameter("flugnr")!= null && req.getParameter("Userid")!= null )
        {
            String[] arrSVNr = req.getParameterValues("SVNr");
            String[] arrVorname = req.getParameterValues("Vorname");
            String[] arrNachname = req.getParameterValues("Nachname");
            
            Integer FlugNr = Integer.parseInt(req.getParameter("flugnr"));
            Integer klasse = Integer.parseInt(req.getParameter("Klasse"));
            Long Userid = Long.parseLong(req.getParameter("Userid"));
            Date Buchungsdatum = new Date(System.currentTimeMillis());
            
            if(arrSVNr.length ==  arrVorname.length && arrSVNr.length ==  arrNachname.length)
            {   

                for(int i = 0; i < arrVorname.length; i++)
                {
                    abort = false;
                    
                    Long SVNr = Long.parseLong(arrSVNr[i]);
                    String vorname = arrVorname[i];
                    String nachname = arrNachname[i];;
                    
                    
                    Person person = new Person(SVNr, vorname, nachname);            
                    Passagier passagier = new Passagier(SVNr);
                    Buchung buchung = new Buchung(klasse, Buchungsdatum, SVNr, Userid, FlugNr);
                    
                    //Check if Person already exists or is valid

                    try {
                        InitialContext ctx = new InitialContext();
                        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");
                        con = ds.getConnection();


                        String Query = "SELECT Vorname, Nachname FROM person WHERE SVNr = ?";
                        PreparedStatement psm = con.prepareStatement(Query);
                        psm.setString(1, SVNr.toString());
                        ResultSet rs = psm.executeQuery();
                        

                        
                        if(rs.next())
                        {

                            createperson = false;
                            if(!rs.getString("Vorname").equals(person.getVorname()) && !rs.getString("Nachname").equals(person.getNachname()))
                            {
                                log.error("Person sitmmt nicht mit der Person indatenban überein:" + rs.getString("Vorname"));
                                WarningMSG = WarningMSG + "Die Datent der" + person.getVorname() +" " + person.getNachname() + "stimmt nicht mit der Person aus der Datenbank mit selbiger SVNr überein: <br> Die Buchung wurde für die in der Datenbank angelegten Person gebucht <br>";
                                person.setVorname(rs.getString("Vorname"));
                                person.setNachname(rs.getString("Nachname"));
                            }
                        }
                        else
                        {
                            createperson = true;
                        }
                    }
                    catch (Exception e){ throw new PersistenceException("Fehler beim Suchen der Person: " + e.getMessage(), e);}
                    finally {
                      try {con.close();}
                      catch (Exception e) {log.debug("Fehler beim Schließen der Connection.", e);}
                    }

                    //Check if Person already booked this flight
                    try {
                        InitialContext ctx = new InitialContext();
                        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");
                        con = ds.getConnection();


                        String Query = "SELECT * FROM bucht WHERE SVNr = ? and FlugNr = ?";
                        PreparedStatement psm = con.prepareStatement(Query);
                        psm.setString(1, buchung.getSVNr().toString());
                        psm.setString(2, buchung.getFlugNr().toString());
                        ResultSet rs = psm.executeQuery();
                        
                        
                        if(rs.next())
                        {
                            log.error("Person hat diesen Flug schon gebucht" + person.getVorname());
                            ErrorMSG = ErrorMSG + "Person hat diesen Flug schon gebucht:" + person.getVorname() +" " + person.getNachname() + "<br>";
                            abort = true;
                        }
                    }
                    catch (Exception e){throw new PersistenceException("Person hat diesen Flug schon gebucht: " + e.getMessage(), e);}
                    finally {
                      try {con.close();}
                      catch (Exception e) {log.debug("Fehler beim Schließen der Connection.", e);}
                    }                    
                    
                    try {
                      if(!abort){
                        if(createperson)
                        {
                          persistPerson(person);
                        }
                        persistPassagier(passagier);
                        persistBuchung(buchung);
                        
                        log.error("Buchung wurde erfolgreich bearbeitet fur: " + person.getVorname());
                      }
                    }
                    catch (Exception e) {
                      log.error("Fehler beim bearbeiten der Buchung für Person " + person.getVorname(),e);
                      req.setAttribute(ERROR_MSG_PARAM, e.getMessage());
                    }
                    if(!ErrorMSG.equals("")){req.setAttribute(ERROR_MSG_PARAM, ErrorMSG);}
                    if(!WarningMSG.equals("")){req.setAttribute(ERROR_MSG_PARAM, WarningMSG);}
                    req.getRequestDispatcher("/meineFluege.jsp").forward(req, resp);
                }  
            }
        }
    }
  }
  
    
    
    
  private void persistPassagier(Passagier passagier) throws PersistenceException {
    Connection con = null;
    try {
    InitialContext ctx = new InitialContext();
    DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/FluegeDB");
    
    con = ds.getConnection();
    String sqlStr = "INSERT INTO passagier (SVNr) VALUES (?)";
      PreparedStatement ps = con.prepareStatement(sqlStr);
      ps.setLong(1, passagier.getSVNr());
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
      ps.setLong(1, person.getSVNr());
      ps.setString(2, person.getVorname());
      ps.setString(3, person.getNachname());
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
    String sqlStr = "INSERT INTO bucht (Klasse, Buchungsdatum, SVNr, UserSVNr, FlugNr) VALUES (?, ?, ?, ?, ?)";
      PreparedStatement ps = con.prepareStatement(sqlStr);
      ps.setInt(1, buchung.getKlasse());
      ps.setDate(2, buchung.getBuchungsdatum());
      ps.setLong(3, buchung.getSVNr());
      ps.setLong(4, buchung.getSVNrAuftraggeber());
      ps.setInt(5, buchung.getFlugNr());
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
